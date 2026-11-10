import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tarea_provider.dart';
//import '../widgets/encabezado.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Carga FUERA de build()
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TareaProvider>().cargar();
    });
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<TareaProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Tareas (ListView.builder)')),
      body: prov.cargando
          ? const Center(child: CircularProgressIndicator())
          : prov.error != null
              ? Center(child: Text('Error: ${prov.error}'))
              : ListView.builder(
                  itemCount: prov.tareas.length,
                  // itemBuilder crea solo lo visible → lista eficiente
                  itemBuilder: (context, i) {
                    final t = prov.tareas[i];
                    return ListTile(
                      title: Text(t.titulo),
                      subtitle: Text(prov.formatear(t.fecha)),
                      trailing: Checkbox(
                        value: t.completada,
                        onChanged: (_) => prov.alternar(t.id),
                      ),
                    );
                  },
                ),
    );
  }
}