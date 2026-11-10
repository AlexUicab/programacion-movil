import 'package:flutter_test/flutter_test.dart';
import 'package:practica_07_arquitectura/providers/tarea_provider.dart';

void main() {
  group('TareaProvider', () {
    test('cargar() llena la lista y alterna estado de carga', () async {
      final p = TareaProvider();
      expect(p.tareas, isEmpty);

      final future = p.cargar();
      expect(p.cargando, isTrue);   // durante la carga

      await future;
      expect(p.cargando, isFalse);
      expect(p.tareas, isNotEmpty);
      expect(p.tareas.length, 200);
    });

    test('alternar() cambia el estado completada de una tarea', () async {
      final p = TareaProvider();
      await p.cargar();

      final primera = p.tareas.first;
      expect(primera.completada, isFalse);

      p.alternar(primera.id);
      expect(p.tareas.first.completada, isTrue);

      p.alternar(primera.id);
      expect(p.tareas.first.completada, isFalse);
    });

    test('formatear() devuelve dd/MM/yyyy', () {
      final p = TareaProvider();
      final texto = p.formatear(DateTime(2026, 3, 7));
      expect(texto, '07/03/2026');
    });
  });
}