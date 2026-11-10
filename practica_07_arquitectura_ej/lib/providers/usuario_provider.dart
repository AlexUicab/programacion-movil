import 'package:flutter/foundation.dart';
import '../models/usuario.dart';
import '../services/usuario_service.dart';

class UsuarioProvider extends ChangeNotifier {
  final UsuarioService _service;

  UsuarioProvider({UsuarioService? service})
      : _service = service ?? UsuarioService();

  List<Usuario> _usuarios = [];
  bool _cargando = false;
  String? _error;
  DateTime? _ultimaActualizacion;

  List<Usuario> get usuarios => _usuarios;
  bool get cargando => _cargando;
  String? get error => _error;
  DateTime? get ultimaActualizacion => _ultimaActualizacion;

  /// Inyección del servicio en constructor → testeable sin tocar la red.
  Future<void> cargar() async {
    _cargando = true;
    _error = null;
    notifyListeners();
    try {
      _usuarios = await _service.obtenerUsuarios();
      _ultimaActualizacion = DateTime.now();
    } catch (e) {
      _error = 'No se pudo cargar la lista: $e';
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }
}