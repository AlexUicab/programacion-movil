import 'package:flutter_test/flutter_test.dart';
import 'package:practica_07_arquitectura/providers/contador_provider.dart';

void main() {
  group('ContadorProvider', () {
    test('inicia en 0', () {
      final p = ContadorProvider();
      expect(p.valor, 0);
    });

    test('incrementar aumenta el valor', () {
      final p = ContadorProvider();
      p.incrementar();
      p.incrementar();
      expect(p.valor, 2);
    });

    test('reiniciar vuelve a 0', () {
      final p = ContadorProvider();
      p.incrementar();
      p.reiniciar();
      expect(p.valor, 0);
    });

    test('notifica a los listeners al incrementar', () {
      final p = ContadorProvider();
      var notificaciones = 0;
      p.addListener(() => notificaciones++);

      p.incrementar();
      p.incrementar();

      expect(notificaciones, 2);
    });
  });
}