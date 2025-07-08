import 'package:equatable/equatable.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';
import 'get_all_products.dart';

class SearchProducts implements UseCase<List<Product>, String> {
  final ProductRepository repository;

  SearchProducts(this.repository);

  @override
  Future<List<Product>> call(String query) async {
    return await repository.searchProducts(query);
  }
}
