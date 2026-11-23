import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/usuario_provider.dart';
import 'screens/usuarios_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UsuarioProvider(),
      child: MaterialApp(
        title: 'Usuarios REST',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: Colors.indigo,
          useMaterial3: true,
        ),
        home: const UsuariosScreen(),
      ),
    );
  }
}