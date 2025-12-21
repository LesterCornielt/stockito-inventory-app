import 'package:flutter_test/flutter_test.dart';
import 'package:stockito/features/products/domain/entities/product.dart';
import 'package:stockito/features/products/domain/repositories/product_repository.dart';
import 'package:stockito/features/sales/domain/entities/sale.dart';
import 'package:stockito/features/sales/domain/repositories/sale_repository.dart';
import 'package:stockito/features/sales/domain/usecases/register_sale_from_stock_update.dart';
import '../../../../../helpers/mock_data.dart';

class MockProductRepository implements ProductRepository {
  Product? productToReturn;
  Exception? exceptionToThrow;
  Product? lastUpdatedProduct;

  @override
  Future<List<Product>> getAllProducts() async {
    throw UnimplementedError();
  }

  @override
  Future<Product?> getProductById(int id) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return productToReturn;
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
    return true;
  }

  @override
  Future<bool> deleteProduct(int id) async {
    throw UnimplementedError();
  }
}

class MockSaleRepository implements SaleRepository {
  int? saleIdToReturn;
  Exception? exceptionToThrow;
  Sale? lastCreatedSale;

  @override
  Future<int> createSale(Sale sale) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    lastCreatedSale = sale;
    return saleIdToReturn ?? 1;
  }

  @override
  Future<List<Sale>> getSalesOfDay(DateTime day) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Sale>> getAllSales() async {
    throw UnimplementedError();
  }

  @override
  Future<Sale?> getSaleById(int saleId) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateSale(Sale sale) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteSale(int saleId) async {
    throw UnimplementedError();
  }
}

void main() {
  late RegisterSaleFromStockUpdate useCase;
  late MockProductRepository mockProductRepository;
  late MockSaleRepository mockSaleRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    mockSaleRepository = MockSaleRepository();
    useCase = RegisterSaleFromStockUpdate(
      productRepository: mockProductRepository,
      saleRepository: mockSaleRepository,
    );
  });

  group('RegisterSaleFromStockUpdate', () {
    test('should create sale and update product stock', () async {
      // Arrange
      final product = MockData.createProduct(
        id: 1,
        name: 'Test Product',
        price: 10000,
        stock: 50,
      );
      const quantitySold = 5;
      mockProductRepository.productToReturn = product;
      mockSaleRepository.saleIdToReturn = 1;

      // Act
      await useCase(1, quantitySold);

      // Assert
      expect(mockSaleRepository.lastCreatedSale, isNotNull);
      expect(mockSaleRepository.lastCreatedSale?.productId, equals(1));
      expect(mockSaleRepository.lastCreatedSale?.productName, equals('Test Product'));
      expect(mockSaleRepository.lastCreatedSale?.quantity, equals(quantitySold));
      expect(mockSaleRepository.lastCreatedSale?.pricePerUnit, equals(10000));
      expect(mockSaleRepository.lastCreatedSale?.totalAmount, equals(50000));
      expect(mockProductRepository.lastUpdatedProduct?.stock, equals(45)); // 50 - 5
    });

    test('should throw exception when product does not exist', () async {
      // Arrange
      mockProductRepository.productToReturn = null;

      // Act & Assert
      expect(
        () => useCase(999, 5),
        throwsA(predicate((e) => e.toString().contains('Producto no encontrado'))),
      );
    });

    test('should not allow stock to go below zero', () async {
      // Arrange
      final product = MockData.createProduct(
        id: 1,
        stock: 3, // Only 3 in stock
      );
      const quantitySold = 10; // Try to sell 10
      mockProductRepository.productToReturn = product;

      // Act
      await useCase(1, quantitySold);

      // Assert
      expect(mockProductRepository.lastUpdatedProduct?.stock, equals(0)); // Should be 0, not -7
      expect(mockSaleRepository.lastCreatedSale?.quantity, equals(10)); // Sale still recorded
    });

    test('should calculate totalAmount correctly', () async {
      // Arrange
      final product = MockData.createProduct(
        id: 1,
        price: 15000,
        stock: 20,
      );
      const quantitySold = 4;
      mockProductRepository.productToReturn = product;

      // Act
      await useCase(1, quantitySold);

      // Assert
      expect(mockSaleRepository.lastCreatedSale?.totalAmount, equals(60000)); // 15000 * 4
    });

    test('should use current date for sale', () async {
      // Arrange
      final product = MockData.sampleProduct1;
      final beforeCall = DateTime.now();
      mockProductRepository.productToReturn = product;

      // Act
      await useCase(1, 5);
      final afterCall = DateTime.now();

      // Assert
      expect(mockSaleRepository.lastCreatedSale?.date, isNotNull);
      expect(
        mockSaleRepository.lastCreatedSale?.date.isAfter(beforeCall.subtract(const Duration(seconds: 1))),
        isTrue,
      );
      expect(
        mockSaleRepository.lastCreatedSale?.date.isBefore(afterCall.add(const Duration(seconds: 1))),
        isTrue,
      );
    });

    test('should propagate errors from product repository', () async {
      // Arrange
      final exception = Exception('Database error');
      mockProductRepository.exceptionToThrow = exception;

      // Act & Assert
      expect(() => useCase(1, 5), throwsException);
    });

    test('should propagate errors from sale repository', () async {
      // Arrange
      final product = MockData.sampleProduct1;
      final exception = Exception('Sale creation failed');
      mockProductRepository.productToReturn = product;
      mockSaleRepository.exceptionToThrow = exception;

      // Act & Assert
      expect(() => useCase(1, 5), throwsException);
    });
  });
}

