import 'package:flutter_test/flutter_test.dart';
import 'package:stockito/features/products/domain/entities/product.dart';
import 'package:stockito/features/products/domain/repositories/product_repository.dart';
import 'package:stockito/features/sales/domain/entities/sale.dart';
import 'package:stockito/features/sales/domain/repositories/sale_repository.dart';
import 'package:stockito/features/sales/domain/usecases/update_sale.dart';
import '../../../../../helpers/mock_data.dart';

class MockSaleRepository implements SaleRepository {
  Sale? saleToReturn;
  Exception? exceptionToThrow;
  Sale? lastUpdatedSale;
  int? lastDeletedSaleId;

  @override
  Future<int> createSale(Sale sale) async {
    throw UnimplementedError();
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
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return saleToReturn;
  }

  @override
  Future<void> updateSale(Sale sale) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    lastUpdatedSale = sale;
  }

  @override
  Future<void> deleteSale(int saleId) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    lastDeletedSaleId = saleId;
  }
}

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

void main() {
  late UpdateSale useCase;
  late MockSaleRepository mockSaleRepository;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockSaleRepository = MockSaleRepository();
    mockProductRepository = MockProductRepository();
    useCase = UpdateSale(
      saleRepository: mockSaleRepository,
      productRepository: mockProductRepository,
    );
  });

  group('UpdateSale', () {
    test('should update sale quantity and adjust stock', () async {
      // Arrange
      final sale = MockData.createSale(
        id: 1,
        productId: 1,
        quantity: 5,
        pricePerUnit: 10000,
        totalAmount: 50000,
      );
      final product = MockData.createProduct(
        id: 1,
        stock: 10,
      );
      mockSaleRepository.saleToReturn = sale;
      mockProductRepository.productToReturn = product;

      // Act
      await useCase(1, 8); // Update quantity from 5 to 8

      // Assert
      expect(mockSaleRepository.lastUpdatedSale?.quantity, equals(8));
      expect(mockSaleRepository.lastUpdatedSale?.totalAmount, equals(80000));
      expect(mockProductRepository.lastUpdatedProduct?.stock, equals(7)); // 10 - (8-5) = 7
    });

    test('should delete sale when new quantity is zero', () async {
      // Arrange
      final sale = MockData.createSale(
        id: 1,
        productId: 1,
        quantity: 5,
      );
      final product = MockData.createProduct(
        id: 1,
        stock: 10,
      );
      mockSaleRepository.saleToReturn = sale;
      mockProductRepository.productToReturn = product;

      // Act
      await useCase(1, 0);

      // Assert
      expect(mockSaleRepository.lastDeletedSaleId, equals(1));
      expect(mockProductRepository.lastUpdatedProduct?.stock, equals(15)); // 10 + 5
    });

    test('should throw SaleNotFoundException when sale does not exist', () async {
      // Arrange
      mockSaleRepository.saleToReturn = null;
      mockProductRepository.productToReturn = MockData.sampleProduct1;

      // Act & Assert
      expect(() => useCase(999, 10), throwsA(isA<SaleNotFoundException>()));
    });

    test('should throw ProductNotFoundException when product does not exist', () async {
      // Arrange
      final sale = MockData.createSale(id: 1, productId: 1);
      mockSaleRepository.saleToReturn = sale;
      mockProductRepository.productToReturn = null;

      // Act & Assert
      expect(() => useCase(1, 10), throwsA(isA<ProductNotFoundException>()));
    });

    test('should not allow stock to go below zero', () async {
      // Arrange
      final sale = MockData.createSale(
        id: 1,
        productId: 1,
        quantity: 5,
      );
      final product = MockData.createProduct(
        id: 1,
        stock: 2, // Only 2 in stock
      );
      mockSaleRepository.saleToReturn = sale;
      mockProductRepository.productToReturn = product;

      // Act
      await useCase(1, 10); // Try to increase from 5 to 10, but only 2 in stock

      // Assert
      expect(mockProductRepository.lastUpdatedProduct?.stock, equals(0)); // Should be 0, not negative
    });

    test('should handle decreasing quantity correctly', () async {
      // Arrange
      final sale = MockData.createSale(
        id: 1,
        productId: 1,
        quantity: 10,
      );
      final product = MockData.createProduct(
        id: 1,
        stock: 5,
      );
      mockSaleRepository.saleToReturn = sale;
      mockProductRepository.productToReturn = product;

      // Act
      await useCase(1, 3); // Decrease from 10 to 3

      // Assert
      expect(mockSaleRepository.lastUpdatedSale?.quantity, equals(3));
      expect(mockProductRepository.lastUpdatedProduct?.stock, equals(12)); // 5 + (10-3) = 12
    });
  });
}

