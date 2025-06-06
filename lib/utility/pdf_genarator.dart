import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../model/record_model.dart'; // your ItemModel

Future<Uint8List> generateBillPdf(Bill bill) async {
  final pdf = pw.Document();
  final bold = pw.TextStyle(fontWeight: pw.FontWeight.bold);

  pdf.addPage(
    pw.MultiPage(
      build: (context) => [
        pw.Center(
          child: pw.Column(
            children: [
              pw.Text("Business Name Here", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.Text("5"),
              pw.Text("Address Here"),
              pw.Text("Phone Number: 6264972587"),
              pw.SizedBox(height: 10),
              pw.Divider(),

              // Bill Info
              pw.Text("Bill No: ${bill.billNumber}"),
              pw.Text("Created On: ${DateFormat('dd/MM/yyyy').format(bill.date)}"),
              pw.Text("Bill To: ${bill.customerName} | ${bill.customerPhone}"),
              pw.Text("Billing Address: ${bill.customerAddress}"),
              pw.SizedBox(height: 10),

              // Table
              pw.TableHelper.fromTextArray(
                headers: ['Item Name', 'Qty', 'Rate', 'Total'],
                data: bill.items.map((item) {
                  return [
                    item.productName,
                    item.quantity.toString(),
                    item.price.toStringAsFixed(2),
                    (item.price * item.quantity).toStringAsFixed(2),
                  ];
                }).toList(),
              ),
              pw.SizedBox(height: 10),
              pw.Text("Total Items: ${bill.items.length}"),
              pw.Text("Total Quantity: ${bill.items.fold<num>(0, (sum, item) => sum + item.quantity)}"),
              pw.Divider(),

              // Totals
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Sub Total", style: bold),
                  pw.Text(bill.subTotal.toStringAsFixed(2)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Discount", style: bold),
                  pw.Text(bill.discount.toStringAsFixed(2)),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Text("Total ${bill.totalAmount.toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),

              pw.Text("Mode of Payment: ${bill.paymentMode}"),
              pw.Text("Received: ${bill.receivedAmount.toStringAsFixed(2)}"),
              pw.Text("Total Savings ${bill.discount.toStringAsFixed(2)}"),
              pw.SizedBox(height: 10),
              pw.Text("Thank You! Visit Again!"),
            ],
          ),
        ),
      ],
    ),
  );

  return pdf.save();
}

class PdfUnil{

   static void printBill(Bill bill) async {
    final pdfData = await generateBillPdf(bill);
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfData);
  }

 static Future<void> shareBill(Bill bill) async {
   final String content = '''
Customer: ${bill.customerName}
Date: ${DateFormat('dd/MM/yyyy').format(bill.date)}
Amount: ₹${bill.totalAmount.toStringAsFixed(2)}
Status: ${bill.isPaid ? 'Paid' : 'Not Paid'}
''';

   final param = ShareParams(
     text: content,
     title: "🧾 *Billing Summary*"

   );

     await SharePlus.instance.share(param);
   }
}
