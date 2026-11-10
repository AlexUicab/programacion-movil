import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/db_tareas.dart';
import '../models/tarea.dart';
import '../services/prefs_service.dart';

class TareasScreen extends StatefulWidget {
  const TareasScreen({super.key});

  @override
  State<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  final _tituloCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  List<Tarea> _tareas = [];
  int? _idEditando;
  String _filtro = 'todas';
  String _nombre = 'Invitado';
  Map<String, int> _stats = {'total': 0, 'completadas': 0, 'pendientes': 0};

  @override
  void initState() {
    super.initState();
    _inicializar();
  }

  Future<void> _inicializar() async {
    _filtro = await PrefsService.leerFiltro();
    _nombre = await PrefsService.leerNombre();
    await _cargar();
  }

  Future<void> _cargar() async {
    final lista = await DBTareas.listar(filtro: _filtro);
    final st = await DBTareas.estadisticas();
    if (mounted) {
      setState(() {
        _tareas = lista;
        _stats = st;
      });
    }
  }

  Future<void> _guardar() async {
    final titulo = _tituloCtrl.text.trim();
    final desc = _descCtrl.text.trim();
    if (titulo.isEmpty) {
      _snack('El título no puede estar vacío');
      return;
    }

    if (_idEditando == null) {
      await DBTareas.insertar(Tarea(
        titulo: titulo,
        descripcion: desc,
        actualizadoEn: DateTime.now().millisecondsSinceEpoch,
      ));
    } else {
      // Buscar la tarea actual para conservar el estado "completada"
      final actual = _tareas.firstWhere((t) => t.id == _idEditando);
      await DBTareas.actualizar(actual.copyWith(
        titulo: titulo,
        descripcion: desc,
        actualizadoEn: DateTime.now().millisecondsSinceEpoch,
      ));
    }

    _limpiarFormulario();
    await _cargar();
  }

  void _limpiarFormulario() {
    _tituloCtrl.clear();
    _descCtrl.clear();
    setState(() => _idEditando = null);
  }

  void _cargarParaEditar(Tarea t) {
    _tituloCtrl.text = t.titulo;
    _descCtrl.text = t.descripcion;
    setState(() => _idEditando = t.id);
  }

  Future<void> _toggleCompletada(Tarea t) async {
    await DBTareas.marcarCompletada(t.id!, !t.completada);
    await _cargar();
  }

  Future<void> _confirmarEliminar(Tarea t) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar tarea'),
        content: Text('¿Eliminar "${t.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await DBTareas.eliminar(t.id!);
      await _cargar();
    }
  }

  Future<void> _cambiarFiltro(String? nuevo) async {
    if (nuevo == null) return;
    await PrefsService.guardarFiltro(nuevo);
    setState(() => _filtro = nuevo);
    await _cargar();
  }

  Future<void> _cambiarNombre() async {
    final ctrl = TextEditingController(text: _nombre);
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
      setState(() => _nombre = nuevo);
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  // ============================================================
  // UI
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tareas de $_nombre'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Cambiar nombre',
            onPressed: _cambiarNombre,
          ),
          PopupMenuButton<String>(
            tooltip: 'Filtro',
            icon: const Icon(Icons.filter_alt),
            initialValue: _filtro,
            onSelected: _cambiarFiltro,
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'todas', child: Text('Todas')),
              PopupMenuItem(value: 'pendientes', child: Text('Pendientes')),
              PopupMenuItem(value: 'completadas', child: Text('Completadas')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          _buildContadores(),
          _buildFormulario(),
          const Divider(height: 1),
          Expanded(
            child: _tareas.isEmpty
                ? Center(
                    child: Text(
                      _filtro == 'todas'
                          ? 'Sin tareas. ¡Crea la primera!'
                          : 'No hay tareas en este filtro',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _tareas.length,
                    itemBuilder: (_, i) => _buildTareaCard(_tareas[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildContadores() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Row(
        children: [
          _chip('Total', _stats['total'] ?? 0, Colors.indigo),
          const SizedBox(width: 8),
          _chip('Pendientes', _stats['pendientes'] ?? 0, Colors.orange),
          const SizedBox(width: 8),
          _chip('Hechas', _stats['completadas'] ?? 0, Colors.green),
        ],
      ),
    );
  }

  Widget _chip(String label, int valor, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text('$valor',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color)),
            Text(label, style: TextStyle(fontSize: 11, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildFormulario() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          TextField(
            controller: _tituloCtrl,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Título',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _descCtrl,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Descripción (opcional)',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _guardar,
                  icon: Icon(_idEditando == null ? Icons.add : Icons.save),
                  label: Text(_idEditando == null ? 'Crear tarea' : 'Guardar cambios'),
                ),
              ),
              if (_idEditando != null) ...[
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: _limpiarFormulario,
                  child: const Text('Cancelar'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTareaCard(Tarea t) {
    final fecha = DateTime.fromMillisecondsSinceEpoch(t.actualizadoEn);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: Checkbox(
          value: t.completada,
          onChanged: (_) => _toggleCompletada(t),
        ),
        title: Text(
          t.titulo,
          style: TextStyle(
            decoration: t.completada ? TextDecoration.lineThrough : null,
            color: t.completada ? Colors.grey : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (t.descripcion.isNotEmpty) Text(t.descripcion),
            Text(
              DateFormat('dd/MM/yyyy HH:mm').format(fecha),
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        onTap: () => _cargarParaEditar(t),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => _confirmarEliminar(t),
        ),
      ),
    );
  }
}