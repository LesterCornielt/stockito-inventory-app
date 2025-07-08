import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {
  const LoadProducts();
}

class SearchProducts extends ProductEvent {
  final String query;

  const SearchProducts(this.query);

  @override
  List<Object?> get props => [query];
}

class CreateProduct extends ProductEvent {
  final String name;
  final String description;
  final double price;
  final int stock;
  final String? barcode;

  const CreateProduct({
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    this.barcode,
  });

  @override
  List<Object?> get props => [name, description, price, stock, barcode];
}

class UpdateProduct extends ProductEvent {
  final Product product;

  const UpdateProduct(this.product);

  @override
  List<Object?> get props => [product];
}

class DeleteProduct extends ProductEvent {
  final int productId;

  const DeleteProduct(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ClearSearch extends ProductEvent {
  const ClearSearch();
}
