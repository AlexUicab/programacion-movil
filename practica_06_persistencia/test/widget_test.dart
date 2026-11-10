import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';


import 'package:practica_06_persistencia/database/db.dart';

void main() {
  // 1. Inicializar SQLite para que funcione en la PC durante el test
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  // 2. El test simple
  test('Smoke: la app guarda, lee y elimina una nota', () async {
    // Inicializar entorno de Flutter y Preferencias
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});

    // --- PRUEBA ---
    
    // A. Guardar
    final id = await DB.insertar('Nota de prueba', 'contenido');
    expect(id, greaterThan(0), reason: 'El ID debe ser mayor a 0');

    // B. Leer
    final notas = await DB.listar();
    expect(notas.isNotEmpty, true, reason: 'La lista no debe estar vacía');
    
    // C. Eliminar
    await DB.eliminar(id);
    final notasFinales = await DB.listar();
    expect(notasFinales.isEmpty, true, reason: 'La lista debe estar vacía tras eliminar');
  });
}