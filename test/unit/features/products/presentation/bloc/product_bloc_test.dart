import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockito/features/products/domain/entities/product.dart';
import 'package:stockito/features/products/domain/repositories/product_repository.dart';
import 'package:stockito/features/products/domain/usecases/create_product.dart' as create_use_case;
import 'package:stockito/features/products/domain/usecases/delete_product.dart' as delete_use_case;
import 'package:stockito/features/products/domain/usecases/get_all_products.dart';
import 'package:stockito/features/products/domain/usecases/search_products.dart' as search_use_case;
import 'package:stockito/features/products/domain/usecases/update_product.dart' as update_use_case;
import 'package:stockito/features/products/presentation/bloc/product_bloc.dart';
import 'package:stockito/features/products/presentation/bloc/product_event.dart';
import 'package:stockito/features/products/presentation/bloc/product_state.dart';
import 'package:stockito/features/sales/domain/entities/sale.dart';
import 'package:stockito/features/sales/domain/repositories/sale_repository.dart';
import 'package:stockito/features/sales/domain/usecases/register_sale_from_stock_update.dart';
import '../../../../../helpers/mock_data.dart';

class MockProductRepository implements ProductRepository {
  @override
  Future<List<Product>> getAllProducts() async => [];
  @override
  Future<Product?> getProductById(int id) async => null;
  @override
  Future<List<Product>> searchProducts(String query) async => [];
  @override
  Future<Product> createProduct(Product product) async => product;
  @override
  Future<bool> updateProduct(Product product) async => true;
  @override
  Future<bool> deleteProduct(int id) async => true;
}

class MockGetAllProducts extends GetAllProducts {
  MockGetAllProducts() : super(MockProductRepository());

  List<Product>? productsToReturn;
  Exception? exceptionToThrow;

  @override
  Future<List<Product>> call(NoParams params) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return productsToReturn ?? [];
  }
}

class MockCreateProduct extends create_use_case.CreateProduct {
  MockCreateProduct() : super(MockProductRepository());

  Product? productToReturn;
  Exception? exceptionToThrow;

  @override
  Future<Product> call(Product product) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return productToReturn ?? product.copyWith(id: 1);
  }
}

class MockUpdateProduct extends update_use_case.UpdateProduct {
  MockUpdateProduct() : super(MockProductRepository());

  bool? resultToReturn;
  Exception? exceptionToThrow;

  @override
  Future<bool> call(Product product) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return resultToReturn ?? true;
  }
}

class MockDeleteProduct extends delete_use_case.DeleteProduct {
  MockDeleteProduct() : super(MockProductRepository());

  bool? resultToReturn;
  Exception? exceptionToThrow;

  @override
  Future<bool> call(int productId) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return resultToReturn ?? true;
  }
}

class MockSearchProducts extends search_use_case.SearchProducts {
  MockSearchProducts() : super(MockProductRepository());

  List<Product>? productsToReturn;
  Exception? exceptionToThrow;

  @override
  Future<List<Product>> call(String query) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return productsToReturn ?? [];
  }
}

class MockRegisterSaleFromStockUpdate extends RegisterSaleFromStockUpdate {
  MockRegisterSaleFromStockUpdate()
      : super(
          productRepository: MockProductRepository(),
          saleRepository: MockSaleRepositoryForBloc(),
        );

  Exception? exceptionToThrow;

  @override
  Future<void> call(int productId, int quantitySold) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
  }
}

class MockSaleRepositoryForBloc implements SaleRepository {
  @override
  Future<int> createSale(Sale sale) async => 1;
  @override
  Future<List<Sale>> getSalesOfDay(DateTime day) async => [];
  @override
  Future<List<Sale>> getAllSales() async => [];
  @override
  Future<Sale?> getSaleById(int saleId) async => null;
  @override
  Future<void> updateSale(Sale sale) async {}
  @override
  Future<void> deleteSale(int saleId) async {}
}

void main() {
  late ProductBloc bloc;
  late MockGetAllProducts mockGetAllProducts;
  late MockCreateProduct mockCreateProduct;
  late MockUpdateProduct mockUpdateProduct;
  late MockDeleteProduct mockDeleteProduct;
  late MockSearchProducts mockSearchProducts;
  late MockRegisterSaleFromStockUpdate mockRegisterSaleFromStockUpdate;

  setUp(() {
    mockGetAllProducts = MockGetAllProducts();
    mockCreateProduct = MockCreateProduct();
    mockUpdateProduct = MockUpdateProduct();
    mockDeleteProduct = MockDeleteProduct();
    mockSearchProducts = MockSearchProducts();
    mockRegisterSaleFromStockUpdate = MockRegisterSaleFromStockUpdate();

    bloc = ProductBloc(
      getAllProducts: mockGetAllProducts,
      createProduct: mockCreateProduct,
      updateProduct: mockUpdateProduct,
      deleteProduct: mockDeleteProduct,
      searchProducts: mockSearchProducts,
      registerSaleFromStockUpdate: mockRegisterSaleFromStockUpdate,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('ProductBloc', () {
    test('initial state should be ProductInitial', () {
      expect(bloc.state, equals(const ProductInitial()));
    });

    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductsLoaded] when LoadProducts is successful',
      build: () => bloc,
      act: (bloc) => bloc.add(const LoadProducts()),
      expect: () => [
        const ProductLoading(),
        ProductsLoaded(products: MockData.sampleProducts),
      ],
      setUp: () {
        mockGetAllProducts.productsToReturn = MockData.sampleProducts;
      },
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductsEmpty] when LoadProducts returns empty list',
      build: () => bloc,
      act: (bloc) => bloc.add(const LoadProducts()),
      expect: () => [
        const ProductLoading(),
        const ProductsEmpty(),
      ],
      setUp: () {
        mockGetAllProducts.productsToReturn = [];
      },
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductError] when LoadProducts fails',
      build: () => bloc,
      act: (bloc) => bloc.add(const LoadProducts()),
      expect: () => [
        const ProductLoading(),
        isA<ProductError>(),
      ],
      setUp: () {
        mockGetAllProducts.exceptionToThrow = Exception('Database error');
      },
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductsLoaded] when SearchProducts is successful',
      build: () => bloc,
      act: (bloc) => bloc.add(const SearchProducts('Test')),
      expect: () => [
        const ProductLoading(),
        ProductsLoaded(products: [MockData.sampleProduct1], searchQuery: 'Test'),
      ],
      setUp: () {
        mockSearchProducts.productsToReturn = [MockData.sampleProduct1];
      },
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductsEmpty] when SearchProducts returns empty',
      build: () => bloc,
      act: (bloc) => bloc.add(const SearchProducts('NonExistent')),
      expect: () => [
        const ProductLoading(),
        const ProductsEmpty(searchQuery: 'NonExistent'),
      ],
      setUp: () {
        mockSearchProducts.productsToReturn = [];
      },
    );

    blocTest<ProductBloc, ProductState>(
      'triggers LoadProducts when SearchProducts query is empty',
      build: () => bloc,
      act: (bloc) => bloc.add(const SearchProducts('   ')),
      expect: () => [
        const ProductLoading(),
        ProductsLoaded(products: MockData.sampleProducts),
      ],
      setUp: () {
        mockGetAllProducts.productsToReturn = MockData.sampleProducts;
      },
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductOperationLoading, ProductCreated] when CreateProduct is successful',
      build: () => bloc,
      seed: () => ProductsLoaded(products: MockData.sampleProducts),
      act: (bloc) => bloc.add(
        const CreateProduct(
          name: 'New Product',
          price: 15000,
          stock: 20,
        ),
      ),
      expect: () => [
        isA<ProductOperationLoading>(),
        isA<ProductCreated>(),
      ],
      setUp: () {
        final newProduct = MockData.createProduct(
          id: 4,
          name: 'New Product',
          price: 15000,
          stock: 20,
        );
        mockCreateProduct.productToReturn = newProduct;
      },
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductError] when CreateProduct fails',
      build: () => bloc,
      seed: () => ProductsLoaded(products: MockData.sampleProducts),
      act: (bloc) => bloc.add(
        const CreateProduct(
          name: 'New Product',
          price: 15000,
          stock: 20,
        ),
      ),
      expect: () => [
        isA<ProductOperationLoading>(),
        isA<ProductError>(),
      ],
      setUp: () {
        mockCreateProduct.exceptionToThrow = Exception('Creation failed');
      },
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductOperationLoading, ProductUpdated] when UpdateProduct is successful',
      build: () => bloc,
      seed: () => ProductsLoaded(products: MockData.sampleProducts),
      act: (bloc) => bloc.add(
        UpdateProduct(
          MockData.sampleProduct1.copyWith(name: 'Updated Name'),
        ),
      ),
      expect: () => [
        isA<ProductOperationLoading>(),
        isA<ProductUpdated>(),
      ],
      setUp: () {
        mockUpdateProduct.resultToReturn = true;
      },
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductOperationLoading, ProductDeleted] when DeleteProduct is successful',
      build: () => bloc,
      seed: () => ProductsLoaded(products: MockData.sampleProducts),
      act: (bloc) => bloc.add(DeleteProduct(1)),
      expect: () => [
        isA<ProductOperationLoading>(),
        isA<ProductDeleted>(),
      ],
      setUp: () {
        mockDeleteProduct.resultToReturn = true;
      },
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductOperationLoading, ProductsEmpty] when DeleteProduct leaves list empty',
      build: () => bloc,
      seed: () => ProductsLoaded(products: [MockData.sampleProduct1]),
      act: (bloc) => bloc.add(DeleteProduct(1)),
      expect: () => [
        isA<ProductOperationLoading>(),
        const ProductsEmpty(),
      ],
      setUp: () {
        mockDeleteProduct.resultToReturn = true;
        mockGetAllProducts.productsToReturn = [];
      },
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductsLoaded] when RegisterSale is successful',
      build: () => bloc,
      seed: () => ProductsLoaded(products: MockData.sampleProducts),
      act: (bloc) => bloc.add(
        const RegisterSale(productId: 1, quantitySold: 5),
      ),
      expect: () => [
        isA<ProductsLoaded>(),
      ],
      setUp: () {
        final updatedProducts = MockData.sampleProducts.map((p) {
          if (p.id == 1) {
            return p.copyWith(stock: p.stock - 5);
          }
          return p;
        }).toList();
        mockGetAllProducts.productsToReturn = updatedProducts;
      },
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductError] when RegisterSale fails',
      build: () => bloc,
      seed: () => ProductsLoaded(products: MockData.sampleProducts),
      act: (bloc) => bloc.add(
        const RegisterSale(productId: 1, quantitySold: 5),
      ),
      expect: () => [
        isA<ProductError>(),
      ],
      setUp: () {
        mockRegisterSaleFromStockUpdate.exceptionToThrow =
            Exception('Sale registration failed');
      },
    );

    // Note: LoadSavedSearch test requires mocking PersistenceService
    // which is a static class. This test is skipped for now.
    // In a real scenario, you would use a dependency injection approach
    // or a wrapper around PersistenceService to make it testable.

    blocTest<ProductBloc, ProductState>(
      'triggers LoadProducts when ClearSearch is called',
      build: () => bloc,
      act: (bloc) => bloc.add(const ClearSearch()),
      expect: () => [
        const ProductLoading(),
        ProductsLoaded(products: MockData.sampleProducts),
      ],
      setUp: () {
        mockGetAllProducts.productsToReturn = MockData.sampleProducts;
      },
    );
  });
}

