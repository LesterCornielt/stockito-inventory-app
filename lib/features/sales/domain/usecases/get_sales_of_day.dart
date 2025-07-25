import '../entities/sale.dart';
import '../repositories/sale_repository.dart';

class GetSalesOfDay {
  final SaleRepository repository;

  GetSalesOfDay(this.repository);

  Future<List<Sale>> call(DateTime day) async {
    return await repository.getSalesOfDay(day);
  }
}
