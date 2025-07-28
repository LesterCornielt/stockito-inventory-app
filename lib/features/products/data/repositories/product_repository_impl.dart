import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl(this.localDataSource);

  @override
  Future<List<Product>> getAllProducts() async {
    try {
      final productModels = await localDataSource.getAllProducts();
      return productModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw ProductFailure(message: 'Error al obtener productos: $e');
    }
  }

  @override
  Future<Product?> getProductById(int id) async {
    try {
      final productModel = await localDataSource.getProductById(id);
      return productModel?.toEntity();
    } catch (e) {
      throw ProductFailure(message: 'Error al obtener producto: $e');
    }
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    try {
      final productModels = await localDataSource.searchProducts(query);
      return productModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw ProductFailure(message: 'Error al buscar productos: $e');
    }
  }

  @override
  Future<Product> createProduct(Product product) async {
    try {
      final productModel = ProductModel.fromEntity(product);
      final newProductModel = await localDataSource.createProduct(productModel);
      return newProductModel.toEntity();
    } catch (e) {
      throw ProductFailure(message: 'Error al crear producto: $e');
    }
  }

  @override
  Future<bool> updateProduct(Product product) async {
    try {
      final productModel = ProductModel.fromEntity(product);
      return await localDataSource.updateProduct(productModel);
    } catch (e) {
      throw ProductFailure(message: 'Error al actualizar producto: $e');
    }
  }

  @override
  Future<bool> deleteProduct(int id) async {
    try {
      return await localDataSource.deleteProduct(id);
    } catch (e) {
      throw ProductFailure(message: 'Error al eliminar producto: $e');
    }
  }
}
