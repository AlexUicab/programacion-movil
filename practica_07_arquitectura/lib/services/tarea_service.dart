import 'package:intl/intl.dart';
import '../models/tarea.dart';

class TareaService {
  /// Simula una fuente de datos (API/local). Se ejecuta FUERA de build().
  Future<List<Tarea>> obtenerTareas() async {
    await Future.delayed(const Duration(milliseconds: 400));
    final ahora = DateTime.now();
    return List.generate(
      200,
      (i) => Tarea(
        id: i,
        titulo: 'Tarea #${i + 1}',
        fecha: ahora.subtract(Duration(days: i)),
      ),
    );
  }

  String formatearFecha(DateTime fecha) =>
      DateFormat('dd/MM/yyyy').format(fecha);
}