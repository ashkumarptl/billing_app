import 'package:billing_app/provider/selecteditem_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../provider/item_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../utility/add_item.dart';
import 'bill_screen.dart';

class SelectItem extends ConsumerStatefulWidget {
  const SelectItem({super.key});

  @override
  ConsumerState<SelectItem> createState() => _SelectItemState();
}

class _SelectItemState extends ConsumerState<SelectItem> {
  late TextEditingController searchCtrl;

  @override
  void initState() {
    super.initState();
    searchCtrl = TextEditingController(text: ref.read(searchQueryProvider));
    searchCtrl.addListener(() {
      ref.read(searchQueryProvider.notifier).state = searchCtrl.text;
    });
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(filteredItemsProvider);
    final isClicked = ref.watch(isSearchProvider);
    final notifier = ref.read(itemsProvider.notifier);
    final selectNotifier = ref.read(selectedItemsProvider.notifier);
    final selectedItems = ref.watch(selectedItemsProvider);
    final isEditable = ref.watch(isEditableProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title:
              isClicked
                  ? Container(
                    alignment: Alignment.center,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: searchCtrl,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(16, 0, 0, 10),
                        hintText: 'Search....',
                        border: InputBorder.none,
                      ),
                    ),
                  )
                  : Text(
                    isEditable ? 'Edite Mode' : 'Products',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
          actions: [
            IconButton(
              onPressed: () {
                ref.read(isSearchProvider.notifier).state = !isClicked;
                searchCtrl.clear();
                ref.read(searchQueryProvider.notifier).state = '';
                ref.read(filterOptionProvider.notifier).state = 'All';
              },
              icon: Icon(isClicked ? Icons.close : Icons.search),
            ),
            IconButton(
              onPressed: () {
                ref.read(isEditableProvider.notifier).state = !isEditable;
                if (!isEditable) {
                  ref.read(selectedItemsProvider.notifier).clearSelectedItems();
                }
              },
              icon: Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                showItemBottomSheet(context, selectNotifier,notifier);
              },
              icon: Icon(Icons.add),
            ),
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  isClicked
                      ? DropdownButtonFormField<String>(
                        value: ref.watch(filterOptionProvider),
                        items: const [
                          DropdownMenuItem(value: 'All', child: Text('All')),
                          DropdownMenuItem(
                            value: 'Low Quantity',
                            child: Text('Low Quantity (≤5)'),
                          ),
                          DropdownMenuItem(
                            value: 'Price > 100',
                            child: Text('Price > ₹100'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            ref.read(filterOptionProvider.notifier).state = value;
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: 'Filter',
                          border: OutlineInputBorder(),
                        ),
                      )
                      : SizedBox(),
                ],
              ),
            ),
            Expanded(
              child:
                  items.isEmpty
                      ? const Center(child: Text('No matching items found'))
                      : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final isSelected = selectedItems.any(
                            (e) => e.id == item.id,
                          );
      
                          return InkWell(
                            onTap: () {
                              if (!isEditable) {
                                ref
                                    .read(selectedItemsProvider.notifier)
                                    .toggleItem(item);
                              }
                              if (isEditable)
                                ref.read(isEditableProvider.notifier).state =
                                    !isEditable;
                            },
                            onLongPress: () {
                              ref.read(selectedItemsProvider.notifier).clearSelectedItems();
                              showItemBottomSheet(
                                context,
                                ref.read(selectedItemsProvider.notifier),
                                ref.read(itemsProvider.notifier),
                                item,
                              );
                            },
      
                            child: Card(
                              elevation: 4,
                              color:
                                  isSelected
                                      ? Colors.green.shade50
                                      : Colors.white,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Image
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 50,
                                          backgroundImage:
                                              item.image != null
                                                  ? FileImage(File(item.image!))
                                                  : null,
                                          child:
                                              item.image == null
                                                  ? const Icon(
                                                    Icons.image,
                                                    size: 28,
                                                  )
                                                  : null,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 12),
      
                                    // Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  item.productName,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "₹${item.price.toStringAsFixed(1)} x ${(item.quantity).toStringAsFixed(3)} = ${(item.price * item.quantity).toStringAsFixed(2)}",
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          if (item.unit != null &&
                                              item.unit!.isNotEmpty)
                                            Text(
                                              "Unit: ${item.unit!}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          if (item.category.isNotEmpty)
                                            Text(
                                              "Category: ${item.category}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
      
                                    // Controls
                                    if (isEditable)
                                    PopupMenuButton<String>(
                                      onSelected: (value) {
                                        if (value == 'edit') {
                                          showItemBottomSheet(
                                            context,
                                            ref.read(selectedItemsProvider.notifier),
                                            ref.read(itemsProvider.notifier),
                                            item,
                                          );
                                        } else if (value == 'delete') {
                                          ref
                                              .read(itemsProvider.notifier)
                                              .deleteItem(item.id);
                                        }
                                      },
                                      itemBuilder:
                                          (context) => [
                                            const PopupMenuItem(
                                              value: 'edit',
                                              child: Text('Edit'),
                                            ),
                                            const PopupMenuItem(
                                              value: 'delete',
                                              child: Text('Delete'),
                                            ),
                                          ],
                                      icon: const Icon(Icons.more_vert),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton.extended(
              onPressed: () {
                final selectedItems = ref.read(selectedItemsProvider);
                if (selectedItems.isEmpty) {
                  Fluttertoast.showToast(msg: "No item selected");
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BillScreen(items: selectedItems),
                    ),
                  ).then((_) {
                    // Reset quantities to 1
                    // for (final item in selectedItems) {
                    //   ref.read(itemsProvider.notifier).setQuantity(item.id, 1);
                    // }
                    // ref.read(selectedItemsProvider.notifier).resetQuantity();
      
                    // Clear selected items
                    ref.read(selectedItemsProvider.notifier).clearSelectedItems();
                  });
                }
              },
              label: const Text(
                "Generate Bill",
                style: TextStyle(color: Colors.white),
              ),
              icon: const Icon(Icons.receipt_long, color: Colors.white),
              backgroundColor: Colors.deepPurple,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
