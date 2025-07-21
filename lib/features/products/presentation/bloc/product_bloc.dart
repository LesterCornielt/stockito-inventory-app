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
import '../../../../core/utils/persistence_service.dart';
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
    on<LoadSavedSearch>(_onLoadSavedSearch);
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

    // Guardar la búsqueda
    await PersistenceService.saveLastSearchQuery(event.query);

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

  Future<void> _onLoadSavedSearch(
    LoadSavedSearch event,
    Emitter<ProductState> emit,
  ) async {
    final savedQuery = await PersistenceService.getLastSearchQuery();
    if (savedQuery != null && savedQuery.isNotEmpty) {
      add(SearchProducts(savedQuery));
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
        price: event.price,
        stock: event.stock,
        createdAt: now,
        updatedAt: now,
      );

      final productId = await createProduct(product);
      final createdProduct = product.copyWith(id: productId);

      // Si hay un estado actual con productos, agregar el nuevo producto a la lista
      if (currentState is ProductsLoaded) {
        final updatedProducts = [...currentState.products, createdProduct];
        emit(
          ProductCreated(
            products: updatedProducts,
            product: createdProduct,
            searchQuery: currentState.searchQuery,
          ),
        );
      } else {
        // Si no hay estado actual, recargar desde la base de datos
        final products = await getAllProducts(NoParams());
        emit(ProductCreated(products: products, product: createdProduct));
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
        // Si hay un estado actual con productos, actualizar solo el producto específico
        if (currentState is ProductsLoaded) {
          final updatedProducts = currentState.products.map((product) {
            if (product.id == updatedProduct.id) {
              return updatedProduct;
            }
            return product;
          }).toList();

          // FIX: Si hay búsqueda activa, reaplicar búsqueda
          if (currentState.searchQuery != null &&
              currentState.searchQuery!.isNotEmpty) {
            add(SearchProducts(currentState.searchQuery!));
            return;
          }

          emit(
            ProductUpdated(
              products: updatedProducts,
              product: updatedProduct,
              searchQuery: currentState.searchQuery,
            ),
          );
        } else {
          // Si no hay estado actual, recargar desde la base de datos
          final products = await getAllProducts(NoParams());
          emit(ProductUpdated(products: products, product: updatedProduct));
        }
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
    // Limpiar la búsqueda guardada
    await PersistenceService.saveLastSearchQuery('');
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

      // Si hay un estado actual con productos, actualizar solo el producto específico
      if (currentState is ProductsLoaded) {
        // Obtener el producto actualizado desde la base de datos
        final updatedProduct = await getAllProducts(NoParams());
        final product = updatedProduct.firstWhere(
          (p) => p.id == event.productId,
          orElse: () =>
              currentState.products.firstWhere((p) => p.id == event.productId),
        );

        final updatedProducts = currentState.products.map((p) {
          if (p.id == event.productId) {
            return product;
          }
          return p;
        }).toList();

        emit(
          ProductsLoaded(
            products: updatedProducts,
            searchQuery: currentState.searchQuery,
          ),
        );
      } else {
        // Si no hay estado actual, recargar desde la base de datos
        final products = await getAllProducts(NoParams());
        emit(ProductsLoaded(products: products));
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
}
