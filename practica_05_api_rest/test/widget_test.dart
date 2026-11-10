import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica_05_api_rest/main.dart'; // Asegúrate de que este sea el nombre de tu paquete en pubspec.yaml

void main() {
  // TEST 1: Probar que el modelo convierte bien el JSON
  test('El modelo Usuario debe convertir el JSON correctamente', () {
    final jsonPrueba = {
      'id': 1,
      'name': 'Juan Pérez',
      'email': 'juan@correo.com',
    };

    final usuario = Usuario.fromJson(jsonPrueba);

    expect(usuario.id, 1);
    expect(usuario.nombre, 'Juan Pérez');
    expect(usuario.correo, 'juan@correo.com');
  });

  // TEST 2: Probar que la interfaz gráfica se dibuja correctamente
  testWidgets('La pantalla de usuarios debe mostrar el título y el indicador de carga', (WidgetTester tester) async {
    // 1. Construimos la app
    await tester.pumpWidget(const MaterialApp(home: UsuariosPage()));

    // 2. Verificamos que el AppBar tenga el texto correcto
    expect(find.text('Usuarios REST'), findsOneWidget);

    // 3. Verificamos que aparezca el indicador de carga (ya que la petición HTTP tarda un momento)
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}