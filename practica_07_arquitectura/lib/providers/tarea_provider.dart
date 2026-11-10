import 'package:flutter/foundation.dart';
import '../models/tarea.dart';
import '../services/tarea_service.dart';

class TareaProvider extends ChangeNotifier {
  final TareaService _service = TareaService();

  List<Tarea> _tareas = [];
  bool _cargando = false;
  String? _error;

  List<Tarea> get tareas => _tareas;
  bool get cargando => _cargando;
  String? get error => _error;

  Future<void> cargar() async {
    _cargando = true;
    _error = null;
    notifyListeners();
    try {
      _tareas = await _service.obtenerTareas();
    } catch (e) {
      _error = e.toString();
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  void alternar(int id) {
    _tareas = [
      for (final t in _tareas)
        t.id == id ? t.copyWith(completada: !t.completada) : t,
    ];
    notifyListeners();
  }

  String formatear(DateTime fecha) => _service.formatearFecha(fecha);
}