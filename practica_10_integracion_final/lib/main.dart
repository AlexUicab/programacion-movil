import 'package:flutter/material.dart';
import 'notificaciones.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Notificaciones.iniciar();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Inicio(),
    );
  }
}

class Inicio extends StatelessWidget {
  const Inicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Práctica 10"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Notificaciones.mostrar();
          },
          child: const Text("Mostrar Notificación"),
        ),
      ),
    );
  }
}