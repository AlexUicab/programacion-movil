import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/contador_provider.dart';
import 'providers/tarea_provider.dart';
import 'screens/home_screen.dart';
import 'screens/contador_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ContadorProvider()),
        ChangeNotifierProvider(create: (_) => TareaProvider()),
      ],
      child: MaterialApp(
        title: 'Práctica 07',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        home: const _Shell(),
      ),
    );
  }
}

class _Shell extends StatefulWidget {
  const _Shell();
  @override
  State<_Shell> createState() => _ShellState();
}

class _ShellState extends State<_Shell> {
  int _idx = 0;
  static const _pages = [HomeScreen(), ContadorScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _idx, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _idx,
        onDestinationSelected: (i) => setState(() => _idx = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'Tareas'),
          NavigationDestination(icon: Icon(Icons.add), label: 'Contador'),
        ],
      ),
    );
  }
}