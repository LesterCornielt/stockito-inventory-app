import '../../domain/entities/sale.dart';
import '../../domain/repositories/sale_repository.dart';
import '../datasources/sale_local_datasource.dart';
import '../models/sale_model.dart';

class SaleRepositoryImpl implements SaleRepository {
  final SaleLocalDataSource localDataSource;

  SaleRepositoryImpl(this.localDataSource);

  @override
  Future<int> createSale(Sale sale) async {
    final saleModel = SaleModel.fromEntity(sale);
    return await localDataSource.createSale(saleModel);
  }

  @override
  Future<List<Sale>> getSalesOfDay(DateTime day) async {
    final sales = await localDataSource.getSalesOfDay(day);
    return sales.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<Sale>> getAllSales() async {
    final sales = await localDataSource.getAllSales();
    return sales.map((e) => e.toEntity()).toList();
  }

  @override
  Future<Sale?> getSaleById(int saleId) async {
    final sale = await localDataSource.getSaleById(saleId);
    return sale?.toEntity();
  }

  @override
  Future<void> updateSale(Sale sale) async {
    final saleModel = SaleModel.fromEntity(sale);
    await localDataSource.updateSale(saleModel);
  }

  @override
  Future<void> deleteSale(int saleId) async {
    await localDataSource.deleteSale(saleId);
  }
}
