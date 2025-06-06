import 'package:billing_app/screens/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../provider/item_provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../utility/pdf_genarator.dart';
import 'bill_detail.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void add() {
    // If you need to use `ref` here, accept it as a parameter: add(WidgetRef ref)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        alignment: Alignment(0, .8),
        backgroundColor: Colors.transparent,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/select_item');
              },
              icon: Icon(Icons.currency_rupee),
              label: Text('Sell'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Future buy logic
              },
              icon: Icon(Icons.monetization_on),
              label: Text('Buy'),
            ),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final bills = ref.watch(billsProvider); // ✅ correct way to use ref
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        drawer: const Drawer_screen(),
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(Icons.verified_outlined),
              ),
              Column(
                children: const [
                  Text('Home'),
                  Text('6264972587', style: TextStyle(fontSize: 10)),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.refresh)),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.support_agent_outlined),
            ),
          ],
        ),
        body: bills.isEmpty
            ? const Center(child: Text("No bills yet"))
            : ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: bills.length,
          itemBuilder: (context, index) {
            final bill = bills[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (bill.customerName.isNotEmpty)
                    Expanded(
                      child: Text(
                        bill.customerName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      "₹${bill.totalAmount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      'Date: ${DateFormat('dd/MM/yyyy').format(bill.date)}',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                      Text(
                        'Bill No: ${bill.billNumber}',
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    Text("Total Items: ${bill.items.length}"),
                    if (bill.isPaid)
                      Text(
                        'Status: ${bill.isPaid}',
                        style: TextStyle(
                          fontSize: 13,
                          color: bill.isPaid == true
                              ? Colors.green
                              : Colors.redAccent,
                        ),
                      ),
                  ],
                ),
                trailing: SizedBox(
                  width: 20, // Standard width for IconButton
                  height: 210,
                  child: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'pdf') {
                        // Export to PDF
                        PdfUnil.printBill(bill);
                      } else if (value == 'share') {
                        // Share bill
                        PdfUnil.shareBill(bill);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'pdf',
                        child: Row(
                          children: [
                            Icon(Icons.picture_as_pdf, color: Colors.red),
                            SizedBox(width: 8),
                            Text("Export to PDF"),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'share',
                        child: Row(
                          children: [
                            Icon(Icons.share, color: Colors.blue),
                            SizedBox(width: 8),
                            Text("Share Bill"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BillDetailsScreen(bill: bill),
                    ),
                  );
                }
                ,
              ),
            );
          },
        ),

        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: const IconThemeData(size: 22.0,color: Colors.white),
          backgroundColor: Colors.deepPurple,
          curve: Curves.bounceIn,
          overlayColor: Colors.black, // Changed from null to transparent
          overlayOpacity: 0.0, // Set overlayOpacity to 0.0 for full transparency
          children: [
            SpeedDialChild(
              child: const Icon(Icons.currency_rupee,color: Colors.white,),
              backgroundColor: Colors.deepPurple,
              onTap: (){
                Navigator.pushNamed(context, '/select_item');
              },
              label: 'sell',
              labelStyle: const TextStyle(fontSize: 18.0),
            )
          ],
        ),
      ),
    );
  }
}
