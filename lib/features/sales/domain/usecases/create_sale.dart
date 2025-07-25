import '../entities/sale.dart';
import '../repositories/sale_repository.dart';

class CreateSale {
  final SaleRepository repository;

  CreateSale(this.repository);

  Future<int> call(Sale sale) async {
    return await repository.createSale(sale);
  }
}
