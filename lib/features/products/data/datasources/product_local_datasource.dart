import 'package:sqflite/sqflite.dart';
import '../models/product_model.dart';
import '../../../../core/utils/sample_data_generator.dart';
import '../../../../core/database/database_service.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel?> getProductById(int id);
  Future<List<ProductModel>> searchProducts(String query);
  Future<int> createProduct(ProductModel product);
  Future<bool> updateProduct(ProductModel product);
  Future<bool> deleteProduct(int id);
  Future<void> populateWithSampleData();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  Future<Database> get database async {
    return await DatabaseService.database;
  }

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
      where: 'name LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) {
      return ProductModel.fromMap(maps[i]);
    });
  }

  @override
  Future<int> createProduct(ProductModel product) async {
    final db = await database;
    return await db.insert('products', product.toMap());
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

  @override
  Future<void> populateWithSampleData() async {
    final db = await database;

    // Check if database is already populated
    final existingProducts = await db.query('products');
    if (existingProducts.isNotEmpty) {
      return; // Database already has data
    }

    // Get sample products
    final sampleProducts = SampleDataGenerator.getSampleProducts();

    // Insert all sample products
    for (final product in sampleProducts) {
      await db.insert('products', product.toMap());
    }
  }
}
