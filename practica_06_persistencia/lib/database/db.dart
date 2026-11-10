import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    final ruta = join(await getDatabasesPath(), 'notas.db');
    _db = await openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) => db.execute(
        '''CREATE TABLE notas(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          titulo TEXT,
          contenido TEXT,
          pendiente_sincronizar INTEGER DEFAULT 1
        )''',
      ),
    );
    return _db!;
  }

  // INSERTAR: toda nota nueva nace como "pendiente de sincronizar"
  static Future<int> insertar(String titulo, String contenido) async {
    final db = await database;
    return db.insert('notas', {
      'titulo': titulo,
      'contenido': contenido,
      'pendiente_sincronizar': 1,
    });
  }

  static Future<List<Map<String, dynamic>>> listar() async {
    final db = await database;
    return db.query('notas', orderBy: 'id DESC');
  }

  // ACTUALIZAR: al editar, vuelve a marcarse como pendiente
  static Future<int> actualizar(int id, String titulo, String contenido) async {
    final db = await database;
    return db.update(
      'notas',
      {
        'titulo': titulo,
        'contenido': contenido,
        'pendiente_sincronizar': 1,
      },
      where: 'id=?',
      whereArgs: [id],
    );
  }

  static Future<int> eliminar(int id) async {
    final db = await database;
    return db.delete('notas', where: 'id=?', whereArgs: [id]);
  }

  // ---- Métodos auxiliares para la sincronización ----

  /// Devuelve solo las notas que aún no se han enviado al servidor
  static Future<List<Map<String, dynamic>>> pendientes() async {
    final db = await database;
    return db.query('notas', where: 'pendiente_sincronizar = 1');
  }

  /// Marca una nota como sincronizada (ya enviada)
  static Future<int> marcarSincronizada(int id) async {
    final db = await database;
    return db.update(
      'notas',
      {'pendiente_sincronizar': 0},
      where: 'id=?',
      whereArgs: [id],
    );
  }
  
  static void resetForTests() {
    _db = null;
  }
}