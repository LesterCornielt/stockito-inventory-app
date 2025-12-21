import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stockito/core/database/database_service.dart';
import 'package:stockito/features/products/data/datasources/product_local_datasource.dart';
import 'package:stockito/features/products/data/models/product_model.dart';
import '../../../../../helpers/test_helpers.dart';
import '../../../../../helpers/mock_data.dart';

void main() {
  Database? testDb;
  late ProductLocalDataSourceImpl dataSource;

  setUp(() async {
    // Reset DatabaseService first
    DatabaseService.resetDatabase();
    // Initialize sqflite_common_ffi
    TestHelpers.initSqfliteFfi();
    // Create test database
    testDb = await TestHelpers.initTestDatabase();
    // Override DatabaseService.database for testing
    DatabaseService.setTestDatabase(testDb!);
    // Create data source after database is set
    dataSource = ProductLocalDataSourceImpl();
  });

  tearDown(() async {
    if (testDb != null) {
      await TestHelpers.clearTestDatabase(testDb!);
      DatabaseService.resetDatabase();
    }
  });

  group('ProductLocalDataSourceImpl', () {
    test('getAllProducts should return empty list when no products', () async {
      // Act
      final result = await dataSource.getAllProducts();

      // Assert
      expect(result, isEmpty);
    });

    test('getAllProducts should return all products', () async {
      // Arrange
      final product1 = ProductModel.fromEntity(MockData.sampleProduct1);
      final product2 = ProductModel.fromEntity(MockData.sampleProduct2);
      await dataSource.createProduct(product1);
      await dataSource.createProduct(product2);

      // Act
      final result = await dataSource.getAllProducts();

      // Assert
      expect(result.length, equals(2));
      expect(result[0].name, equals(product1.name));
      expect(result[1].name, equals(product2.name));
    });

    test('getProductById should return null when product does not exist', () async {
      // Act
      final result = await dataSource.getProductById(999);

      // Assert
      expect(result, isNull);
    });

    test('getProductById should return product when it exists', () async {
      // Arrange
      final product = ProductModel.fromEntity(MockData.sampleProduct1);
      final created = await dataSource.createProduct(product);

      // Act
      final result = await dataSource.getProductById(created.id!);

      // Assert
      expect(result, isNotNull);
      expect(result?.id, equals(created.id));
      expect(result?.name, equals(product.name));
    });

    test('searchProducts should return empty list when no matches', () async {
      // Arrange
      await dataSource.createProduct(ProductModel.fromEntity(MockData.sampleProduct1));

      // Act
      final result = await dataSource.searchProducts('NonExistent');

      // Assert
      expect(result, isEmpty);
    });

    test('searchProducts should return matching products', () async {
      // Arrange
      final product1 = ProductModel.fromEntity(MockData.createProduct(name: 'Apple iPhone'));
      final product2 = ProductModel.fromEntity(MockData.createProduct(name: 'Samsung Galaxy'));
      await dataSource.createProduct(product1);
      await dataSource.createProduct(product2);

      // Act
      final result = await dataSource.searchProducts('Apple');

      // Assert
      expect(result.length, equals(1));
      expect(result[0].name, equals('Apple iPhone'));
    });

    test('createProduct should insert product and return with id', () async {
      // Arrange
      final product = ProductModel.fromEntity(MockData.sampleProduct1.copyWith(id: null));

      // Act
      final result = await dataSource.createProduct(product);

      // Assert
      expect(result.id, isNotNull);
      expect(result.name, equals(product.name));
      expect(result.price, equals(product.price));
      expect(result.stock, equals(product.stock));
    });

    test('updateProduct should return true when product exists', () async {
      // Arrange
      final product = ProductModel.fromEntity(MockData.sampleProduct1);
      final created = await dataSource.createProduct(product);
      final updated = ProductModel.fromEntity(
        created.toEntity().copyWith(name: 'Updated Name', price: 20000),
      );

      // Act
      final result = await dataSource.updateProduct(updated);

      // Assert
      expect(result, isTrue);
      final retrieved = await dataSource.getProductById(created.id!);
      expect(retrieved?.name, equals('Updated Name'));
      expect(retrieved?.price, equals(20000));
    });

    test('updateProduct should return false when product does not exist', () async {
      // Arrange
      final product = ProductModel.fromEntity(
        MockData.sampleProduct1.copyWith(id: 999),
      );

      // Act
      final result = await dataSource.updateProduct(product);

      // Assert
      expect(result, isFalse);
    });

    test('deleteProduct should return true when product exists', () async {
      // Arrange
      final product = ProductModel.fromEntity(MockData.sampleProduct1);
      final created = await dataSource.createProduct(product);

      // Act
      final result = await dataSource.deleteProduct(created.id!);

      // Assert
      expect(result, isTrue);
      final retrieved = await dataSource.getProductById(created.id!);
      expect(retrieved, isNull);
    });

    test('deleteProduct should return false when product does not exist', () async {
      // Act
      final result = await dataSource.deleteProduct(999);

      // Assert
      expect(result, isFalse);
    });
  });
}

