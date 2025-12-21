import 'package:flutter_test/flutter_test.dart';
import 'package:stockito/features/sales/data/models/sale_model.dart';
import 'package:stockito/features/sales/domain/entities/sale.dart';
import '../../../../../helpers/mock_data.dart';

void main() {
  group('SaleModel', () {
    test('should be a subclass of Sale', () {
      // Arrange & Act
      final model = SaleModel.fromEntity(MockData.sampleSale1);

      // Assert
      expect(model, isA<Sale>());
      expect(model, isA<SaleModel>());
    });

    test('fromEntity should create SaleModel from Sale', () {
      // Arrange
      final sale = MockData.sampleSale1;

      // Act
      final model = SaleModel.fromEntity(sale);

      // Assert
      expect(model.id, equals(sale.id));
      expect(model.productId, equals(sale.productId));
      expect(model.productName, equals(sale.productName));
      expect(model.quantity, equals(sale.quantity));
      expect(model.pricePerUnit, equals(sale.pricePerUnit));
      expect(model.totalAmount, equals(sale.totalAmount));
      expect(model.date, equals(sale.date));
    });

    test('toEntity should return itself as Sale', () {
      // Arrange
      final model = SaleModel.fromEntity(MockData.sampleSale1);

      // Act
      final entity = model.toEntity();

      // Assert
      expect(entity, equals(model));
      expect(entity, isA<Sale>());
    });

    test('fromMap should create SaleModel from map', () {
      // Arrange
      final map = {
        'id': 1,
        'product_id': 1,
        'product_name': 'Test Product',
        'quantity': 5,
        'price_per_unit': 10000,
        'total_amount': 50000,
        'date': '2024-01-01T12:00:00.000Z',
      };

      // Act
      final model = SaleModel.fromMap(map);

      // Assert
      expect(model.id, equals(1));
      expect(model.productId, equals(1));
      expect(model.productName, equals('Test Product'));
      expect(model.quantity, equals(5));
      expect(model.pricePerUnit, equals(10000));
      expect(model.totalAmount, equals(50000));
      expect(model.date, equals(DateTime.parse('2024-01-01T12:00:00.000Z')));
    });

    test('toMap should convert SaleModel to map', () {
      // Arrange
      final model = SaleModel.fromEntity(MockData.sampleSale1);

      // Act
      final map = model.toMap();

      // Assert
      expect(map['id'], equals(model.id));
      expect(map['product_id'], equals(model.productId));
      expect(map['product_name'], equals(model.productName));
      expect(map['quantity'], equals(model.quantity));
      expect(map['price_per_unit'], equals(model.pricePerUnit));
      expect(map['total_amount'], equals(model.totalAmount));
      expect(map['date'], equals(model.date.toIso8601String()));
    });

    test('should handle null id in fromMap', () {
      // Arrange
      final map = {
        'id': null,
        'product_id': 1,
        'product_name': 'Test Product',
        'quantity': 5,
        'price_per_unit': 10000,
        'total_amount': 50000,
        'date': '2024-01-01T12:00:00.000Z',
      };

      // Act
      final model = SaleModel.fromMap(map);

      // Assert
      expect(model.id, isNull);
      expect(model.productId, equals(1));
      expect(model.productName, equals('Test Product'));
    });

    test('should preserve all fields in round-trip conversion', () {
      // Arrange
      final originalSale = MockData.createSale(
        id: 1,
        productId: 2,
        productName: 'Round Trip Test',
        quantity: 10,
        pricePerUnit: 15000,
        totalAmount: 150000,
        date: DateTime(2024, 6, 15, 14, 30),
      );

      // Act
      final model = SaleModel.fromEntity(originalSale);
      final map = model.toMap();
      final recreatedModel = SaleModel.fromMap(map);
      final recreatedSale = recreatedModel.toEntity();

      // Assert
      expect(recreatedSale.id, equals(originalSale.id));
      expect(recreatedSale.productId, equals(originalSale.productId));
      expect(recreatedSale.productName, equals(originalSale.productName));
      expect(recreatedSale.quantity, equals(originalSale.quantity));
      expect(recreatedSale.pricePerUnit, equals(originalSale.pricePerUnit));
      expect(recreatedSale.totalAmount, equals(originalSale.totalAmount));
      expect(recreatedSale.date, equals(originalSale.date));
    });
  });
}

