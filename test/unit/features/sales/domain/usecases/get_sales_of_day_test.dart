import 'package:flutter_test/flutter_test.dart';
import 'package:stockito/features/sales/domain/entities/sale.dart';
import 'package:stockito/features/sales/domain/repositories/sale_repository.dart';
import 'package:stockito/features/sales/domain/usecases/get_sales_of_day.dart';
import '../../../../../helpers/mock_data.dart';

class MockSaleRepository implements SaleRepository {
  List<Sale>? salesToReturn;
  Exception? exceptionToThrow;
  DateTime? lastRequestedDay;

  @override
  Future<int> createSale(Sale sale) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Sale>> getSalesOfDay(DateTime day) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    lastRequestedDay = day;
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

void main() {
  late GetSalesOfDay useCase;
  late MockSaleRepository mockRepository;

  setUp(() {
    mockRepository = MockSaleRepository();
    useCase = GetSalesOfDay(mockRepository);
  });

  group('GetSalesOfDay', () {
    test('should get sales of a specific day from the repository', () async {
      // Arrange
      final day = MockData.baseDate;
      final expectedSales = [
        MockData.sampleSale1,
        MockData.sampleSale2,
      ];
      mockRepository.salesToReturn = expectedSales;

      // Act
      final result = await useCase(day);

      // Assert
      expect(result, equals(expectedSales));
      expect(mockRepository.lastRequestedDay, equals(day));
    });

    test('should return empty list when no sales for the day', () async {
      // Arrange
      final day = DateTime(2024, 1, 15);
      mockRepository.salesToReturn = [];

      // Act
      final result = await useCase(day);

      // Assert
      expect(result, isEmpty);
      expect(mockRepository.lastRequestedDay, equals(day));
    });

    test('should propagate errors from repository', () async {
      // Arrange
      final day = MockData.baseDate;
      final exception = Exception('Database error');
      mockRepository.exceptionToThrow = exception;

      // Act & Assert
      expect(() => useCase(day), throwsException);
    });

    test('should handle different dates correctly', () async {
      // Arrange
      final day1 = DateTime(2024, 1, 1);
      final day2 = DateTime(2024, 1, 2);
      final salesDay1 = [MockData.sampleSale1];
      final salesDay2 = [MockData.sampleSale2];

      mockRepository.salesToReturn = salesDay1;
      final result1 = await useCase(day1);

      mockRepository.salesToReturn = salesDay2;
      final result2 = await useCase(day2);

      // Assert
      expect(result1, equals(salesDay1));
      expect(result2, equals(salesDay2));
      expect(mockRepository.lastRequestedDay, equals(day2));
    });
  });
}

