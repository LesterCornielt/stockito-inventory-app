import '../entities/sale.dart';
import '../repositories/sale_repository.dart';

class SalesReport {
  final String productName;
  final int totalQuantity;
  final double totalAmount;
  final double pricePerUnit;

  SalesReport({
    required this.productName,
    required this.totalQuantity,
    required this.totalAmount,
    required this.pricePerUnit,
  });
}

class DailySalesReport {
  final DateTime date;
  final List<SalesReport> productReports;
  final double totalDailyAmount;

  DailySalesReport({
    required this.date,
    required this.productReports,
    required this.totalDailyAmount,
  });
}

class GetSalesReport {
  final SaleRepository repository;

  GetSalesReport(this.repository);

  Future<DailySalesReport> call(DateTime day) async {
    final sales = await repository.getSalesOfDay(day);

    // Agrupar ventas por producto
    final Map<String, List<Sale>> salesByProduct = {};
    for (final sale in sales) {
      if (!salesByProduct.containsKey(sale.productName)) {
        salesByProduct[sale.productName] = [];
      }
      salesByProduct[sale.productName]!.add(sale);
    }

    // Crear reportes por producto
    final List<SalesReport> productReports = [];
    double totalDailyAmount = 0;

    for (final entry in salesByProduct.entries) {
      final productSales = entry.value;
      final totalQuantity = productSales.fold<int>(
        0,
        (sum, sale) => sum + sale.quantity,
      );
      final totalAmount = productSales.fold<double>(
        0,
        (sum, sale) => sum + sale.totalAmount,
      );
      final pricePerUnit =
          productSales.first.pricePerUnit; // Asumiendo precio constante

      productReports.add(
        SalesReport(
          productName: entry.key,
          totalQuantity: totalQuantity,
          totalAmount: totalAmount,
          pricePerUnit: pricePerUnit,
        ),
      );

      totalDailyAmount += totalAmount;
    }

    return DailySalesReport(
      date: day,
      productReports: productReports,
      totalDailyAmount: totalDailyAmount,
    );
  }
}
