import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:practica_07_arquitectura/providers/contador_provider.dart';
import 'package:practica_07_arquitectura/screens/contador_screen.dart';

void main() {
  testWidgets('muestra 0 y suma al pulsar Incrementar', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ContadorProvider(),
        child: const MaterialApp(home: ContadorScreen()),
      ),
    );

    // Estado inicial
    expect(find.text('0'), findsOneWidget);

    // Pulsar "Incrementar" dos veces
    await tester.tap(find.text('Incrementar'));
    await tester.pump();
    await tester.tap(find.text('Incrementar'));
    await tester.pump();

    expect(find.text('2'), findsOneWidget);

    // Reiniciar
    await tester.tap(find.text('Reiniciar'));
    await tester.pump();
    expect(find.text('0'), findsOneWidget);
  });
}