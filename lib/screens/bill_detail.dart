import 'package:billing_app/utility/pdf_genarator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../model/item_model.dart';
import '../model/record_model.dart';
import '../provider/item_provider.dart';

class BillDetailsScreen extends ConsumerWidget {
  final Bill bill;

  const BillDetailsScreen({super.key, required this.bill});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = DateFormat('dd MMM yyyy – hh:mm a');
    final List<Items> items = bill.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill Details'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'pdf') {
                PdfUnil.printBill(bill);
              } else if (value == 'share') {
                PdfUnil.shareBill(bill);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'pdf', child: Text('Export to PDF')),
              const PopupMenuItem(value: 'share', child: Text('Share Summary')),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _billInfoTile('Customer', bill.customerName),
            _billInfoTile('Date', formatter.format(bill.date)),
              _billInfoTile('Bill No.', bill.billNumber.toString()),
              if(bill.isPaid == true)
                _billInfoTile('Status', 'paid'),
            if(bill.isPaid == false)
              _billInfoTile('Status', 'not paid'),

            const Divider(height: 30),
            const Text(
              'Items',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            ...items.map((item) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(item.productName),
              subtitle: Text('Qty: ${item.quantity}  × ₹${item.price}'),
              trailing: Text(
                '₹${(item.price * item.quantity).toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            )),
            const Divider(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '₹${bill.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Delete Bill?"),
                      content: const Text("Are you sure you want to delete this bill?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            // Call delete logic here
                            ref.read(billsProvider.notifier).deleteBill(bill.id);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Text("Delete", style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.delete),
                label: const Text("Delete"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ),
            const SizedBox(width: 10),
            if (bill.isPaid == false)
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // ✅ Mark as paid logic
                    ref.read(billsProvider.notifier).markAsPaid(bill.id);
                    // Example: update bill status in DB
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Marked as Paid")),
                    );
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.check_circle),
                  label: const Text("Mark Paid"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _billInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text('$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
