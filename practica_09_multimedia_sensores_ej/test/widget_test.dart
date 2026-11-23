import 'package:flutter_test/flutter_test.dart';
import 'package:practica_09_multimedia_sensores_ej/models/evidencia.dart';
import 'package:practica_09_multimedia_sensores_ej/models/sensor_data.dart';

void main() {
  group('Evidencia', () {
    test('formatea fecha y hora con ceros a la izquierda', () {
      final ev = Evidencia(
        rutaFoto: '/tmp/foto.jpg',
        fechaHora: DateTime(2026, 3, 7, 9, 5, 3),
        acelerometro: const SensorData(x: 1, y: 2, z: 3),
        giroscopio: const SensorData(),
      );

      expect(ev.fechaFormateada, '07/03/2026 09:05:03');
    });

    test('conserva los valores de sensores recibidos', () {
      final accel = const SensorData(x: 0.5, y: -0.25, z: 9.81);
      final giro = const SensorData(x: 0.01, y: 0.02, z: 0.03);

      final ev = Evidencia(
        rutaFoto: '/tmp/a.jpg',
        fechaHora: DateTime.now(),
        acelerometro: accel,
        giroscopio: giro,
      );

      expect(ev.acelerometro.x, 0.5);
      expect(ev.giroscopio.z, 0.03);
    });
  });
}