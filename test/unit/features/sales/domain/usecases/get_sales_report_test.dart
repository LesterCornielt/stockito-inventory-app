import 'package:flutter_test/flutter_test.dart';
import 'package:stockito/features/products/domain/repositories/product_repository.dart';
import 'package:stockito/features/sales/domain/entities/sale.dart';
import 'package:stockito/features/sales/domain/repositories/sale_repository.dart';
import 'package:stockito/features/sales/domain/usecases/get_sales_report.dart';
import 'package:stockito/features/products/domain/entities/product.dart';
import '../../../../../helpers/mock_data.dart';

class MockSaleRepository implements SaleRepository {
  List<Sale>? salesToReturn;
  Exception? exceptionToThrow;

  @override
  Future<int> createSale(Sale sale) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Sale>> getSalesOfDay(DateTime day) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return salesToReturn ?? [];
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
  late GetSalesReport useCase;
  late MockSaleRepository mockSaleRepository;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockSaleRepository = MockSaleRepository();
    mockProductRepository = MockProductRepository();
    useCase = GetSalesReport(mockSaleRepository, mockProductRepository);
  });

  group('GetSalesReport', () {
    test('should generate report with product summaries and individual sales', () async {
      // Arrange
      final day = MockData.baseDate;
      final sales = [
        MockData.createSale(
          id: 1,
          productId: 1,
          productName: 'Producto Test 1',
          quantity: 5,
          pricePerUnit: 10000,
          totalAmount: 50000,
          date: day,
        ),
        MockData.createSale(
          id: 2,
          productId: 1,
          productName: 'Producto Test 1',
          quantity: 3,
          pricePerUnit: 10000,
          totalAmount: 30000,
          date: day,
        ),
      ];
      final products = [MockData.sampleProduct1];
      mockSaleRepository.salesToReturn = sales;
      mockProductRepository.productsToReturn = products;

      // Act
      final result = await useCase(day);

      // Assert
      expect(result.date, equals(day));
      expect(result.productReports.length, equals(1));
      expect(result.productReports[0].productName, equals('Producto Test 1'));
      expect(result.productReports[0].totalQuantity, equals(8)); // 5 + 3
      expect(result.productReports[0].totalAmount, equals(80000)); // 50000 + 30000
      expect(result.productReports[0].pricePerUnit, equals(10000));
      expect(result.individualSales.length, equals(2));
      expect(result.totalDailyAmount, equals(80000));
    });

    test('should return empty report when no sales for the day', () async {
      // Arrange
      final day = MockData.baseDate;
      mockSaleRepository.salesToReturn = [];
      mockProductRepository.productsToReturn = [];

      // Act
      final result = await useCase(day);

      // Assert
      expect(result.date, equals(day));
      expect(result.productReports, isEmpty);
      expect(result.individualSales, isEmpty);
      expect(result.totalDailyAmount, equals(0));
    });

    test('should handle multiple products correctly', () async {
      // Arrange
      final day = MockData.baseDate;
      final sales = [
        MockData.createSale(
          id: 1,
          productId: 1,
          productName: 'Producto 1',
          quantity: 2,
          pricePerUnit: 10000,
          totalAmount: 20000,
          date: day,
        ),
        MockData.createSale(
          id: 2,
          productId: 2,
          productName: 'Producto 2',
          quantity: 3,
          pricePerUnit: 20000,
          totalAmount: 60000,
          date: day,
        ),
      ];
      final products = [
        MockData.sampleProduct1,
        MockData.sampleProduct2,
      ];
      mockSaleRepository.salesToReturn = sales;
      mockProductRepository.productsToReturn = products;

      // Act
      final result = await useCase(day);

      // Assert
      expect(result.productReports.length, equals(2));
      expect(result.individualSales.length, equals(2));
      expect(result.totalDailyAmount, equals(80000)); // 20000 + 60000
    });

    test('should propagate errors from sale repository', () async {
      // Arrange
      final day = MockData.baseDate;
      final exception = Exception('Database error');
      mockSaleRepository.exceptionToThrow = exception;
      mockProductRepository.productsToReturn = [];

      // Act & Assert
      expect(() => useCase(day), throwsException);
    });

    test('should use product name from repository when available', () async {
      // Arrange
      final day = MockData.baseDate;
      final sales = [
        MockData.createSale(
          id: 1,
          productId: 1,
          productName: 'Old Name',
          quantity: 1,
          pricePerUnit: 10000,
          totalAmount: 10000,
          date: day,
        ),
      ];
      final products = [
        MockData.createProduct(
          id: 1,
          name: 'Updated Name',
        ),
      ];
      mockSaleRepository.salesToReturn = sales;
      mockProductRepository.productsToReturn = products;

      // Act
      final result = await useCase(day);

      // Assert
      expect(result.productReports[0].productName, equals('Updated Name'));
      expect(result.individualSales[0].productName, equals('Updated Name'));
    });
  });
}

