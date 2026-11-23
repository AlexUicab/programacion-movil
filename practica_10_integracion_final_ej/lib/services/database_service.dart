import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/destination.dart';

/// Persistencia local con SQLite (funciona sin conexión).
class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();

  static const _table = 'destinations';
  Database? _db;

  Future<Database> get _database async {
    if (_db != null) return _db!;
    final path = p.join(await getDatabasesPath(), 'destinos.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, _) => db.execute('''
        CREATE TABLE $_table (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          notes TEXT NOT NULL,
          category TEXT NOT NULL,
          budget REAL NOT NULL,
          visit_date TEXT NOT NULL,
          latitude REAL NOT NULL,
          longitude REAL NOT NULL,
          visited INTEGER NOT NULL DEFAULT 0
        )
      '''),
    );
    return _db!;
  }

  Future<int> insert(Destination d) async {
    final db = await _database;
    return db.insert(_table, d.toMap()..remove('id'));
  }

  Future<List<Destination>> getAll() async {
    final db = await _database;
    final rows = await db.query(_table, orderBy: 'visit_date ASC');
    return rows.map(Destination.fromMap).toList();
  }

  Future<void> setVisited(int id, bool visited) async {
    final db = await _database;
    await db.update(_table, {'visited': visited ? 1 : 0},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<void> delete(int id) async {
    final db = await _database;
    await db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }
}
