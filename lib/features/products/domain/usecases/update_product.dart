import '../entities/product.dart';
import '../repositories/product_repository.dart';
import 'get_all_products.dart';

class UpdateProduct implements UseCase<bool, Product> {
  final ProductRepository repository;

  UpdateProduct(this.repository);

  @override
  Future<bool> call(Product product) async {
    return await repository.updateProduct(product);
  }
}
