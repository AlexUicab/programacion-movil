import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/usuario_provider.dart';
import '../widgets/usuario_tile.dart';
import '../widgets/estado_vacio.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});
  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  @override
  void initState() {
    super.initState();
    // Carga FUERA de build()
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UsuarioProvider>().cargar();
    });
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<UsuarioProvider>();
    final hora = prov.ultimaActualizacion == null
        ? '—'
        : DateFormat('HH:mm:ss').format(prov.ultimaActualizacion!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios REST'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text('Act.: $hora',
                  style: Theme.of(context).textTheme.bodySmall),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: prov.cargando ? null : prov.cargar,
            tooltip: 'Recargar',
          ),
        ],
      ),
      body: _body(prov),
    );
  }

  Widget _body(UsuarioProvider prov) {
    if (prov.cargando && prov.usuarios.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (prov.error != null) {
      return EstadoVacio(
        mensaje: prov.error!,
        icono: Icons.cloud_off,
      );
    }
    if (prov.usuarios.isEmpty) {
      return const EstadoVacio(mensaje: 'Sin usuarios');
    }
    return RefreshIndicator(
      onRefresh: prov.cargar,
      child: ListView.builder(
        itemCount: prov.usuarios.length,
        itemBuilder: (_, i) => UsuarioTile(usuario: prov.usuarios[i]),
      ),
    );
  }
}