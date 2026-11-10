import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/tarea.dart';

class DBTareas {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    final ruta = join(await getDatabasesPath(), 'tareas.db');
    _db = await openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tareas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            descripcion TEXT,
            completada INTEGER DEFAULT 0,
            actualizado_en INTEGER NOT NULL
          )
        ''');
      },
    );
    return _db!;
  }

  // ---------- CREATE ----------
  static Future<int> insertar(Tarea t) async {
    final db = await database;
    return db.insert('tareas', t.toMap());
  }

  // ---------- READ (con filtro) ----------
  /// [filtro] puede ser: 'todas' | 'pendientes' | 'completadas'
  static Future<List<Tarea>> listar({String filtro = 'todas'}) async {
    final db = await database;
    String? where;
    switch (filtro) {
      case 'pendientes':
        where = 'completada = 0';
        break;
      case 'completadas':
        where = 'completada = 1';
        break;
      default:
        where = null;
    }
    final rows = await db.query(
      'tareas',
      where: where,
      orderBy: 'completada ASC, actualizado_en DESC',
    );
    return rows.map(Tarea.fromMap).toList();
  }

  // ---------- UPDATE ----------
  static Future<int> actualizar(Tarea t) async {
    final db = await database;
    return db.update(
      'tareas',
      t.toMap(),
      where: 'id=?',
      whereArgs: [t.id],
    );
  }

  /// Marca/desmarca una tarea como completada
  static Future<int> marcarCompletada(int id, bool completada) async {
    final db = await database;
    return db.update(
      'tareas',
      {
        'completada': completada ? 1 : 0,
        'actualizado_en': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id=?',
      whereArgs: [id],
    );
  }

  // ---------- DELETE ----------
  static Future<int> eliminar(int id) async {
    final db = await database;
    return db.delete('tareas', where: 'id=?', whereArgs: [id]);
  }

  // ---------- STATS (opcional, para mostrar contadores) ----------
  static Future<Map<String, int>> estadisticas() async {
    final db = await database;
    final total = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM tareas')) ?? 0;
    final hechas = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM tareas WHERE completada = 1')) ?? 0;
    return {'total': total, 'completadas': hechas, 'pendientes': total - hechas};
  }
  static void resetForTests() {
    _db = null;
  }
}