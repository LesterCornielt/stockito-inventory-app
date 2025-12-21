import 'package:flutter_test/flutter_test.dart';
import 'package:stockito/features/sales/domain/entities/sale.dart';
import 'package:stockito/features/sales/domain/repositories/sale_repository.dart';
import 'package:stockito/features/sales/domain/usecases/create_sale.dart';
import '../../../../../helpers/mock_data.dart';

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
  late CreateSale useCase;
  late MockSaleRepository mockRepository;

  setUp(() {
    mockRepository = MockSaleRepository();
    useCase = CreateSale(mockRepository);
  });

  group('CreateSale', () {
    test('should create a sale through the repository', () async {
      // Arrange
      final sale = MockData.sampleSale1.copyWith(id: null);
      const expectedSaleId = 1;
      mockRepository.saleIdToReturn = expectedSaleId;

      // Act
      final result = await useCase(sale);

      // Assert
      expect(result, equals(expectedSaleId));
      expect(mockRepository.lastCreatedSale, equals(sale));
    });

    test('should propagate errors from repository', () async {
      // Arrange
      final sale = MockData.sampleSale1;
      final exception = Exception('Database error');
      mockRepository.exceptionToThrow = exception;

      // Act & Assert
      expect(() => useCase(sale), throwsException);
    });

    test('should return the sale id assigned by repository', () async {
      // Arrange
      final sale = MockData.createSale(id: null);
      const expectedSaleId = 42;
      mockRepository.saleIdToReturn = expectedSaleId;

      // Act
      final result = await useCase(sale);

      // Assert
      expect(result, equals(expectedSaleId));
    });

    test('should create sale with all required fields', () async {
      // Arrange
      final sale = MockData.createSale(
        id: null,
        productId: 5,
        productName: 'Special Product',
        quantity: 10,
        pricePerUnit: 15000,
        totalAmount: 150000,
      );
      mockRepository.saleIdToReturn = 1;

      // Act
      await useCase(sale);

      // Assert
      expect(mockRepository.lastCreatedSale?.productId, equals(5));
      expect(mockRepository.lastCreatedSale?.productName, equals('Special Product'));
      expect(mockRepository.lastCreatedSale?.quantity, equals(10));
      expect(mockRepository.lastCreatedSale?.pricePerUnit, equals(15000));
      expect(mockRepository.lastCreatedSale?.totalAmount, equals(150000));
    });
  });
}

