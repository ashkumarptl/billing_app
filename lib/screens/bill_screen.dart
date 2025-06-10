import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../model/item_model.dart';
import '../model/record_model.dart';
import '../provider/item_provider.dart';
import '../provider/selecteditem_provider.dart';
import '../utility/pdf_genarator.dart';

class BillScreen extends ConsumerStatefulWidget {
  const BillScreen({super.key, required this.items});
  final List<Items> items;

  @override
  ConsumerState<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends ConsumerState<BillScreen> {
  final TextEditingController _customerNameController = TextEditingController();
  DateTime selectedDate = DateTime.now();


  @override
  Widget build(BuildContext context) {
    final selectedItems = ref.watch(selectedItemsProvider);
    double totalAmount = selectedItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Generate Bill"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _customerNameController,
                decoration: const InputDecoration(
                  labelText: "Customer Name",
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text("Date: "),
                  Text("${selectedDate.toLocal()}".split(' ')[0]),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                    child: const Text("Pick Date"),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: selectedItems.length,
                  itemBuilder: (context, index) {
                    final item = selectedItems[index];
                    return ListTile(
                      title: Text(item.productName),
                      subtitle: Text("₹${item.price} x ${item.quantity}"),
                      trailing: Text("₹${(item.price * item.quantity).toStringAsFixed(2)}"),
                    );
                  },
                ),
              ),
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    
                  ],
                ),
              ),

              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("₹${totalAmount.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  final bill = Bill(
                    id: const Uuid().v4(),
                    customerName: _customerNameController.text.trim(),
                    date: selectedDate,
                    items: selectedItems,
                    totalAmount: totalAmount,
                    subTotal: totalAmount,
                    discount: 0,
                    paymentMode: 'Cash',
                    receivedAmount: 0,
                    billNumber: 1,
                    customerAddress: '',
                    customerPhone: '',
                    isPaid: false,
                  );
      
                  ref.read(billsProvider.notifier).addBill(bill);
      
                  PdfUnil.printBill(bill);
      
      
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Bill generated successfully")),
                  );
      
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text("Generate Bill", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(45),
                  backgroundColor: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

