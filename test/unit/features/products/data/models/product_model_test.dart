import 'package:flutter_test/flutter_test.dart';
import 'package:stockito/features/products/data/models/product_model.dart';
import 'package:stockito/features/products/domain/entities/product.dart';
import '../../../../../helpers/mock_data.dart';

void main() {
  group('ProductModel', () {
    test('should be a subclass of Product', () {
      // Arrange & Act
      final model = ProductModel.fromEntity(MockData.sampleProduct1);

      // Assert
      expect(model, isA<Product>());
      expect(model, isA<ProductModel>());
    });

    test('fromEntity should create ProductModel from Product', () {
      // Arrange
      final product = MockData.sampleProduct1;

      // Act
      final model = ProductModel.fromEntity(product);

      // Assert
      expect(model.id, equals(product.id));
      expect(model.name, equals(product.name));
      expect(model.price, equals(product.price));
      expect(model.stock, equals(product.stock));
      expect(model.createdAt, equals(product.createdAt));
      expect(model.updatedAt, equals(product.updatedAt));
    });

    test('toEntity should convert ProductModel to Product', () {
      // Arrange
      final model = ProductModel.fromEntity(MockData.sampleProduct1);

      // Act
      final entity = model.toEntity();

      // Assert
      expect(entity, isA<Product>());
      expect(entity.id, equals(model.id));
      expect(entity.name, equals(model.name));
      expect(entity.price, equals(model.price));
      expect(entity.stock, equals(model.stock));
    });

    test('fromMap should create ProductModel from map', () {
      // Arrange
      final map = {
        'id': 1,
        'name': 'Test Product',
        'price': 10000,
        'stock': 50,
        'created_at': '2024-01-01T12:00:00.000Z',
        'updated_at': '2024-01-01T12:00:00.000Z',
      };

      // Act
      final model = ProductModel.fromMap(map);

      // Assert
      expect(model.id, equals(1));
      expect(model.name, equals('Test Product'));
      expect(model.price, equals(10000));
      expect(model.stock, equals(50));
      expect(model.createdAt, equals(DateTime.parse('2024-01-01T12:00:00.000Z')));
      expect(model.updatedAt, equals(DateTime.parse('2024-01-01T12:00:00.000Z')));
    });

    test('toMap should convert ProductModel to map', () {
      // Arrange
      final model = ProductModel.fromEntity(MockData.sampleProduct1);

      // Act
      final map = model.toMap();

      // Assert
      expect(map['id'], equals(model.id));
      expect(map['name'], equals(model.name));
      expect(map['price'], equals(model.price));
      expect(map['stock'], equals(model.stock));
      expect(map['created_at'], equals(model.createdAt.toIso8601String()));
      expect(map['updated_at'], equals(model.updatedAt.toIso8601String()));
    });

    test('fromJson should create ProductModel from JSON', () {
      // Arrange
      final json = {
        'id': 1,
        'name': 'Test Product',
        'price': 10000,
        'stock': 50,
        'created_at': '2024-01-01T12:00:00.000Z',
        'updated_at': '2024-01-01T12:00:00.000Z',
      };

      // Act
      final model = ProductModel.fromJson(json);

      // Assert
      expect(model.id, equals(1));
      expect(model.name, equals('Test Product'));
      expect(model.price, equals(10000));
      expect(model.stock, equals(50));
    });

    test('toJson should convert ProductModel to JSON', () {
      // Arrange
      final model = ProductModel.fromEntity(MockData.sampleProduct1);

      // Act
      final json = model.toJson();

      // Assert
      expect(json['id'], equals(model.id));
      expect(json['name'], equals(model.name));
      expect(json['price'], equals(model.price));
      expect(json['stock'], equals(model.stock));
      expect(json['created_at'], equals(model.createdAt.toIso8601String()));
      expect(json['updated_at'], equals(model.updatedAt.toIso8601String()));
    });

    test('should handle null id in fromMap', () {
      // Arrange
      final map = {
        'id': null,
        'name': 'Test Product',
        'price': 10000,
        'stock': 50,
        'created_at': '2024-01-01T12:00:00.000Z',
        'updated_at': '2024-01-01T12:00:00.000Z',
      };

      // Act
      final model = ProductModel.fromMap(map);

      // Assert
      expect(model.id, isNull);
      expect(model.name, equals('Test Product'));
    });
  });
}

