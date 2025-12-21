import 'package:flutter_test/flutter_test.dart';
import 'package:stockito/features/products/domain/entities/product.dart';
import 'package:stockito/features/products/domain/repositories/product_repository.dart';
import 'package:stockito/features/products/domain/usecases/update_product.dart';
import '../../../../../helpers/mock_data.dart';

class MockProductRepository implements ProductRepository {
  bool? updateResult;
  Exception? exceptionToThrow;
  Product? lastUpdatedProduct;

  @override
  Future<List<Product>> getAllProducts() async {
    throw UnimplementedError();
  }

  @override
  Future<Product?> getProductById(int id) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    throw UnimplementedError();
  }

  @override
  Future<Product> createProduct(Product product) async {
    throw UnimplementedError();
  }

  @override
  Future<bool> updateProduct(Product product) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    lastUpdatedProduct = product;
    return updateResult ?? true;
  }

  @override
  Future<bool> deleteProduct(int id) async {
    throw UnimplementedError();
  }
}

void main() {
  late UpdateProduct useCase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = UpdateProduct(mockRepository);
  });

  group('UpdateProduct', () {
    test('should update a product through the repository', () async {
      // Arrange
      final product = MockData.sampleProduct1.copyWith(
        name: 'Updated Product',
        price: 15000,
        stock: 75,
      );
      mockRepository.updateResult = true;

      // Act
      final result = await useCase(product);

      // Assert
      expect(result, isTrue);
      expect(mockRepository.lastUpdatedProduct, equals(product));
    });

    test('should return false when update fails', () async {
      // Arrange
      final product = MockData.sampleProduct1;
      mockRepository.updateResult = false;

      // Act
      final result = await useCase(product);

      // Assert
      expect(result, isFalse);
    });

    test('should propagate errors from repository', () async {
      // Arrange
      final product = MockData.sampleProduct1;
      final exception = Exception('Database error');
      mockRepository.exceptionToThrow = exception;

      // Act & Assert
      expect(() => useCase(product), throwsException);
    });

    test('should update product with all fields', () async {
      // Arrange
      final updatedProduct = MockData.createProduct(
        id: 1,
        name: 'Completely New Name',
        price: 25000,
        stock: 100,
      );
      mockRepository.updateResult = true;

      // Act
      final result = await useCase(updatedProduct);

      // Assert
      expect(result, isTrue);
      expect(mockRepository.lastUpdatedProduct?.name, equals('Completely New Name'));
      expect(mockRepository.lastUpdatedProduct?.price, equals(25000));
      expect(mockRepository.lastUpdatedProduct?.stock, equals(100));
    });
  });
}

