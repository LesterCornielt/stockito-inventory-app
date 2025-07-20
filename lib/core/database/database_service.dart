import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;
  static const int _version = 4; // Incrementar versión para forzar migración

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'stockito.db');
    return await openDatabase(
      path,
      version: _version,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Crear tabla de productos
    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price INTEGER NOT NULL,
        stock INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Crear tabla de ventas
    await db.execute('''
      CREATE TABLE sales(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL,
        product_name TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        price_per_unit INTEGER NOT NULL,
        total_amount INTEGER NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  static Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 4) {
      // Migrar la columna price de REAL a INTEGER
      await db.execute('''
        CREATE TABLE products_new(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          price INTEGER NOT NULL,
          stock INTEGER NOT NULL,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        )
      ''');

      // Copiar datos existentes, convirtiendo precios a enteros
      await db.execute('''
        INSERT INTO products_new (id, name, price, stock, created_at, updated_at)
        SELECT id, name, CAST(price AS INTEGER), stock, created_at, updated_at
        FROM products
      ''');

      // Eliminar tabla antigua y renombrar la nueva
      await db.execute('DROP TABLE products');
      await db.execute('ALTER TABLE products_new RENAME TO products');

      // Migrar la tabla de ventas
      await db.execute('''
        CREATE TABLE sales_new(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          product_id INTEGER NOT NULL,
          product_name TEXT NOT NULL,
          quantity INTEGER NOT NULL,
          price_per_unit INTEGER NOT NULL,
          total_amount INTEGER NOT NULL,
          date TEXT NOT NULL
        )
      ''');

      // Copiar datos existentes, convirtiendo precios a enteros
      await db.execute('''
        INSERT INTO sales_new (id, product_id, product_name, quantity, price_per_unit, total_amount, date)
        SELECT id, product_id, product_name, quantity, CAST(price_per_unit AS INTEGER), CAST(total_amount AS INTEGER), date
        FROM sales
      ''');

      // Eliminar tabla antigua y renombrar la nueva
      await db.execute('DROP TABLE sales');
      await db.execute('ALTER TABLE sales_new RENAME TO sales');
    }
  }

  static Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  static Future<void> deleteDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
    String path = join(await getDatabasesPath(), 'stockito.db');
    await databaseFactory.deleteDatabase(path);
  }
}
