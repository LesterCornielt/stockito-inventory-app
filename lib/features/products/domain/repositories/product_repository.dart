import 'package:equatable/equatable.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getAllProducts();
  Future<Product?> getProductById(int id);
  Future<List<Product>> searchProducts(String query);
  Future<int> createProduct(Product product);
  Future<bool> updateProduct(Product product);
  Future<bool> deleteProduct(int id);
}

class ProductFailure extends Equatable {
  final String message;
  final String? code;

  const ProductFailure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}
