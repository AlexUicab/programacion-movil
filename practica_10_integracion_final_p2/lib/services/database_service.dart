import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/incident.dart';

/// Persistencia local con SQLite: funciona sin conexión.
class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();

  static const _table = 'incidents';
  Database? _db;

  Future<Database> get _database async {
    if (_db != null) return _db!;
    final path = p.join(await getDatabasesPath(), 'incidencias.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, _) => db.execute('''
        CREATE TABLE $_table (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          description TEXT NOT NULL,
          category TEXT NOT NULL,
          photo_path TEXT NOT NULL,
          latitude REAL NOT NULL,
          longitude REAL NOT NULL,
          created_at TEXT NOT NULL,
          synced INTEGER NOT NULL DEFAULT 0
        )
      '''),
    );
    return _db!;
  }

  Future<int> insert(Incident incident) async {
    final db = await _database;
    return db.insert(_table, incident.toMap()..remove('id'));
  }

  Future<List<Incident>> getAll() async {
    final db = await _database;
    final rows = await db.query(_table, orderBy: 'created_at DESC');
    return rows.map(Incident.fromMap).toList();
  }

  Future<List<Incident>> getPending() async {
    final db = await _database;
    final rows = await db.query(_table, where: 'synced = 0');
    return rows.map(Incident.fromMap).toList();
  }

  Future<int> count() async {
    final db = await _database;
    final r = await db.rawQuery('SELECT COUNT(*) AS c FROM $_table');
    return Sqflite.firstIntValue(r) ?? 0;
  }

  Future<void> markSynced(int id) async {
    final db = await _database;
    await db.update(_table, {'synced': 1}, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> delete(int id) async {
    final db = await _database;
    await db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }
}
