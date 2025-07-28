import 'package:sqflite/sqflite.dart';
import '../models/product_model.dart';
import '../../../../core/database/database_service.dart';
import '../../domain/entities/product.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel?> getProductById(int id);
  Future<List<ProductModel>> searchProducts(String query);
  Future<ProductModel> createProduct(ProductModel product);
  Future<bool> updateProduct(ProductModel product);
  Future<bool> deleteProduct(int id);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final Future<Database> database = DatabaseService.database;

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      orderBy: 'id ASC',
    );
    return List.generate(maps.length, (i) {
      return ProductModel.fromMap(maps[i]);
    });
  }

  @override
  Future<ProductModel?> getProductById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return ProductModel.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
    );
    return List.generate(maps.length, (i) {
      return ProductModel.fromMap(maps[i]);
    });
  }

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    final db = await database;
    final id = await db.insert('products', product.toMap());
    return ProductModel.fromEntity(product.copyWith(id: id));
  }

  @override
  Future<bool> updateProduct(ProductModel product) async {
    final db = await database;
    final count = await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
    return count > 0;
  }

  @override
  Future<bool> deleteProduct(int id) async {
    final db = await database;
    final count = await db.delete('products', where: 'id = ?', whereArgs: [id]);
    return count > 0;
  }
}
