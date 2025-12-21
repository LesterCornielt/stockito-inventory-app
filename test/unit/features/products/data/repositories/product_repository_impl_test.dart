import 'package:flutter_test/flutter_test.dart';
import 'package:stockito/features/products/data/datasources/product_local_datasource.dart';
import 'package:stockito/features/products/data/models/product_model.dart';
import 'package:stockito/features/products/data/repositories/product_repository_impl.dart';
import 'package:stockito/features/products/domain/entities/product.dart';
import 'package:stockito/features/products/domain/repositories/product_repository.dart';
import '../../../../../helpers/mock_data.dart';

class MockProductLocalDataSource implements ProductLocalDataSource {
  List<ProductModel>? productsToReturn;
  ProductModel? productToReturn;
  Exception? exceptionToThrow;
  ProductModel? lastCreatedProduct;
  ProductModel? lastUpdatedProduct;
  int? lastDeletedId;
  String? lastSearchQuery;

  @override
  Future<List<ProductModel>> getAllProducts() async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return productsToReturn ?? [];
  }

  @override
  Future<ProductModel?> getProductById(int id) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return productToReturn;
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    lastSearchQuery = query;
    return productsToReturn ?? [];
  }

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    lastCreatedProduct = product;
    return ProductModel.fromEntity(product.toEntity().copyWith(id: 1));
  }

  @override
  Future<bool> updateProduct(ProductModel product) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    lastUpdatedProduct = product;
    return true;
  }

  @override
  Future<bool> deleteProduct(int id) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    lastDeletedId = id;
    return true;
  }
}

void main() {
  late ProductRepositoryImpl repository;
  late MockProductLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockProductLocalDataSource();
    repository = ProductRepositoryImpl(mockDataSource);
  });

  group('ProductRepositoryImpl', () {
    test('getAllProducts should return list of products', () async {
      // Arrange
      final models = [
        ProductModel.fromEntity(MockData.sampleProduct1),
        ProductModel.fromEntity(MockData.sampleProduct2),
      ];
      mockDataSource.productsToReturn = models;

      // Act
      final result = await repository.getAllProducts();

      // Assert
      expect(result.length, equals(2));
      expect(result[0], isA<Product>());
      expect(result[0].name, equals(MockData.sampleProduct1.name));
    });

    test('getAllProducts should throw ProductFailure on error', () async {
      // Arrange
      mockDataSource.exceptionToThrow = Exception('Database error');

      // Act & Assert
      expect(
        () => repository.getAllProducts(),
        throwsA(isA<ProductFailure>()),
      );
    });

    test('getProductById should return product when it exists', () async {
      // Arrange
      final model = ProductModel.fromEntity(MockData.sampleProduct1);
      mockDataSource.productToReturn = model;

      // Act
      final result = await repository.getProductById(1);

      // Assert
      expect(result, isNotNull);
      expect(result?.name, equals(MockData.sampleProduct1.name));
    });

    test('getProductById should return null when product does not exist', () async {
      // Arrange
      mockDataSource.productToReturn = null;

      // Act
      final result = await repository.getProductById(999);

      // Assert
      expect(result, isNull);
    });

    test('getProductById should throw ProductFailure on error', () async {
      // Arrange
      mockDataSource.exceptionToThrow = Exception('Database error');

      // Act & Assert
      expect(
        () => repository.getProductById(1),
        throwsA(isA<ProductFailure>()),
      );
    });

    test('searchProducts should return matching products', () async {
      // Arrange
      final models = [ProductModel.fromEntity(MockData.sampleProduct1)];
      mockDataSource.productsToReturn = models;

      // Act
      final result = await repository.searchProducts('Test');

      // Assert
      expect(result.length, equals(1));
      expect(mockDataSource.lastSearchQuery, equals('Test'));
    });

    test('searchProducts should throw ProductFailure on error', () async {
      // Arrange
      mockDataSource.exceptionToThrow = Exception('Database error');

      // Act & Assert
      expect(
        () => repository.searchProducts('Test'),
        throwsA(isA<ProductFailure>()),
      );
    });

    test('createProduct should create and return product', () async {
      // Arrange
      final product = MockData.sampleProduct1.copyWith(id: null);

      // Act
      final result = await repository.createProduct(product);

      // Assert
      expect(result, isA<Product>());
      expect(result.id, isNotNull);
      expect(mockDataSource.lastCreatedProduct?.name, equals(product.name));
    });

    test('createProduct should throw ProductFailure on error', () async {
      // Arrange
      final product = MockData.sampleProduct1;
      mockDataSource.exceptionToThrow = Exception('Database error');

      // Act & Assert
      expect(
        () => repository.createProduct(product),
        throwsA(isA<ProductFailure>()),
      );
    });

    test('updateProduct should return true when successful', () async {
      // Arrange
      final product = MockData.sampleProduct1;

      // Act
      final result = await repository.updateProduct(product);

      // Assert
      expect(result, isTrue);
      expect(mockDataSource.lastUpdatedProduct?.name, equals(product.name));
    });

    test('updateProduct should throw ProductFailure on error', () async {
      // Arrange
      final product = MockData.sampleProduct1;
      mockDataSource.exceptionToThrow = Exception('Database error');

      // Act & Assert
      expect(
        () => repository.updateProduct(product),
        throwsA(isA<ProductFailure>()),
      );
    });

    test('deleteProduct should return true when successful', () async {
      // Arrange
      const productId = 1;

      // Act
      final result = await repository.deleteProduct(productId);

      // Assert
      expect(result, isTrue);
      expect(mockDataSource.lastDeletedId, equals(productId));
    });

    test('deleteProduct should throw ProductFailure on error', () async {
      // Arrange
      mockDataSource.exceptionToThrow = Exception('Database error');

      // Act & Assert
      expect(
        () => repository.deleteProduct(1),
        throwsA(isA<ProductFailure>()),
      );
    });
  });
}

