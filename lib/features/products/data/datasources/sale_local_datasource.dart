import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/sale_model.dart';

abstract class SaleLocalDataSource {
  Future<int> createSale(SaleModel sale);
  Future<List<SaleModel>> getSalesOfDay(DateTime day);
  Future<List<SaleModel>> getAllSales();
}

class SaleLocalDataSourceImpl implements SaleLocalDataSource {
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

  @override
  Future<int> createSale(SaleModel sale) async {
    final db = await database;
    return await db.insert('sales', sale.toMap());
  }

  @override
  Future<List<SaleModel>> getSalesOfDay(DateTime day) async {
    final db = await database;
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    final List<Map<String, dynamic>> maps = await db.query(
      'sales',
      where: 'date >= ? AND date < ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'date ASC',
    );
    return List.generate(maps.length, (i) => SaleModel.fromMap(maps[i]));
  }

  @override
  Future<List<SaleModel>> getAllSales() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'sales',
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => SaleModel.fromMap(maps[i]));
  }
}
