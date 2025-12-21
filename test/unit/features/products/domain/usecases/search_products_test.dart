import 'package:flutter_test/flutter_test.dart';
import 'package:stockito/features/products/domain/entities/product.dart';
import 'package:stockito/features/products/domain/repositories/product_repository.dart';
import 'package:stockito/features/products/domain/usecases/search_products.dart';
import '../../../../../helpers/mock_data.dart';

class MockProductRepository implements ProductRepository {
  List<Product>? productsToReturn;
  Exception? exceptionToThrow;
  String? lastSearchQuery;

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
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    lastSearchQuery = query;
    return productsToReturn ?? [];
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
    throw UnimplementedError();
  }
}

void main() {
  late SearchProducts useCase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = SearchProducts(mockRepository);
  });

  group('SearchProducts', () {
    test('should search products through the repository', () async {
      // Arrange
      const searchQuery = 'Test';
      final expectedProducts = [
        MockData.sampleProduct1,
        MockData.sampleProduct2,
      ];
      mockRepository.productsToReturn = expectedProducts;

      // Act
      final result = await useCase(searchQuery);

      // Assert
      expect(result, equals(expectedProducts));
      expect(mockRepository.lastSearchQuery, equals(searchQuery));
    });

    test('should return empty list when no products match', () async {
      // Arrange
      const searchQuery = 'NonExistent';
      mockRepository.productsToReturn = [];

      // Act
      final result = await useCase(searchQuery);

      // Assert
      expect(result, isEmpty);
      expect(mockRepository.lastSearchQuery, equals(searchQuery));
    });

    test('should propagate errors from repository', () async {
      // Arrange
      const searchQuery = 'Test';
      final exception = Exception('Database error');
      mockRepository.exceptionToThrow = exception;

      // Act & Assert
      expect(() => useCase(searchQuery), throwsException);
    });

    test('should handle empty search query', () async {
      // Arrange
      const searchQuery = '';
      mockRepository.productsToReturn = [];

      // Act
      final result = await useCase(searchQuery);

      // Assert
      expect(result, isEmpty);
      expect(mockRepository.lastSearchQuery, equals(''));
    });

    test('should handle case-sensitive search queries', () async {
      // Arrange
      const searchQuery = 'PRODUCT';
      final expectedProducts = [MockData.sampleProduct1];
      mockRepository.productsToReturn = expectedProducts;

      // Act
      final result = await useCase(searchQuery);

      // Assert
      expect(result, equals(expectedProducts));
      expect(mockRepository.lastSearchQuery, equals('PRODUCT'));
    });
  });
}

