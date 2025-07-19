import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/create_product.dart' as create_use_case;
import '../../domain/usecases/delete_product.dart' as delete_use_case;
import '../../domain/usecases/get_all_products.dart';
import '../../domain/usecases/search_products.dart' as search_use_case;
import '../../domain/usecases/update_product.dart' as update_use_case;
import '../../domain/usecases/populate_sample_data.dart' as populate_use_case;
import '../../domain/usecases/register_sale_from_stock_update.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetAllProducts getAllProducts;
  final create_use_case.CreateProduct createProduct;
  final update_use_case.UpdateProduct updateProduct;
  final delete_use_case.DeleteProduct deleteProduct;
  final search_use_case.SearchProducts searchProducts;
  final populate_use_case.PopulateSampleData populateSampleData;
  final RegisterSaleFromStockUpdate registerSaleFromStockUpdate;

  ProductBloc({
    required this.getAllProducts,
    required this.createProduct,
    required this.updateProduct,
    required this.deleteProduct,
    required this.searchProducts,
    required this.populateSampleData,
    required this.registerSaleFromStockUpdate,
  }) : super(const ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<SearchProducts>(_onSearchProducts);
    on<CreateProduct>(_onCreateProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
    on<ClearSearch>(_onClearSearch);
    on<PopulateSampleData>(_onPopulateSampleData);
    on<RegisterSale>(_onRegisterSale);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    try {
      final products = await getAllProducts(NoParams());
      if (products.isEmpty) {
        emit(const ProductsEmpty());
      } else {
        emit(ProductsLoaded(products: products));
      }
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<ProductState> emit,
  ) async {
    if (event.query.trim().isEmpty) {
      add(const LoadProducts());
      return;
    }

    try {
      final currentState = state;
      if (currentState is ProductsLoaded) {
        emit(
          ProductOperationLoading(
            products: currentState.products,
            operation: 'Buscando...',
          ),
        );
      } else {
        emit(const ProductLoading());
      }

      final products = await searchProducts(event.query);
      if (products.isEmpty) {
        emit(ProductsEmpty(searchQuery: event.query));
      } else {
        emit(ProductsLoaded(products: products, searchQuery: event.query));
      }
    } catch (e) {
      final currentState = state;
      if (currentState is ProductsLoaded) {
        emit(
          ProductError(message: e.toString(), products: currentState.products),
        );
      } else {
        emit(ProductError(message: e.toString()));
      }
    }
  }

  Future<void> _onCreateProduct(
    CreateProduct event,
    Emitter<ProductState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is ProductsLoaded) {
        emit(
          ProductOperationLoading(
            products: currentState.products,
            operation: 'Creando producto...',
          ),
        );
      }

      final now = DateTime.now();
      final product = Product(
        name: event.name,
        description: event.description,
        price: event.price,
        stock: event.stock,
        barcode: event.barcode,
        createdAt: now,
        updatedAt: now,
      );

      final productId = await createProduct(product);
      final createdProduct = product.copyWith(id: productId);

      // Recargar la lista de productos (sin ordenar)
      final products = await getAllProducts(NoParams());
      emit(ProductCreated(products: products, product: createdProduct));
    } catch (e) {
      final currentState = state;
      if (currentState is ProductsLoaded) {
        emit(
          ProductError(message: e.toString(), products: currentState.products),
        );
      } else {
        emit(ProductError(message: e.toString()));
      }
    }
  }

  Future<void> _onUpdateProduct(
    UpdateProduct event,
    Emitter<ProductState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is ProductsLoaded) {
        emit(
          ProductOperationLoading(
            products: currentState.products,
            operation: 'Actualizando producto...',
          ),
        );
      }

      final updatedProduct = event.product.copyWith(updatedAt: DateTime.now());

      final success = await updateProduct(updatedProduct);
      if (success) {
        // Recargar la lista de productos (sin ordenar)
        final products = await getAllProducts(NoParams());
        emit(ProductUpdated(products: products, product: updatedProduct));
      } else {
        throw Exception('No se pudo actualizar el producto');
      }
    } catch (e) {
      final currentState = state;
      if (currentState is ProductsLoaded) {
        emit(
          ProductError(message: e.toString(), products: currentState.products),
        );
      } else {
        emit(ProductError(message: e.toString()));
      }
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProduct event,
    Emitter<ProductState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is ProductsLoaded) {
        emit(
          ProductOperationLoading(
            products: currentState.products,
            operation: 'Eliminando producto...',
          ),
        );
      }

      final success = await deleteProduct(event.productId);
      if (success) {
        // Actualizar la lista removiendo el producto eliminado
        if (currentState is ProductsLoaded) {
          final updatedProducts = currentState.products
              .where((product) => product.id != event.productId)
              .toList();

          if (updatedProducts.isEmpty) {
            emit(const ProductsEmpty());
          } else {
            emit(
              ProductDeleted(
                products: updatedProducts,
                deletedProductId: event.productId,
              ),
            );
          }
        } else {
          // Si no hay estado actual, recargar desde la base de datos
          final products = await getAllProducts(NoParams());
          if (products.isEmpty) {
            emit(const ProductsEmpty());
          } else {
            emit(
              ProductDeleted(
                products: products,
                deletedProductId: event.productId,
              ),
            );
          }
        }
      } else {
        throw Exception('No se pudo eliminar el producto');
      }
    } catch (e) {
      final currentState = state;
      if (currentState is ProductsLoaded) {
        emit(
          ProductError(message: e.toString(), products: currentState.products),
        );
      } else {
        emit(ProductError(message: e.toString()));
      }
    }
  }

  Future<void> _onClearSearch(
    ClearSearch event,
    Emitter<ProductState> emit,
  ) async {
    add(const LoadProducts());
  }

  Future<void> _onPopulateSampleData(
    PopulateSampleData event,
    Emitter<ProductState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is ProductsLoaded) {
        emit(
          ProductOperationLoading(
            products: currentState.products,
            operation: 'Poblando datos de muestra...',
          ),
        );
      } else {
        emit(const ProductLoading());
      }

      await populateSampleData();

      // Recargar la lista de productos
      final products = await getAllProducts(NoParams());
      emit(ProductsLoaded(products: products));
    } catch (e) {
      final currentState = state;
      if (currentState is ProductsLoaded) {
        emit(
          ProductError(message: e.toString(), products: currentState.products),
        );
      } else {
        emit(ProductError(message: e.toString()));
      }
    }
  }

  Future<void> _onRegisterSale(
    RegisterSale event,
    Emitter<ProductState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is ProductsLoaded) {
        emit(
          ProductOperationLoading(
            products: currentState.products,
            operation: 'Registrando venta...',
          ),
        );
      }

      await registerSaleFromStockUpdate(event.productId, event.quantity);

      // Recargar la lista de productos
      final products = await getAllProducts(NoParams());
      emit(ProductsLoaded(products: products));
    } catch (e) {
      final currentState = state;
      if (currentState is ProductsLoaded) {
        emit(
          ProductError(message: e.toString(), products: currentState.products),
        );
      } else {
        emit(ProductError(message: e.toString()));
      }
    }
  }
}
