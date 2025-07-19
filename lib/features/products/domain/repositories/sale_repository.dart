import '../entities/sale.dart';

abstract class SaleRepository {
  Future<int> createSale(Sale sale);
  Future<List<Sale>> getSalesOfDay(DateTime day);
  Future<List<Sale>> getAllSales();
}
