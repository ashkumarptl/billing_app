import 'dart:io';
import 'package:flutter/material.dart';
import '../model/item_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../provider/item_provider.dart';

void showItemBottomSheet(
  BuildContext context,
  ItemNotifier notifier, [Items? existing,]) {
  final picker = ImagePicker();
  final productNameCtrl = TextEditingController(
    text: existing?.productName ?? '',
  );
  final priceCtrl = TextEditingController(
    text: existing?.price.toString() ?? '',
  );
  String category = existing?.category ?? 'Category';
  String unit = existing?.unit ?? 'Kg';
  final quantityCtrl = TextEditingController(
    text: existing?.quantity.toString() ?? '',
  );
  final marpCtrl = TextEditingController(text: existing?.mrp.toString() ?? '');
  final purchasePriceCtrl = TextEditingController(
    text: existing?.purchasePrice.toString() ?? '',
  );
  List<String> selectedImagePaths =
      existing?.image != null ? [existing!.image!] : ['asset/images/img_1.png'];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          Future<void> pickImages() async {
            final pickedFiles = await picker.pickMultiImage();
            if (pickedFiles.isNotEmpty) {
              setState(() {
                // If the default asset image is still in the list, remove it
                if (selectedImagePaths.length == 1 &&
                    selectedImagePaths[0].startsWith('asset/')) {
                  selectedImagePaths.clear();
                }
                selectedImagePaths.addAll(
                  pickedFiles.map((xfile) => xfile.path),
                );
              });
            }
          }

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 16,
              left: 16,
              right: 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      existing == null ? 'Add New Item' : 'Edit Item',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: pickImages,
                      child:
                          selectedImagePaths.isEmpty ||
                                  (selectedImagePaths.length == 1 &&
                                      selectedImagePaths[0].startsWith(
                                        'asset/',
                                      ))
                              ? CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage(
                                  selectedImagePaths.isNotEmpty
                                      ? selectedImagePaths[0]
                                      : 'asset/images/img_1.png',
                                ),
                                child: Icon(Icons.add_a_photo),
                              )
                              : SizedBox(
                                height: 100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      selectedImagePaths.length +
                                      1, // +1 for the add button
                                  itemBuilder: (context, index) {
                                    if (index == selectedImagePaths.length) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircleAvatar(
                                          radius: 40,
                                          child: Icon(Icons.add_a_photo),
                                          backgroundColor: Colors.grey[300],
                                        ),
                                      );
                                    }
                                    final imagePath = selectedImagePaths[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        radius: 40,
                                        backgroundImage:
                                            imagePath.startsWith('asset/')
                                                ? AssetImage(imagePath)
                                                    as ImageProvider
                                                : FileImage(File(imagePath)),
                                      ),
                                    );
                                  },
                                ),
                              ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: EdgeInsets.only(bottom: 16, top: 8),
                      decoration: BoxDecoration(
                        color: Colors.pink[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: TextField(
                      controller: productNameCtrl,
                      decoration: InputDecoration(
                        labelText: 'Product/Service Name *',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 15.0,
                            right: 15,
                          ),
                          child: TextField(
                            controller: priceCtrl,
                            decoration: InputDecoration(
                              labelText: 'Sell Price *',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Select Item Category',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items:
                                ['Category', 'Grocery', 'Beverages', 'Dairy']
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ),
                                    )
                                    .toList(),
                            value: category,
                            onChanged: (value) {
                              setState(() => category = value!);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Item Unit',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items:
                                ['Kg', 'Ltr', 'Pcs'].map((e) {
                                  return DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              setState(() => unit = value!);
                            },
                            value: unit,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 15.0,
                            bottom: 15,
                          ),
                          child: TextField(
                            controller: quantityCtrl,
                            decoration: InputDecoration(
                              labelText: 'quantity ',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: marpCtrl,
                          decoration: InputDecoration(
                            labelText: 'MRP',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: purchasePriceCtrl,
                          decoration: InputDecoration(
                            labelText: 'Purchase Price',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (productNameCtrl.text.trim().isEmpty ||
                          priceCtrl.text.isEmpty) {
                        Fluttertoast.showToast(
                          msg: "Fill all required fields",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.black87,
                          fontSize: 16.0,
                        );
                        return;
                      }

                      final item = Items(
                        id: existing?.id ?? const Uuid().v4(),
                        category: category,
                        unit: unit,
                        mrp: double.tryParse(marpCtrl.text) ?? 0,
                        purchasePrice:
                            double.tryParse(purchasePriceCtrl.text) ?? 0,
                        productName: productNameCtrl.text,
                        price: double.tryParse(priceCtrl.text) ?? 0,
                        quantity: double.tryParse(quantityCtrl.text) ?? 0,
                        image:
                            selectedImagePaths.isNotEmpty
                                ? selectedImagePaths[0]
                                : null, // Store the first image or null
                      );

                      if (existing == null) {
                        notifier.addItem(item);

                        Navigator.pop(context);
                        Future.delayed(const Duration(milliseconds: 300), () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Item added successfully!"),
                            ),
                          );
                        });
                      } else {
                        notifier.editItem(item);
                        Navigator.pop(context);
                        Future.delayed(const Duration(milliseconds: 300), () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Item updated!")),
                          );
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      minimumSize: Size(double.infinity, 48),
                    ),
                    child: Text('SAVE', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
