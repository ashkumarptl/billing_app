// models/bill_model.dart
import 'package:hive/hive.dart';
import 'item_model.dart';

part 'record_model.g.dart';

@HiveType(typeId: 1)
class Bill {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final int billNumber;
  @HiveField(2)
  final DateTime date;
  @HiveField(3)
  final String customerName;
  @HiveField(4)
  final String customerPhone;
  @HiveField(5)
  final String customerAddress;
  @HiveField(6)
  final List<Items> items;
  @HiveField(7)
  final double subTotal;
  @HiveField(8)
  final double discount;
  @HiveField(9)
  final double totalAmount;
  @HiveField(10)
  final String paymentMode;
  @HiveField(11)
  final double receivedAmount;
  @HiveField(12)
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
