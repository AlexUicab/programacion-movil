import 'package:flutter/material.dart';
import '../database/db.dart';
import '../services/prefs_service.dart';

class NotasScreen extends StatefulWidget {
  const NotasScreen({super.key});

  @override
  State<NotasScreen> createState() => _NotasScreenState();
}

class _NotasScreenState extends State<NotasScreen> {
  final _tituloCtrl = TextEditingController();
  final _contenidoCtrl = TextEditingController();

  List<Map<String, dynamic>> _notas = [];
  int? _idEditando; // null = insertar, != null = actualizar
  String _nombreUsuario = 'Invitado';

  @override
  void initState() {
    super.initState();
    _cargarNombre();
    _cargarNotas();
  }

  Future<void> _cargarNombre() async {
    final n = await PrefsService.leerNombre();
    if (mounted) setState(() => _nombreUsuario = n);
  }

  Future<void> _cargarNotas() async {
    final notas = await DB.listar();
    if (mounted) setState(() => _notas = notas);
  }

  Future<void> _guardar() async {
    final titulo = _tituloCtrl.text.trim();
    final contenido = _contenidoCtrl.text.trim();
    if (titulo.isEmpty) return;

    if (_idEditando == null) {
      await DB.insertar(titulo, contenido);
    } else {
      await DB.actualizar(_idEditando!, titulo, contenido);
    }

    _tituloCtrl.clear();
    _contenidoCtrl.clear();
    setState(() => _idEditando = null);
    await _cargarNotas();
  }

  void _cargarParaEditar(Map<String, dynamic> nota) {
    _tituloCtrl.text = nota['titulo'] ?? '';
    _contenidoCtrl.text = nota['contenido'] ?? '';
    setState(() => _idEditando = nota['id']);
  }

  Future<void> _confirmarEliminar(int id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar nota'),
        content: const Text('¿Deseas eliminar esta nota?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await DB.eliminar(id);
      await _cargarNotas();
    }
  }

  Future<void> _cambiarNombre() async {
    final ctrl = TextEditingController(text: _nombreUsuario);
    final nuevo = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tu nombre'),
        content: TextField(controller: ctrl),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    if (nuevo != null && nuevo.isNotEmpty) {
      await PrefsService.guardarNombre(nuevo);
      setState(() => _nombreUsuario = nuevo);
    }
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _contenidoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hola, $_nombreUsuario'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Cambiar nombre',
            onPressed: _cambiarNombre,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _tituloCtrl,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _contenidoCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Contenido',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _guardar,
                    icon: Icon(_idEditando == null ? Icons.save : Icons.edit),
                    label: Text(_idEditando == null ? 'Guardar' : 'Actualizar'),
                  ),
                ),
                if (_idEditando != null) ...[
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () {
                      _tituloCtrl.clear();
                      _contenidoCtrl.clear();
                      setState(() => _idEditando = null);
                    },
                    child: const Text('Cancelar'),
                  ),
                ],
              ],
            ),
            const Divider(),
            Expanded(
              child: _notas.isEmpty
                  ? const Center(child: Text('Sin notas guardadas'))
                  : ListView.builder(
                      itemCount: _notas.length,
                      itemBuilder: (_, i) {
                        final n = _notas[i];
                        final pendiente = (n['pendiente_sincronizar'] ?? 0) == 1;
                        return Card(
                          child: ListTile(
                            leading: Icon(
                              pendiente ? Icons.cloud_off : Icons.cloud_done,
                              color: pendiente ? Colors.orange : Colors.green,
                            ),
                            title: Text(n['titulo'] ?? ''),
                            subtitle: Text(n['contenido'] ?? ''),
                            onTap: () => _cargarParaEditar(n),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmarEliminar(n['id']),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}