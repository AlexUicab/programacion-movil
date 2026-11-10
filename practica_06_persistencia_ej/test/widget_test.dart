import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// IMPORTANTE: Usamos el nombre del proyecto de tu captura
import 'package:practica_06_persistencia_ej/database/db_tareas.dart';
import 'package:practica_06_persistencia_ej/models/tarea.dart';

void main() {
  // 1. Inicializar SQLite para que funcione en la PC
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  // 2. El test simple
  test('Smoke: la app crea, marca y elimina una tarea', () async {
    // Inicializar entorno de Flutter y Preferencias
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});

    // --- PRUEBA ---
    
    // A. Crear la tarea
    final id = await DBTareas.insertar(Tarea(
      titulo: 'Tarea de prueba',
      descripcion: '',
      actualizadoEn: DateTime.now().millisecondsSinceEpoch,
    ));
    expect(id, greaterThan(0), reason: 'El ID debe ser mayor a 0');

    // B. Marcar como completada
    await DBTareas.marcarCompletada(id, true);
    final tareaGuardada = (await DBTareas.listar()).first;
    expect(tareaGuardada.completada, true, reason: 'La tarea debe estar completada');

    // C. Eliminar la tarea
    await DBTareas.eliminar(id);
    final tareasFinales = await DBTareas.listar();
    expect(tareasFinales.isEmpty, true, reason: 'La lista debe estar vacía tras eliminar');
  });
}