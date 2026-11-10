// test/widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:practica_05_api_rest_ej/main.dart';

void main() {
  testWidgets(
    'La app monta y muestra el AppBar con el título "Publicaciones"',
    (WidgetTester tester) async {
      // Se construye la app.
      await tester.pumpWidget(const MyApp());

      // Debe existir un AppBar con el título esperado.
      expect(find.text('Publicaciones'), findsOneWidget);

      // En el primer frame, antes de que la petición termine,
      // debe mostrarse el indicador de carga.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Se deja que el test termine sin esperar a la petición HTTP real.
      // (No se hace pumpAndSettle porque la petición nunca resolverá
      //  en el entorno de pruebas sin mocking).
    },
  );
}