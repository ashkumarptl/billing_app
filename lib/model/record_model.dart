// models/bill_model.dart
import 'item_model.dart';

class Bill {
  final String id;
  final int billNumber;
  final DateTime date;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final List<Items> items;
  final double subTotal;
  final double discount;
  final double totalAmount;
  final String paymentMode;
  final double receivedAmount;
  final bool isPaid;

  Bill({
    required this.id,
    required this.billNumber,
    required this.date,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.items,
    required this.subTotal,
    required this.discount,
    required this.totalAmount,
    required this.paymentMode,
    required this.receivedAmount,
    this.isPaid = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'billNumber': billNumber,
    'date': date.toIso8601String(),
    'customerName': customerName,
    'customerPhone': customerPhone,
    'customerAddress': customerAddress,
    'items': items.map((item) => item.toJson()).toList(),
    'subTotal': subTotal,
    'discount': discount,
    'totalAmount': totalAmount,
    'paymentMode': paymentMode,
    'receivedAmount': receivedAmount,
    'isPaid': isPaid,
  };

  factory Bill.fromJson(Map<String, dynamic> json) => Bill(
    id: json['id'],
    billNumber: json['billNumber'],
    date: DateTime.parse(json['date']),
    customerName: json['customerName'],
    customerPhone: json['customerPhone'],
    customerAddress: json['customerAddress'],
    items: (json['items'] as List)
        .map((item) => Items.fromJson(item))
        .toList(),
    subTotal: (json['subTotal'] as num).toDouble(),
    discount: (json['discount'] as num).toDouble(),
    totalAmount: (json['totalAmount'] as num).toDouble(),
    paymentMode: json['paymentMode'],
    receivedAmount: (json['receivedAmount'] as num).toDouble(),
    isPaid: json['isPaid'],

  );


  Bill copyWith({
    String? id,
    int? billNumber,
    DateTime? date,
    String? customerName,
    String? customerPhone,
    String? customerAddress,
    List<Items>? items,
    double? subTotal,
    double? discount,
    double? totalAmount,
    String? paymentMode,
    double? receivedAmount,
    required bool isPaid,
  }) {
    return Bill(
      id: id ?? this.id,
      billNumber: billNumber ?? this.billNumber,
      date: date ?? this.date,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerAddress: customerAddress ?? this.customerAddress,
      items: items ?? this.items,
      subTotal: subTotal ?? this.subTotal,
      discount: discount ?? this.discount,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMode: paymentMode ?? this.paymentMode,
      receivedAmount: receivedAmount ?? this.receivedAmount,
      isPaid: isPaid,
    );
  }


}
