class Items {
  final String id;
  final String productName;
  final int quantity;
  final double price;
  final String? unit;
  final String category;
  final double? mrp;
  final double? purchasePrice;
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
    int? quantity,
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
