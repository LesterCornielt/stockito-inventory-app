import 'package:flutter_test/flutter_test.dart';
import 'package:stockito/features/products/domain/entities/product.dart';
import 'package:stockito/features/products/domain/repositories/product_repository.dart';
import 'package:stockito/features/products/domain/usecases/get_all_products.dart';
import '../../../../../helpers/mock_data.dart';

class MockProductRepository implements ProductRepository {
  List<Product>? productsToReturn;
  Exception? exceptionToThrow;

  @override
  Future<List<Product>> getAllProducts() async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return productsToReturn ?? [];
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
    throw UnimplementedError();
  }
}

void main() {
  late GetAllProducts useCase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = GetAllProducts(mockRepository);
  });

  group('GetAllProducts', () {
    test('should get all products from the repository', () async {
      // Arrange
      final expectedProducts = MockData.sampleProducts;
      mockRepository.productsToReturn = expectedProducts;

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result, equals(expectedProducts));
      expect(result.length, equals(3));
    });

    test('should return empty list when repository returns empty list', () async {
      // Arrange
      mockRepository.productsToReturn = [];

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result, isEmpty);
    });

    test('should propagate errors from repository', () async {
      // Arrange
      final exception = Exception('Database error');
      mockRepository.exceptionToThrow = exception;

      // Act & Assert
      expect(() => useCase(NoParams()), throwsException);
    });

    test('should return products in the same order as repository', () async {
      // Arrange
      final products = [
        MockData.sampleProduct1,
        MockData.sampleProduct2,
        MockData.sampleProduct3,
      ];
      mockRepository.productsToReturn = products;

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result.length, equals(3));
      expect(result[0], equals(MockData.sampleProduct1));
      expect(result[1], equals(MockData.sampleProduct2));
      expect(result[2], equals(MockData.sampleProduct3));
    });
  });
}

