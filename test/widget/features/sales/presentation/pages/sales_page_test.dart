import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockito/features/products/presentation/bloc/product_bloc.dart';
import 'package:stockito/features/products/presentation/bloc/product_event.dart';
import 'package:stockito/features/products/presentation/bloc/product_state.dart';
import 'package:stockito/features/sales/domain/usecases/get_sales_report.dart';
import 'package:stockito/features/sales/presentation/bloc/reports_bloc.dart';
import 'package:stockito/features/sales/presentation/bloc/reports_event.dart';
import 'package:stockito/features/sales/presentation/bloc/reports_state.dart';
import 'package:stockito/features/sales/presentation/pages/sales_page.dart';
import '../../../../../helpers/mock_data.dart';
import '../../../../../helpers/widget_test_helpers.dart';

class MockReportsBloc extends MockBloc<ReportsEvent, ReportsState>
    implements ReportsBloc {}

class MockProductBloc extends MockBloc<ProductEvent, ProductState>
    implements ProductBloc {}

DailySalesReport createMockReport(DateTime date) {
  return DailySalesReport(
    date: date,
    productReports: [
      SalesReport(
        productName: 'Product 1',
        totalQuantity: 5,
        totalAmount: 50000,
        pricePerUnit: 10000,
      ),
      SalesReport(
        productName: 'Product 2',
        totalQuantity: 3,
        totalAmount: 60000,
        pricePerUnit: 20000,
      ),
    ],
    individualSales: [],
    totalDailyAmount: 110000,
  );
}

void main() {
  group('SalesPage Widget Tests', () {
    late MockReportsBloc mockReportsBloc;
    late MockProductBloc mockProductBloc;

    setUp(() {
      mockReportsBloc = MockReportsBloc();
      mockProductBloc = MockProductBloc();
    });

    Widget createWidgetUnderTest() {
      return WidgetTestHelpers.createTestApp(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<ReportsBloc>.value(value: mockReportsBloc),
            BlocProvider<ProductBloc>.value(value: mockProductBloc),
          ],
          child: const SalesPage(),
        ),
      );
    }

    testWidgets('should display loading indicator when state is ReportsLoading',
        (WidgetTester tester) async {
      whenListen(
        mockReportsBloc,
        Stream.fromIterable([const ReportsLoading()]),
        initialState: const ReportsLoading(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display report content when state is ReportsLoaded',
        (WidgetTester tester) async {
      final report = createMockReport(MockData.baseDate);
      whenListen(
        mockReportsBloc,
        Stream.fromIterable([ReportsLoaded(report)]),
        initialState: ReportsLoaded(report),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Sales Reports'), findsOneWidget);
      expect(find.text('Daily Summary'), findsOneWidget);
      expect(find.text('Product 1'), findsOneWidget);
      expect(find.text('Product 2'), findsOneWidget);
    });

    testWidgets('should display empty state when state is ReportsEmpty',
        (WidgetTester tester) async {
      whenListen(
        mockReportsBloc,
        Stream.fromIterable([
          ReportsEmpty(MockData.baseDate),
        ]),
        initialState: ReportsEmpty(MockData.baseDate),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(
        find.text('No sales registered'),
        findsOneWidget,
      );
    });

    testWidgets('should display error state when state is ReportsError',
        (WidgetTester tester) async {
      const errorMessage = 'Failed to load reports';
      whenListen(
        mockReportsBloc,
        Stream.fromIterable([
          const ReportsError(errorMessage),
        ]),
        initialState: const ReportsError(errorMessage),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Error loading reports'), findsOneWidget);
    });

    testWidgets('should display refresh button', (WidgetTester tester) async {
      final report = createMockReport(MockData.baseDate);
      whenListen(
        mockReportsBloc,
        Stream.fromIterable([ReportsLoaded(report)]),
        initialState: ReportsLoaded(report),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('should display date selector', (WidgetTester tester) async {
      final report = createMockReport(MockData.baseDate);
      whenListen(
        mockReportsBloc,
        Stream.fromIterable([ReportsLoaded(report)]),
        initialState: ReportsLoaded(report),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });

    testWidgets('should display summary cards with correct data',
        (WidgetTester tester) async {
      final report = createMockReport(MockData.baseDate);
      whenListen(
        mockReportsBloc,
        Stream.fromIterable([ReportsLoaded(report)]),
        initialState: ReportsLoaded(report),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Check for products sold count
      expect(find.text('2'), findsWidgets); // 2 products sold
      // Check for total amount
      expect(find.text('110000'), findsOneWidget);
    });

    testWidgets('should display product list with headers',
        (WidgetTester tester) async {
      final report = createMockReport(MockData.baseDate);
      whenListen(
        mockReportsBloc,
        Stream.fromIterable([ReportsLoaded(report)]),
        initialState: ReportsLoaded(report),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Product'), findsOneWidget);
      expect(find.text('Quantity'), findsOneWidget);
      expect(find.text('Price'), findsOneWidget);
      expect(find.text('Total'), findsOneWidget);
    });
  });
}

