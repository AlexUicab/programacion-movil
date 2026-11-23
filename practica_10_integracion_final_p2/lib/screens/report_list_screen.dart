import 'package:flutter/material.dart';

import '../models/incident.dart';
import '../services/api_service.dart';
import '../services/database_service.dart';
import '../widgets/dialogs.dart';
import '../widgets/incident_card.dart';
import '../widgets/state_views.dart';
import 'report_detail_screen.dart';

class ReportListScreen extends StatefulWidget {
  const ReportListScreen({super.key});

  @override
  State<ReportListScreen> createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {
  List<Incident> _items = [];
  bool _loading = true;
  bool _syncing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await DatabaseService.instance.getAll();
      if (mounted) setState(() => _items = data);
    } catch (_) {
      if (mounted) setState(() => _error = 'No se pudieron leer los reportes.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// Sincronización: envía los reportes pendientes a la API REST.
  Future<void> _sync() async {
    setState(() => _syncing = true);
    try {
      final pending = await DatabaseService.instance.getPending();
      if (pending.isEmpty) {
        if (mounted) showSnack(context, 'No hay reportes pendientes.');
        return;
      }
      var ok = 0;
      for (final i in pending) {
        await ApiService.instance.syncIncident(i);
        await DatabaseService.instance.markSynced(i.id!);
        ok++;
      }
      if (mounted) showSnack(context, '$ok reporte(s) sincronizado(s).');
      await _load();
    } on ApiException catch (e) {
      if (mounted) showSnack(context, e.message, error: true);
    } finally {
      if (mounted) setState(() => _syncing = false);
    }
  }

  Future<void> _open(Incident i) async {
    final deleted = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => ReportDetailScreen(incident: i)),
    );
    if (deleted == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis reportes'),
        actions: [
          IconButton(
            tooltip: 'Sincronizar',
            onPressed: _syncing ? null : _sync,
            icon: _syncing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.cloud_upload_outlined),
          ),
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return ErrorView(message: _error!, onRetry: _load);
    if (_items.isEmpty) {
      return const EmptyState(
        icon: Icons.inbox_outlined,
        message:
            'Aún no tienes reportes.\nCrea el primero desde la pantalla de inicio.',
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _items.length,
        itemBuilder: (_, i) =>
            IncidentCard(incident: _items[i], onTap: () => _open(_items[i])),
      ),
    );
  }
}
