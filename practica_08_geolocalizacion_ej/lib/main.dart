// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/puntos_page.dart';

export 'screens/puntos_page.dart'; // <-- Agrega esto

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PuntosPage(),
    ));