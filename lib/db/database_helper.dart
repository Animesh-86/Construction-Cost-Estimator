import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'estimates.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE estimates(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            area REAL,
            cement REAL,
            steel REAL,
            labor REAL,
            locationIndex INTEGER,
            predictedCost REAL
          )
        ''');
      },
    );
  }

  Future<int> insertEstimate(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('estimates', data);
  }

  Future<List<Map<String, dynamic>>> getAllEstimates() async {
    final db = await database;
    return await db.query('estimates');
  }

  Future<int> deleteEstimate(int id) async {
    final db = await database;
    return await db.delete('estimates', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateEstimate(Map<String, dynamic> data) async {
    final db = await database;
    return await db.update(
      'estimates',
      data,
      where: 'id = ?',
      whereArgs: [data['id']],
    );
  }
}
