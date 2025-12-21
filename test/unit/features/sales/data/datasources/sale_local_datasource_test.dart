import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stockito/core/database/database_service.dart';
import 'package:stockito/features/sales/data/datasources/sale_local_datasource.dart';
import 'package:stockito/features/sales/data/models/sale_model.dart';
import '../../../../../helpers/test_helpers.dart';
import '../../../../../helpers/mock_data.dart';

void main() {
  Database? testDb;
  late SaleLocalDataSourceImpl dataSource;

  setUp(() async {
    // Reset DatabaseService first
    DatabaseService.resetDatabase();
    // Initialize sqflite_common_ffi
    TestHelpers.initSqfliteFfi();
    // Create test database
    testDb = await TestHelpers.initTestDatabase();
    // Override DatabaseService.database for testing
    DatabaseService.setTestDatabase(testDb!);
    // Create data source after database is set
    dataSource = SaleLocalDataSourceImpl();
  });

  tearDown(() async {
    if (testDb != null) {
      await TestHelpers.clearTestDatabase(testDb!);
      DatabaseService.resetDatabase();
    }
  });

  group('SaleLocalDataSourceImpl', () {
    test('createSale should insert sale and return id', () async {
      // Arrange
      final sale = SaleModel.fromEntity(MockData.sampleSale1.copyWith(id: null));

      // Act
      final result = await dataSource.createSale(sale);

      // Assert
      expect(result, isNotNull);
      expect(result, isA<int>());
      expect(result, greaterThan(0));
    });

    test('getSaleById should return null when sale does not exist', () async {
      // Act
      final result = await dataSource.getSaleById(999);

      // Assert
      expect(result, isNull);
    });

    test('getSaleById should return sale when it exists', () async {
      // Arrange
      final sale = SaleModel.fromEntity(MockData.sampleSale1.copyWith(id: null));
      final id = await dataSource.createSale(sale);

      // Act
      final result = await dataSource.getSaleById(id);

      // Assert
      expect(result, isNotNull);
      expect(result?.id, equals(id));
      expect(result?.productId, equals(sale.productId));
      expect(result?.quantity, equals(sale.quantity));
    });

    test('getSalesOfDay should return empty list when no sales for the day', () async {
      // Arrange
      final day = DateTime(2024, 1, 15);

      // Act
      final result = await dataSource.getSalesOfDay(day);

      // Assert
      expect(result, isEmpty);
    });

    test('getSalesOfDay should return sales for specific day', () async {
      // Arrange
      final day = MockData.baseDate;
      final sale1 = SaleModel.fromEntity(
        MockData.createSale(id: null, date: day),
      );
      final sale2 = SaleModel.fromEntity(
        MockData.createSale(id: null, date: day.add(const Duration(hours: 5))),
      );
      final sale3 = SaleModel.fromEntity(
        MockData.createSale(id: null, date: day.add(const Duration(days: 1))),
      );
      await dataSource.createSale(sale1);
      await dataSource.createSale(sale2);
      await dataSource.createSale(sale3);

      // Act
      final result = await dataSource.getSalesOfDay(day);

      // Assert
      expect(result.length, equals(2)); // sale1 and sale2, but not sale3
    });

    test('getAllSales should return empty list when no sales', () async {
      // Act
      final result = await dataSource.getAllSales();

      // Assert
      expect(result, isEmpty);
    });

    test('getAllSales should return all sales ordered by date DESC', () async {
      // Arrange
      final sale1 = SaleModel.fromEntity(
        MockData.createSale(id: null, date: DateTime(2024, 1, 1)),
      );
      final sale2 = SaleModel.fromEntity(
        MockData.createSale(id: null, date: DateTime(2024, 1, 2)),
      );
      final sale3 = SaleModel.fromEntity(
        MockData.createSale(id: null, date: DateTime(2024, 1, 3)),
      );
      await dataSource.createSale(sale1);
      await dataSource.createSale(sale2);
      await dataSource.createSale(sale3);

      // Act
      final result = await dataSource.getAllSales();

      // Assert
      expect(result.length, equals(3));
      // Should be ordered by date DESC (newest first)
      expect(result[0].date.isAfter(result[1].date), isTrue);
      expect(result[1].date.isAfter(result[2].date), isTrue);
    });

    test('updateSale should update existing sale', () async {
      // Arrange
      final sale = SaleModel.fromEntity(MockData.sampleSale1.copyWith(id: null));
      final id = await dataSource.createSale(sale);
      final updated = SaleModel(
        id: id,
        productId: sale.productId,
        productName: sale.productName,
        quantity: 10,
        pricePerUnit: sale.pricePerUnit,
        totalAmount: 100000,
        date: sale.date,
      );

      // Act
      await dataSource.updateSale(updated);

      // Assert
      final retrieved = await dataSource.getSaleById(id);
      expect(retrieved?.quantity, equals(10));
      expect(retrieved?.totalAmount, equals(100000));
    });

    test('deleteSale should remove sale from database', () async {
      // Arrange
      final sale = SaleModel.fromEntity(MockData.sampleSale1.copyWith(id: null));
      final id = await dataSource.createSale(sale);

      // Act
      await dataSource.deleteSale(id);

      // Assert
      final retrieved = await dataSource.getSaleById(id);
      expect(retrieved, isNull);
    });
  });
}

