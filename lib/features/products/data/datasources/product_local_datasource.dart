import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product_model.dart';
import '../../../../core/utils/sample_data_generator.dart';

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
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'stockito.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        price REAL NOT NULL,
        stock INTEGER NOT NULL,
        barcode TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');
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
