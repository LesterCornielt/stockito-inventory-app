import '../../domain/entities/sale.dart';

class SaleModel extends Sale {
  SaleModel({
    int? id,
    required int productId,
    required String productName,
    required int quantity,
    required double pricePerUnit,
    required double totalAmount,
    required DateTime date,
  }) : super(
         id: id,
         productId: productId,
         productName: productName,
         quantity: quantity,
         pricePerUnit: pricePerUnit,
         totalAmount: totalAmount,
         date: date,
       );

  factory SaleModel.fromMap(Map<String, dynamic> map) {
    return SaleModel(
      id: map['id'] as int?,
      productId: map['product_id'] as int,
      productName: map['product_name'] as String,
      quantity: map['quantity'] as int,
      pricePerUnit: map['price_per_unit'] as double,
      totalAmount: map['total_amount'] as double,
      date: DateTime.parse(map['date'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'price_per_unit': pricePerUnit,
      'total_amount': totalAmount,
      'date': date.toIso8601String(),
    };
  }

  static SaleModel fromEntity(Sale sale) {
    return SaleModel(
      id: sale.id,
      productId: sale.productId,
      productName: sale.productName,
      quantity: sale.quantity,
      pricePerUnit: sale.pricePerUnit,
      totalAmount: sale.totalAmount,
      date: sale.date,
    );
  }

  Sale toEntity() => this;
}
