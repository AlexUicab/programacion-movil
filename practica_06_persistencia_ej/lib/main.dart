import 'package:flutter/material.dart';
import 'screens/tareas_screen.dart';

void main() => runApp(const GestorTareasApp());

class GestorTareasApp extends StatelessWidget {
  const GestorTareasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor Offline de Tareas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),
      home: const TareasScreen(),
    );
  }
}