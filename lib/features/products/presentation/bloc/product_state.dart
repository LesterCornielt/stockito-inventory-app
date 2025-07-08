import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductLoading extends ProductState {
  const ProductLoading();
}

class ProductsLoaded extends ProductState {
  final List<Product> products;
  final String? searchQuery;

  const ProductsLoaded({required this.products, this.searchQuery});

  @override
  List<Object?> get props => [products, searchQuery];

  ProductsLoaded copyWith({List<Product>? products, String? searchQuery}) {
    return ProductsLoaded(
      products: products ?? this.products,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class ProductOperationLoading extends ProductState {
  final List<Product> products;
  final String operation;

  const ProductOperationLoading({
    required this.products,
    required this.operation,
  });

  @override
  List<Object?> get props => [products, operation];
}

class ProductCreated extends ProductState {
  final List<Product> products;
  final Product product;

  const ProductCreated({required this.products, required this.product});

  @override
  List<Object?> get props => [products, product];
}

class ProductUpdated extends ProductState {
  final List<Product> products;
  final Product product;

  const ProductUpdated({required this.products, required this.product});

  @override
  List<Object?> get props => [products, product];
}

class ProductDeleted extends ProductState {
  final List<Product> products;
  final int deletedProductId;

  const ProductDeleted({
    required this.products,
    required this.deletedProductId,
  });

  @override
  List<Object?> get props => [products, deletedProductId];
}

class ProductError extends ProductState {
  final String message;
  final List<Product>? products;

  const ProductError({required this.message, this.products});

  @override
  List<Object?> get props => [message, products];
}

class ProductsEmpty extends ProductState {
  final String? searchQuery;

  const ProductsEmpty({this.searchQuery});

  @override
  List<Object?> get props => [searchQuery];
}
