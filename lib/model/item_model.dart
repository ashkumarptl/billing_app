
import 'package:hive/hive.dart';
part 'item_model.g.dart';
@HiveType(typeId: 0)
class Items {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String productName;
  @HiveField(2)
  final double quantity;
  @HiveField(3)
  final double price;
  @HiveField(4)
  final String? unit;
  @HiveField(5)
  final String category;
  @HiveField(6)
  final double? mrp;
  @HiveField(7)
  final double? purchasePrice;
  @HiveField(8)
  final String? image;

  Items({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.price,
    this.image,
    required this.unit,
    this.category = 'Category',
    this.mrp,
    this.purchasePrice,
  });

  double get total => price * quantity;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': productName,
    'quantity': quantity,
    'price': price,
    'image': image,
    'unit': unit,
    'category': category,
    'mrp': mrp,
    'purchasePrice': purchasePrice,
  };

  factory Items.fromJson(Map<String, dynamic> json) => Items(
    id: json['id'],
    productName: json['productName'],
    quantity: json['quantity'],
    price: (json['price'] as num).toDouble(),
    image: json['image'],
    unit: json['unit'],
    category: json['category'],
    mrp: (json['mrp'] as num?)?.toDouble(),
    purchasePrice: (json['purchasePrice'] as num?)?.toDouble(),
  );

  Items copyWith({
    String? id,
    String? productName,
    double? quantity,
    double? price,
    String? image,
    String? unit,
    String? category,
    double? mrp,
    double? purchasePrice,
  }) {
    return Items(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      image: image ?? this.image,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      mrp: mrp ?? this.mrp,
      purchasePrice: purchasePrice ?? this.purchasePrice,
    );
  }
}
