import 'package:sqflite/sqflite.dart';
import '../models/sale_model.dart';
import '../../../../core/database/database_service.dart';

abstract class SaleLocalDataSource {
  Future<int> createSale(SaleModel sale);
  Future<List<SaleModel>> getSalesOfDay(DateTime day);
  Future<List<SaleModel>> getAllSales();
  Future<SaleModel?> getSaleById(int saleId);
  Future<void> updateSale(SaleModel sale);
  Future<void> deleteSale(int saleId);
}

class SaleLocalDataSourceImpl implements SaleLocalDataSource {
  Future<Database> get database async {
    return await DatabaseService.database;
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

  @override
  Future<SaleModel?> getSaleById(int saleId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'sales',
      where: 'id = ?',
      whereArgs: [saleId],
    );
    if (maps.isEmpty) return null;
    return SaleModel.fromMap(maps.first);
  }

  @override
  Future<void> updateSale(SaleModel sale) async {
    final db = await database;
    await db.update(
      'sales',
      sale.toMap(),
      where: 'id = ?',
      whereArgs: [sale.id],
    );
  }

  @override
  Future<void> deleteSale(int saleId) async {
    final db = await database;
    await db.delete('sales', where: 'id = ?', whereArgs: [saleId]);
  }
}
