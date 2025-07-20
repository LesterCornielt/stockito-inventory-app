import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;
  static const int _version = 3; // Incrementar versión para forzar migración

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
        price REAL NOT NULL,
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
        price_per_unit REAL NOT NULL,
        total_amount REAL NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  static Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // Manejar migraciones aquí
    if (oldVersion < 2) {
      // Agregar tabla de ventas si no existe
      await db.execute('''
        CREATE TABLE IF NOT EXISTS sales(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          product_id INTEGER NOT NULL,
          product_name TEXT NOT NULL,
          quantity INTEGER NOT NULL,
          price_per_unit REAL NOT NULL,
          total_amount REAL NOT NULL,
          date TEXT NOT NULL
        )
      ''');
    }

    if (oldVersion < 3) {
      // Eliminar columnas description y barcode de la tabla products
      // Crear tabla temporal con el nuevo esquema
      await db.execute('''
        CREATE TABLE products_new(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          price REAL NOT NULL,
          stock INTEGER NOT NULL,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        )
      ''');

      // Copiar datos existentes (excluyendo description y barcode)
      await db.execute('''
        INSERT INTO products_new (id, name, price, stock, created_at, updated_at)
        SELECT id, name, price, stock, created_at, updated_at FROM products
      ''');

      // Eliminar tabla antigua y renombrar la nueva
      await db.execute('DROP TABLE products');
      await db.execute('ALTER TABLE products_new RENAME TO products');
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
