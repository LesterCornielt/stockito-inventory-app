import 'package:flutter_test/flutter_test.dart';
import 'package:stockito/features/products/domain/entities/product.dart';
import 'package:stockito/features/products/domain/repositories/product_repository.dart';
import 'package:stockito/features/products/domain/usecases/delete_product.dart';

class MockProductRepository implements ProductRepository {
  bool? deleteResult;
  Exception? exceptionToThrow;
  int? lastDeletedId;

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
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteProduct(int id) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    lastDeletedId = id;
    return deleteResult ?? true;
  }
}

void main() {
  late DeleteProduct useCase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = DeleteProduct(mockRepository);
  });

  group('DeleteProduct', () {
    test('should delete a product through the repository', () async {
      // Arrange
      const productId = 1;
      mockRepository.deleteResult = true;

      // Act
      final result = await useCase(productId);

      // Assert
      expect(result, isTrue);
      expect(mockRepository.lastDeletedId, equals(productId));
    });

    test('should return false when deletion fails', () async {
      // Arrange
      const productId = 1;
      mockRepository.deleteResult = false;

      // Act
      final result = await useCase(productId);

      // Assert
      expect(result, isFalse);
      expect(mockRepository.lastDeletedId, equals(productId));
    });

    test('should propagate errors from repository', () async {
      // Arrange
      const productId = 1;
      final exception = Exception('Database error');
      mockRepository.exceptionToThrow = exception;

      // Act & Assert
      expect(() => useCase(productId), throwsException);
    });

    test('should delete product with correct id', () async {
      // Arrange
      const productId = 42;
      mockRepository.deleteResult = true;

      // Act
      final result = await useCase(productId);

      // Assert
      expect(result, isTrue);
      expect(mockRepository.lastDeletedId, equals(42));
    });
  });
}

