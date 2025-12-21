import 'package:stockito/features/products/domain/entities/product.dart';
import 'package:stockito/features/sales/domain/entities/sale.dart';

/// Datos de prueba reutilizables para tests
class MockData {
  /// Fecha base para tests (1 de enero de 2024)
  static final DateTime baseDate = DateTime(2024, 1, 1, 12, 0, 0);

  /// Producto de ejemplo 1
  static Product get sampleProduct1 => Product(
    id: 1,
    name: 'Producto Test 1',
    price: 10000,
    stock: 50,
    createdAt: baseDate,
    updatedAt: baseDate,
  );

  /// Producto de ejemplo 2
  static Product get sampleProduct2 => Product(
    id: 2,
    name: 'Producto Test 2',
    price: 20000,
    stock: 30,
    createdAt: baseDate.add(const Duration(days: 1)),
    updatedAt: baseDate.add(const Duration(days: 1)),
  );

  /// Producto de ejemplo 3
  static Product get sampleProduct3 => Product(
    id: 3,
    name: 'Producto Test 3',
    price: 15000,
    stock: 25,
    createdAt: baseDate.add(const Duration(days: 2)),
    updatedAt: baseDate.add(const Duration(days: 2)),
  );

  /// Lista de productos de ejemplo
  static List<Product> get sampleProducts => [
    sampleProduct1,
    sampleProduct2,
    sampleProduct3,
  ];

  /// Venta de ejemplo 1
  static Sale get sampleSale1 => Sale(
    id: 1,
    productId: 1,
    productName: 'Producto Test 1',
    quantity: 5,
    pricePerUnit: 10000,
    totalAmount: 50000,
    date: baseDate,
  );

  /// Venta de ejemplo 2
  static Sale get sampleSale2 => Sale(
    id: 2,
    productId: 2,
    productName: 'Producto Test 2',
    quantity: 3,
    pricePerUnit: 20000,
    totalAmount: 60000,
    date: baseDate.add(const Duration(days: 1)),
  );

  /// Lista de ventas de ejemplo
  static List<Sale> get sampleSales => [sampleSale1, sampleSale2];

  /// Crea un producto personalizado
  static Product createProduct({
    int? id,
    String? name,
    int? price,
    int? stock,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? 1,
      name: name ?? 'Producto Test',
      price: price ?? 10000,
      stock: stock ?? 50,
      createdAt: createdAt ?? baseDate,
      updatedAt: updatedAt ?? baseDate,
    );
  }

  /// Crea una venta personalizada
  static Sale createSale({
    int? id,
    int? productId,
    String? productName,
    int? quantity,
    int? pricePerUnit,
    int? totalAmount,
    DateTime? date,
  }) {
    return Sale(
      id: id ?? 1,
      productId: productId ?? 1,
      productName: productName ?? 'Producto Test',
      quantity: quantity ?? 5,
      pricePerUnit: pricePerUnit ?? 10000,
      totalAmount: totalAmount ?? 50000,
      date: date ?? baseDate,
    );
  }
}
