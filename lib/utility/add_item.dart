import 'dart:io';
import 'package:flutter/material.dart';
import '../model/item_model.dart';
import '../provider/item_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showItemBottomSheet(
    BuildContext context,
    ItemNotifier notifier, [
      Items? existing,
    ]) {
  final picker = ImagePicker();
  final productNameCtrl = TextEditingController(text: existing?.productName ?? '');
  final priceCtrl = TextEditingController(text: existing?.price.toString() ?? '');
  String category = existing?.category ?? 'Category';
  String unit = existing?.unit ?? 'Kg';
  final marpCtrl = TextEditingController(text: existing?.mrp.toString() ?? '');
  final purchasePriceCtrl = TextEditingController(text: existing?.purchasePrice.toString() ?? '');
  String? selectedImagePath = existing?.image ?? 'asset/images/img.png';

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          Future<void> pickImage() async {
            final picked = await picker.pickImage(source: ImageSource.gallery);
            if (picked != null) {
              setState(() {
                selectedImagePath = picked.path;
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
                    child: GestureDetector(
                      onTap: pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: selectedImagePath!.startsWith('asset/')
                            ? AssetImage(selectedImagePath!) as ImageProvider
                            : FileImage(File(selectedImagePath!)),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: EdgeInsets.only(bottom: 16, top: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  TextField(
                    controller: productNameCtrl,
                    decoration: InputDecoration(
                      labelText: 'Product/Service Name *',
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: priceCtrl,
                          decoration: InputDecoration(labelText: 'Sell Price *'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(labelText: 'Item Unit'),
                          items: ['Kg', 'Ltr', 'Pcs'].map((e) {
                            return DropdownMenuItem(value: e, child: Text(e));
                          }).toList(),
                          onChanged: (value) {
                            setState(() => unit = value!);
                          },
                          value: unit,
                        ),
                      ),
                    ],
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Select Item Category'),
                    items: ['Category', 'Grocery', 'Beverages', 'Dairy']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    value: category,
                    onChanged: (value) {
                      setState(() => category = value!);
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: marpCtrl,
                          decoration: InputDecoration(labelText: 'MRP'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: purchasePriceCtrl,
                          decoration: InputDecoration(labelText: 'Purchase Price'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (productNameCtrl.text.trim().isEmpty || priceCtrl.text.isEmpty) {
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
                        purchasePrice: double.tryParse(purchasePriceCtrl.text) ?? 0,
                        productName: productNameCtrl.text,
                        price: double.tryParse(priceCtrl.text) ?? 0,
                        quantity: 1,
                        image: selectedImagePath,
                      );

                      if (existing == null) {
                        notifier.addItem(item);
                        Navigator.pop(context);
                        Future.delayed(const Duration(milliseconds: 300), () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Item added successfully!")),
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
