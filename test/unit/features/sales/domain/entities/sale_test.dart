import 'package:flutter_test/flutter_test.dart';
import 'package:stockito/features/sales/domain/entities/sale.dart';
import '../../../../../helpers/mock_data.dart';

void main() {
  group('Sale Entity', () {
    test('should create a sale with all required fields', () {
      // Arrange & Act
      final sale = MockData.sampleSale1;

      // Assert
      expect(sale.id, equals(1));
      expect(sale.productId, equals(1));
      expect(sale.productName, equals('Producto Test 1'));
      expect(sale.quantity, equals(5));
      expect(sale.pricePerUnit, equals(10000));
      expect(sale.totalAmount, equals(50000));
      expect(sale.date, isNotNull);
    });

    test('copyWith should return a new instance with updated values', () {
      // Arrange
      final original = MockData.sampleSale1;

      // Act
      final updated = original.copyWith(
        quantity: 10,
        totalAmount: 100000,
      );

      // Assert
      expect(updated.id, original.id);
      expect(updated.productId, original.productId);
      expect(updated.productName, original.productName);
      expect(updated.quantity, equals(10));
      expect(updated.pricePerUnit, original.pricePerUnit);
      expect(updated.totalAmount, equals(100000));
      expect(updated.date, original.date);
    });

    test('copyWith should keep original values when null is passed', () {
      // Arrange
      final original = MockData.sampleSale1;

      // Act
      final updated = original.copyWith();

      // Assert
      expect(updated.id, original.id);
      expect(updated.productId, original.productId);
      expect(updated.productName, original.productName);
      expect(updated.quantity, original.quantity);
      expect(updated.pricePerUnit, original.pricePerUnit);
      expect(updated.totalAmount, original.totalAmount);
      expect(updated.date, original.date);
    });

    test('should allow creating sale without id', () {
      // Arrange & Act
      final sale = Sale(
        id: null,
        productId: 1,
        productName: 'New Product',
        quantity: 3,
        pricePerUnit: 5000,
        totalAmount: 15000,
        date: MockData.baseDate,
      );

      // Assert
      expect(sale.id, isNull);
      expect(sale.productId, equals(1));
      expect(sale.productName, equals('New Product'));
      expect(sale.quantity, equals(3));
      expect(sale.pricePerUnit, equals(5000));
      expect(sale.totalAmount, equals(15000));
    });

    test('should calculate totalAmount correctly', () {
      // Arrange & Act
      final sale = MockData.createSale(
        quantity: 7,
        pricePerUnit: 12000,
        totalAmount: 84000, // 7 * 12000
      );

      // Assert
      expect(sale.totalAmount, equals(84000));
      expect(sale.quantity * sale.pricePerUnit, equals(sale.totalAmount));
    });
  });
}

