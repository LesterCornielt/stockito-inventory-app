import 'package:flutter_test/flutter_test.dart';
import 'package:stockito/features/products/domain/entities/product.dart';
import '../../../../../helpers/mock_data.dart';

void main() {
  group('Product Entity', () {
    test('should be a subclass of Equatable', () {
      // Arrange
      final product = MockData.sampleProduct1;

      // Assert
      expect(product, isA<Product>());
    });

    test('should support value equality', () {
      // Arrange
      final product1 = MockData.createProduct(
        id: 1,
        name: 'Test Product',
        price: 10000,
        stock: 50,
      );
      final product2 = MockData.createProduct(
        id: 1,
        name: 'Test Product',
        price: 10000,
        stock: 50,
      );

      // Assert
      expect(product1, equals(product2));
    });

    test('should return correct props', () {
      // Arrange
      final product = MockData.sampleProduct1;

      // Act
      final props = product.props;

      // Assert
      expect(props.length, 6);
      expect(props[0], product.id);
      expect(props[1], product.name);
      expect(props[2], product.price);
      expect(props[3], product.stock);
      expect(props[4], product.createdAt);
      expect(props[5], product.updatedAt);
    });

    test('copyWith should return a new instance with updated values', () {
      // Arrange
      final original = MockData.sampleProduct1;

      // Act
      final updated = original.copyWith(
        name: 'Updated Name',
        price: 20000,
        stock: 100,
      );

      // Assert
      expect(updated.id, original.id);
      expect(updated.name, 'Updated Name');
      expect(updated.price, 20000);
      expect(updated.stock, 100);
      expect(updated.createdAt, original.createdAt);
      expect(updated.updatedAt, original.updatedAt);
      expect(updated, isNot(equals(original)));
    });

    test('copyWith should keep original values when null is passed', () {
      // Arrange
      final original = MockData.sampleProduct1;

      // Act
      final updated = original.copyWith();

      // Assert
      expect(updated.id, original.id);
      expect(updated.name, original.name);
      expect(updated.price, original.price);
      expect(updated.stock, original.stock);
      expect(updated.createdAt, original.createdAt);
      expect(updated.updatedAt, original.updatedAt);
    });
  });
}
