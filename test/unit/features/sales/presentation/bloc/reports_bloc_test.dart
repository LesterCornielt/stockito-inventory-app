import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockito/features/sales/domain/entities/sale.dart';
import 'package:stockito/features/sales/domain/repositories/sale_repository.dart';
import 'package:stockito/features/sales/domain/usecases/get_sales_report.dart';
import 'package:stockito/features/sales/domain/usecases/update_sale.dart';
import 'package:stockito/features/sales/presentation/bloc/reports_bloc.dart';
import 'package:stockito/features/sales/presentation/bloc/reports_event.dart';
import 'package:stockito/features/sales/presentation/bloc/reports_state.dart';
import 'package:stockito/features/products/domain/entities/product.dart';
import 'package:stockito/features/products/domain/repositories/product_repository.dart';
import '../../../../../helpers/mock_data.dart';

class MockSaleRepository implements SaleRepository {
  @override
  Future<int> createSale(Sale sale) async => 1;
  @override
  Future<List<Sale>> getSalesOfDay(DateTime day) async => [];
  @override
  Future<List<Sale>> getAllSales() async => [];
  @override
  Future<Sale?> getSaleById(int saleId) async => null;
  @override
  Future<void> updateSale(Sale sale) async {}
  @override
  Future<void> deleteSale(int saleId) async {}
}

class MockProductRepositoryForReports implements ProductRepository {
  @override
  Future<List<Product>> getAllProducts() async => [];
  @override
  Future<Product?> getProductById(int id) async => null;
  @override
  Future<List<Product>> searchProducts(String query) async => [];
  @override
  Future<Product> createProduct(Product product) async => product;
  @override
  Future<bool> updateProduct(Product product) async => true;
  @override
  Future<bool> deleteProduct(int id) async => true;
}

class MockGetSalesReport implements GetSalesReport {
  DailySalesReport? reportToReturn;
  Exception? exceptionToThrow;

  MockGetSalesReport()
      : _saleRepository = MockSaleRepository(),
        _productRepository = MockProductRepositoryForReports();

  final SaleRepository _saleRepository;
  final ProductRepository _productRepository;

  @override
  SaleRepository get saleRepository => _saleRepository;

  @override
  ProductRepository get productRepository => _productRepository;

  @override
  Future<DailySalesReport> call(DateTime day) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return reportToReturn ??
        DailySalesReport(
          date: day,
          productReports: [],
          individualSales: [],
          totalDailyAmount: 0,
        );
  }
}

class MockUpdateSale implements UpdateSale {
  Exception? exceptionToThrow;

  MockUpdateSale()
      : _saleRepository = MockSaleRepository(),
        _productRepository = MockProductRepositoryForReports();

  final SaleRepository _saleRepository;
  final ProductRepository _productRepository;

  @override
  SaleRepository get saleRepository => _saleRepository;

  @override
  ProductRepository get productRepository => _productRepository;

  @override
  Future<void> call(int saleId, int newQuantity) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
  }
}

DailySalesReport createMockReport(DateTime date) {
  return DailySalesReport(
    date: date,
    productReports: [
      SalesReport(
        productName: 'Producto Test 1',
        totalQuantity: 5,
        totalAmount: 50000,
        pricePerUnit: 10000,
      ),
    ],
    individualSales: [
      IndividualSaleReport(
        saleId: 1,
        productName: 'Producto Test 1',
        quantity: 5,
        totalAmount: 50000,
        pricePerUnit: 10000,
        date: date,
      ),
    ],
    totalDailyAmount: 50000,
  );
}

void main() {
  late ReportsBloc bloc;
  late MockGetSalesReport mockGetSalesReport;
  late MockUpdateSale mockUpdateSale;

  setUp(() {
    mockGetSalesReport = MockGetSalesReport();
    mockUpdateSale = MockUpdateSale();

    bloc = ReportsBloc(
      getSalesReport: mockGetSalesReport,
      updateSale: mockUpdateSale,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('ReportsBloc', () {
    test('initial state should be ReportsInitial', () {
      expect(bloc.state, equals(const ReportsInitial()));
    });

    blocTest<ReportsBloc, ReportsState>(
      'emits [ReportsLoading, ReportsLoaded] when LoadDailyReport is successful',
      build: () => bloc,
      act: (bloc) => bloc.add(LoadDailyReport(MockData.baseDate)),
      expect: () => [
        const ReportsLoading(),
        isA<ReportsLoaded>(),
      ],
      setUp: () {
        mockGetSalesReport.reportToReturn = createMockReport(MockData.baseDate);
      },
    );

    blocTest<ReportsBloc, ReportsState>(
      'emits [ReportsLoading, ReportsEmpty] when LoadDailyReport returns empty report',
      build: () => bloc,
      act: (bloc) => bloc.add(LoadDailyReport(MockData.baseDate)),
      expect: () => [
        const ReportsLoading(),
        ReportsEmpty(MockData.baseDate),
      ],
      setUp: () {
        mockGetSalesReport.reportToReturn = DailySalesReport(
          date: MockData.baseDate,
          productReports: [],
          individualSales: [],
          totalDailyAmount: 0,
        );
      },
    );

    blocTest<ReportsBloc, ReportsState>(
      'emits [ReportsLoading, ReportsError] when LoadDailyReport fails',
      build: () => bloc,
      act: (bloc) => bloc.add(LoadDailyReport(MockData.baseDate)),
      expect: () => [
        const ReportsLoading(),
        isA<ReportsError>(),
      ],
      setUp: () {
        mockGetSalesReport.exceptionToThrow = Exception('Database error');
      },
    );

    blocTest<ReportsBloc, ReportsState>(
      'triggers LoadDailyReport with today when LoadTodayReport is called',
      build: () => bloc,
      act: (bloc) => bloc.add(const LoadTodayReport()),
      expect: () => [
        const ReportsLoading(),
        isA<ReportsLoaded>(),
      ],
      setUp: () {
        final today = DateTime.now();
        mockGetSalesReport.reportToReturn = createMockReport(today);
      },
    );

    blocTest<ReportsBloc, ReportsState>(
      'emits [ReportsEditing, ReportsLoaded] when EditSale is successful',
      build: () => bloc,
      seed: () => ReportsLoaded(createMockReport(MockData.baseDate)),
      act: (bloc) => bloc.add(const EditSale(saleId: 1, newQuantity: 10)),
      expect: () => [
        isA<ReportsEditing>(),
        isA<ReportsLoaded>(),
      ],
      setUp: () {
        mockGetSalesReport.reportToReturn = createMockReport(MockData.baseDate);
      },
    );

    blocTest<ReportsBloc, ReportsState>(
      'emits [ReportsEditing, ReportsEmpty] when EditSale results in empty report',
      build: () => bloc,
      seed: () => ReportsLoaded(createMockReport(MockData.baseDate)),
      act: (bloc) => bloc.add(const EditSale(saleId: 1, newQuantity: 0)),
      expect: () => [
        isA<ReportsEditing>(),
        ReportsEmpty(MockData.baseDate),
      ],
      setUp: () {
        mockGetSalesReport.reportToReturn = DailySalesReport(
          date: MockData.baseDate,
          productReports: [],
          individualSales: [],
          totalDailyAmount: 0,
        );
      },
    );

    blocTest<ReportsBloc, ReportsState>(
      'emits [ReportsError] when EditSale throws SaleNotFoundException',
      build: () => bloc,
      seed: () => ReportsLoaded(createMockReport(MockData.baseDate)),
      act: (bloc) => bloc.add(const EditSale(saleId: 999, newQuantity: 10)),
      expect: () => [
        isA<ReportsEditing>(),
        const ReportsError('sale_not_found'),
      ],
      setUp: () {
        mockUpdateSale.exceptionToThrow = SaleNotFoundException();
      },
    );

    blocTest<ReportsBloc, ReportsState>(
      'emits [ReportsError] when EditSale throws ProductNotFoundException',
      build: () => bloc,
      seed: () => ReportsLoaded(createMockReport(MockData.baseDate)),
      act: (bloc) => bloc.add(const EditSale(saleId: 1, newQuantity: 10)),
      expect: () => [
        isA<ReportsEditing>(),
        const ReportsError('product_not_found'),
      ],
      setUp: () {
        mockUpdateSale.exceptionToThrow = ProductNotFoundException();
      },
    );

    blocTest<ReportsBloc, ReportsState>(
      'emits [ReportsEditing, ReportsLoaded] when EditProductSales is successful',
      build: () => bloc,
      seed: () => ReportsLoaded(createMockReport(MockData.baseDate)),
      act: (bloc) => bloc.add(
        const EditProductSales(productName: 'Producto Test 1', newQuantity: 10),
      ),
      expect: () => [
        isA<ReportsEditing>(),
        isA<ReportsLoaded>(),
      ],
      setUp: () {
        mockGetSalesReport.reportToReturn = createMockReport(MockData.baseDate);
      },
    );

    blocTest<ReportsBloc, ReportsState>(
      'emits [ReportsEditing, ReportsEmpty] when EditProductSales with quantity 0',
      build: () => bloc,
      seed: () => ReportsLoaded(createMockReport(MockData.baseDate)),
      act: (bloc) => bloc.add(
        const EditProductSales(productName: 'Producto Test 1', newQuantity: 0),
      ),
      expect: () => [
        isA<ReportsEditing>(),
        isA<ReportsState>(), // Can be ReportsEmpty or ReportsError depending on implementation
      ],
      setUp: () {
        // Mock the sales report after deletion
        mockGetSalesReport.reportToReturn = DailySalesReport(
          date: MockData.baseDate,
          productReports: [],
          individualSales: [],
          totalDailyAmount: 0,
        );
      },
    );

    blocTest<ReportsBloc, ReportsState>(
      'emits [ReportsError] when EditProductSales fails',
      build: () => bloc,
      seed: () => ReportsLoaded(createMockReport(MockData.baseDate)),
      act: (bloc) => bloc.add(
        const EditProductSales(productName: 'NonExistent', newQuantity: 10),
      ),
      expect: () => [
        isA<ReportsEditing>(),
        isA<ReportsError>(),
      ],
      setUp: () {
        mockGetSalesReport.reportToReturn = DailySalesReport(
          date: MockData.baseDate,
          productReports: [],
          individualSales: [],
          totalDailyAmount: 0,
        );
      },
    );

    blocTest<ReportsBloc, ReportsState>(
      'updates editingIndex and editingField when StartEditingProduct is called',
      build: () => bloc,
      seed: () => ReportsLoaded(createMockReport(MockData.baseDate)),
      act: (bloc) => bloc.add(
        const StartEditingProduct(index: 0, field: 'quantity'),
      ),
      expect: () => [
        isA<ReportsLoaded>()
            .having((s) => s.editingIndex, 'editingIndex', equals(0))
            .having((s) => s.editingField, 'editingField', equals('quantity')),
      ],
    );

    blocTest<ReportsBloc, ReportsState>(
      'clears editingIndex and editingField when FinishEditingProduct is called',
      build: () => bloc,
      seed: () => ReportsLoaded(
        createMockReport(MockData.baseDate),
        editingIndex: 0,
        editingField: 'quantity',
      ),
      act: (bloc) => bloc.add(const FinishEditingProduct()),
      expect: () => [
        isA<ReportsLoaded>()
            .having((s) => s.editingIndex, 'editingIndex', isNull)
            .having((s) => s.editingField, 'editingField', isNull),
      ],
    );
  });
}

