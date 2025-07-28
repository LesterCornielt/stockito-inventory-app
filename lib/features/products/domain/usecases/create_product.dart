import '../entities/product.dart';
import '../repositories/product_repository.dart';
import 'get_all_products.dart';

class CreateProduct implements UseCase<Product, Product> {
  final ProductRepository repository;

  CreateProduct(this.repository);

  @override
  Future<Product> call(Product product) async {
    return await repository.createProduct(product);
  }
}
