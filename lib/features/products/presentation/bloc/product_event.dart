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
  final int price;
  final int stock;

  const CreateProduct({
    required this.name,
    required this.price,
    required this.stock,
  });

  @override
  List<Object?> get props => [name, price, stock];
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

class PopulateSampleData extends ProductEvent {
  const PopulateSampleData();
}

class RegisterSale extends ProductEvent {
  final int productId;
  final int quantity;

  const RegisterSale({required this.productId, required this.quantity});

  @override
  List<Object?> get props => [productId, quantity];
}

class LoadSavedSearch extends ProductEvent {
  const LoadSavedSearch();
}
