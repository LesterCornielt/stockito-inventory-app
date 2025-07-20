class Sale {
  final int? id;
  final int productId;
  final String productName;
  final int quantity;
  final int pricePerUnit;
  final int totalAmount;
  final DateTime date;

  Sale({
    this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.pricePerUnit,
    required this.totalAmount,
    required this.date,
  });

  Sale copyWith({
    int? id,
    int? productId,
    String? productName,
    int? quantity,
    int? pricePerUnit,
    int? totalAmount,
    DateTime? date,
  }) {
    return Sale(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      totalAmount: totalAmount ?? this.totalAmount,
      date: date ?? this.date,
    );
  }
}
