import '../entities/product.dart';
import '../repositories/product_repository.dart';
import 'get_all_products.dart';

class CreateProduct implements UseCase<int, Product> {
  final ProductRepository repository;

  CreateProduct(this.repository);

  @override
  Future<int> call(Product product) async {
    return await repository.createProduct(product);
  }
}
