import '../repositories/product_repository.dart';
import 'get_all_products.dart';

class DeleteProduct implements UseCase<bool, int> {
  final ProductRepository repository;

  DeleteProduct(this.repository);

  @override
  Future<bool> call(int productId) async {
    return await repository.deleteProduct(productId);
  }
}
