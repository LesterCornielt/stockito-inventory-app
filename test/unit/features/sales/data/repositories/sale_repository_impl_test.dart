import 'package:flutter_test/flutter_test.dart';
import 'package:stockito/features/sales/data/datasources/sale_local_datasource.dart';
import 'package:stockito/features/sales/data/models/sale_model.dart';
import 'package:stockito/features/sales/data/repositories/sale_repository_impl.dart';
import 'package:stockito/features/sales/domain/entities/sale.dart';
import '../../../../../helpers/mock_data.dart';

class MockSaleLocalDataSource implements SaleLocalDataSource {
  List<SaleModel>? salesToReturn;
  SaleModel? saleToReturn;
  Exception? exceptionToThrow;
  SaleModel? lastCreatedSale;
  SaleModel? lastUpdatedSale;
  int? lastDeletedSaleId;
  DateTime? lastRequestedDay;

  @override
  Future<int> createSale(SaleModel sale) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    lastCreatedSale = sale;
    return 1;
  }

  @override
  Future<List<SaleModel>> getSalesOfDay(DateTime day) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    lastRequestedDay = day;
    return salesToReturn ?? [];
  }

  @override
  Future<List<SaleModel>> getAllSales() async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return salesToReturn ?? [];
  }

  @override
  Future<SaleModel?> getSaleById(int saleId) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return saleToReturn;
  }

  @override
  Future<void> updateSale(SaleModel sale) async {
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

void main() {
  late SaleRepositoryImpl repository;
  late MockSaleLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockSaleLocalDataSource();
    repository = SaleRepositoryImpl(mockDataSource);
  });

  group('SaleRepositoryImpl', () {
    test('createSale should create and return sale id', () async {
      // Arrange
      final sale = MockData.sampleSale1.copyWith(id: null);

      // Act
      final result = await repository.createSale(sale);

      // Assert
      expect(result, equals(1));
      expect(mockDataSource.lastCreatedSale?.productId, equals(sale.productId));
    });

    test('getSalesOfDay should return sales for specific day', () async {
      // Arrange
      final day = MockData.baseDate;
      final models = [
        SaleModel.fromEntity(MockData.sampleSale1),
        SaleModel.fromEntity(MockData.sampleSale2),
      ];
      mockDataSource.salesToReturn = models;

      // Act
      final result = await repository.getSalesOfDay(day);

      // Assert
      expect(result.length, equals(2));
      expect(result[0], isA<Sale>());
      expect(mockDataSource.lastRequestedDay, equals(day));
    });

    test('getAllSales should return all sales', () async {
      // Arrange
      final models = [
        SaleModel.fromEntity(MockData.sampleSale1),
        SaleModel.fromEntity(MockData.sampleSale2),
      ];
      mockDataSource.salesToReturn = models;

      // Act
      final result = await repository.getAllSales();

      // Assert
      expect(result.length, equals(2));
      expect(result[0], isA<Sale>());
    });

    test('getSaleById should return sale when it exists', () async {
      // Arrange
      final model = SaleModel.fromEntity(MockData.sampleSale1);
      mockDataSource.saleToReturn = model;

      // Act
      final result = await repository.getSaleById(1);

      // Assert
      expect(result, isNotNull);
      expect(result?.id, equals(MockData.sampleSale1.id));
    });

    test('getSaleById should return null when sale does not exist', () async {
      // Arrange
      mockDataSource.saleToReturn = null;

      // Act
      final result = await repository.getSaleById(999);

      // Assert
      expect(result, isNull);
    });

    test('updateSale should update sale', () async {
      // Arrange
      final sale = MockData.sampleSale1;

      // Act
      await repository.updateSale(sale);

      // Assert
      expect(mockDataSource.lastUpdatedSale?.id, equals(sale.id));
      expect(mockDataSource.lastUpdatedSale?.quantity, equals(sale.quantity));
    });

    test('deleteSale should delete sale', () async {
      // Arrange
      const saleId = 1;

      // Act
      await repository.deleteSale(saleId);

      // Assert
      expect(mockDataSource.lastDeletedSaleId, equals(saleId));
    });

    test('should convert models to entities correctly', () async {
      // Arrange
      final models = [
        SaleModel.fromEntity(MockData.sampleSale1),
        SaleModel.fromEntity(MockData.sampleSale2),
      ];
      mockDataSource.salesToReturn = models;

      // Act
      final result = await repository.getAllSales();

      // Assert
      expect(result[0].id, equals(MockData.sampleSale1.id));
      expect(result[0].productName, equals(MockData.sampleSale1.productName));
      expect(result[1].id, equals(MockData.sampleSale2.id));
      expect(result[1].productName, equals(MockData.sampleSale2.productName));
    });
  });
}

