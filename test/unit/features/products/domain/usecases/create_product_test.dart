import 'package:flutter_test/flutter_test.dart';
import 'package:stockito/features/products/domain/entities/product.dart';
import 'package:stockito/features/products/domain/repositories/product_repository.dart';
import 'package:stockito/features/products/domain/usecases/create_product.dart';
import '../../../../../helpers/mock_data.dart';

class MockProductRepository implements ProductRepository {
  Product? productToReturn;
  Exception? exceptionToThrow;

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
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return productToReturn ?? product.copyWith(id: 1);
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
  late CreateProduct useCase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = CreateProduct(mockRepository);
  });

  group('CreateProduct', () {
    test('should create a product through the repository', () async {
      // Arrange
      final product = MockData.sampleProduct1.copyWith(id: null);
      final expectedProduct = product.copyWith(id: 1);
      mockRepository.productToReturn = expectedProduct;

      // Act
      final result = await useCase(product);

      // Assert
      expect(result, equals(expectedProduct));
      expect(result.id, isNotNull);
    });

    test('should propagate errors from repository', () async {
      // Arrange
      final product = MockData.sampleProduct1.copyWith(id: null);
      final exception = Exception('Database error');
      mockRepository.exceptionToThrow = exception;

      // Act & Assert
      expect(() => useCase(product), throwsException);
    });

    test('should assign an id to the created product', () async {
      // Arrange
      final productWithoutId = MockData.createProduct(
        id: null,
        name: 'New Product',
        price: 5000,
        stock: 10,
      );
      final expectedProduct = productWithoutId.copyWith(id: 1);
      mockRepository.productToReturn = expectedProduct;

      // Act
      final result = await useCase(productWithoutId);

      // Assert
      expect(result.id, isNotNull);
      expect(result.id, equals(1));
      expect(result.name, equals('New Product'));
      expect(result.price, equals(5000));
      expect(result.stock, equals(10));
    });
  });
}

