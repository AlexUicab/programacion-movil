import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica_09_multimedia_sensores/main.dart';

void main() {
  testWidgets('La pantalla muestra los elementos básicos', (tester) async {
    // 1. Cargar el widget
    await tester.pumpWidget(const MaterialApp(home: SensoresPage()));
    await tester.pump();

    // 2. Verificar el título
    expect(find.text('Cámara y acelerómetro'), findsOneWidget);

    // 3. Verificar el botón de la cámara
    expect(find.text('Tomar fotografía'), findsOneWidget);
    expect(find.byIcon(Icons.camera_alt), findsOneWidget);

    // 4. Verificar los textos del acelerómetro
    expect(find.textContaining('Acelerómetro X'), findsOneWidget);
    expect(find.textContaining('Acelerómetro Y'), findsOneWidget);
    expect(find.textContaining('Acelerómetro Z'), findsOneWidget);
  });

  testWidgets('Los valores iniciales del acelerómetro son 0.00',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SensoresPage()));
    await tester.pump();

    expect(find.text('Acelerómetro X: 0.00'), findsOneWidget);
    expect(find.text('Acelerómetro Y: 0.00'), findsOneWidget);
    expect(find.text('Acelerómetro Z: 0.00'), findsOneWidget);
  });

  testWidgets('El botón de cámara es presionable', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SensoresPage()));
    await tester.pump();

    final boton = find.text('Tomar fotografía');
    expect(boton, findsOneWidget);

    // Verifica que sea un FilledButton con onPressed habilitado
    final filledButton = tester.widget<FilledButton>(
      find.ancestor(
        of: boton,
        matching: find.byType(FilledButton),
      ),
    );
    expect(filledButton.onPressed, isNotNull);
  });
}