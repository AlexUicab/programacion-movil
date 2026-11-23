import 'sensor_data.dart';

class Evidencia {
  final String rutaFoto;
  final DateTime fechaHora;
  final SensorData acelerometro;
  final SensorData giroscopio;
  final String? nota;

  Evidencia({
    required this.rutaFoto,
    required this.fechaHora,
    required this.acelerometro,
    required this.giroscopio,
    this.nota,
  });

  String get fechaFormateada {
    String dos(int n) => n.toString().padLeft(2, '0');
    return '${dos(fechaHora.day)}/${dos(fechaHora.month)}/${fechaHora.year} '
        '${dos(fechaHora.hour)}:${dos(fechaHora.minute)}:${dos(fechaHora.second)}';
  }
}