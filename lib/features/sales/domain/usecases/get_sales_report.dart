import '../entities/sale.dart';
import '../repositories/sale_repository.dart';
import '../../../products/domain/repositories/product_repository.dart';

class SalesReport {
  final String productName;
  final int totalQuantity;
  final int totalAmount;
  final int pricePerUnit;

  SalesReport({
    required this.productName,
    required this.totalQuantity,
    required this.totalAmount,
    required this.pricePerUnit,
  });
}

class IndividualSaleReport {
  final int saleId;
  final String productName;
  final int quantity;
  final int totalAmount;
  final int pricePerUnit;
  final DateTime date;

  IndividualSaleReport({
    required this.saleId,
    required this.productName,
    required this.quantity,
    required this.totalAmount,
    required this.pricePerUnit,
    required this.date,
  });
}

class DailySalesReport {
  final DateTime date;
  final List<SalesReport> productReports;
  final List<IndividualSaleReport> individualSales;
  final int totalDailyAmount;

  DailySalesReport({
    required this.date,
    required this.productReports,
    required this.individualSales,
    required this.totalDailyAmount,
  });
}

class GetSalesReport {
  final SaleRepository saleRepository;
  final ProductRepository productRepository;

  GetSalesReport(this.saleRepository, this.productRepository);

  Future<DailySalesReport> call(DateTime day) async {
    final sales = await saleRepository.getSalesOfDay(day);
    final products = await productRepository.getAllProducts();

    final Map<int, String> productIdToName = {
      for (final p in products) p.id!: p.name,
    };

    final Map<int, List<Sale>> salesByProductId = {};
    for (final sale in sales) {
      salesByProductId.putIfAbsent(sale.productId, () => []);
      salesByProductId[sale.productId]!.add(sale);
    }

    final List<SalesReport> productReports = [];
    final List<IndividualSaleReport> individualSales = [];
    int totalDailyAmount = 0;

    for (final entry in salesByProductId.entries) {
      final productSales = entry.value;
      final totalQuantity = productSales.fold<int>(
        0,
        (sum, sale) => sum + sale.quantity,
      );
      final totalAmount = productSales.fold<int>(
        0,
        (sum, sale) => sum + sale.totalAmount,
      );
      final pricePerUnit = productSales.first.pricePerUnit;
      final productName =
          productIdToName[entry.key] ?? productSales.first.productName;

      productReports.add(
        SalesReport(
          productName: productName,
          totalQuantity: totalQuantity,
          totalAmount: totalAmount,
          pricePerUnit: pricePerUnit,
        ),
      );

      totalDailyAmount += totalAmount;
    }

    for (final sale in sales) {
      final productName = productIdToName[sale.productId] ?? sale.productName;
      individualSales.add(
        IndividualSaleReport(
          saleId: sale.id!,
          productName: productName,
          quantity: sale.quantity,
          totalAmount: sale.totalAmount,
          pricePerUnit: sale.pricePerUnit,
          date: sale.date,
        ),
      );
    }

    return DailySalesReport(
      date: day,
      productReports: productReports,
      individualSales: individualSales,
      totalDailyAmount: totalDailyAmount,
    );
  }
}
