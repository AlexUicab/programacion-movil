import 'package:flutter_test/flutter_test.dart';
import 'package:practica_07_arquitectura_ej/models/usuario.dart';
import 'package:practica_07_arquitectura_ej/providers/usuario_provider.dart';
import 'package:practica_07_arquitectura_ej/services/usuario_service.dart';

class _FakeService extends UsuarioService {
  @override
  Future<List<Usuario>> obtenerUsuarios() async => const [
        Usuario(id: 1, nombre: 'Ana', correo: 'ana@x.com'),
        Usuario(id: 2, nombre: 'Luis', correo: 'luis@x.com'),
      ];
}

class _FakeErrorService extends UsuarioService {
  @override
  Future<List<Usuario>> obtenerUsuarios() async =>
      throw Exception('HTTP 500');
}

void main() {
  test('cargar() llena la lista y marca fecha', () async {
    final p = UsuarioProvider(service: _FakeService());
    expect(p.usuarios, isEmpty);

    await p.cargar();
    expect(p.usuarios.length, 2);
    expect(p.ultimaActualizacion, isNotNull);
    expect(p.error, isNull);
  });

  test('captura error y lo expone', () async {
    final p = UsuarioProvider(service: _FakeErrorService());
    await p.cargar();
    expect(p.error, contains('HTTP 500'));
    expect(p.usuarios, isEmpty);
  });
}