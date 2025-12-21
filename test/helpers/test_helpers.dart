import 'package:get_it/get_it.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

/// Configuración y helpers para tests
class TestHelpers {
  static bool _initialized = false;

  /// Inicializa sqflite_common_ffi para tests (solo una vez)
  static void initSqfliteFfi() {
    if (!_initialized) {
      sqfliteFfiInit();
      sqflite.databaseFactory = databaseFactoryFfi;
      _initialized = true;
    }
  }

  /// Inicializa una base de datos en memoria para tests
  static Future<sqflite.Database> initTestDatabase() async {
    // Inicializar sqflite_common_ffi para tests en desktop
    initSqfliteFfi();

    // Crear base de datos en memoria
    final db = await sqflite.openDatabase(
      ':memory:',
      version: 4,
      onCreate: (db, version) async {
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
      },
    );

    return db;
  }

  /// Limpia la base de datos de prueba
  static Future<void> clearTestDatabase(sqflite.Database db) async {
    await db.delete('products');
    await db.delete('sales');
  }

  /// Cierra y elimina la base de datos de prueba
  static Future<void> closeTestDatabase(sqflite.Database db) async {
    await db.close();
  }

  /// Resetea GetIt para tests
  static void resetGetIt() {
    if (GetIt.instance.isRegistered<sqflite.Database>()) {
      GetIt.instance.reset();
    }
  }

  /// Configura GetIt con una base de datos de prueba
  static Future<void> setupGetItWithTestDatabase(
    sqflite.Database testDb,
  ) async {
    resetGetIt();
    GetIt.instance.registerSingleton<sqflite.Database>(testDb);
  }
}
