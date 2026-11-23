import 'dart:io';

import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/date_utils.dart';
import '../models/incident.dart';
import '../services/database_service.dart';
import '../widgets/dialogs.dart';

class ReportDetailScreen extends StatelessWidget {
  final Incident incident;
  const ReportDetailScreen({super.key, required this.incident});

  Future<void> _delete(BuildContext context) async {
    final ok = await confirmDialog(
      context,
      'Eliminar reporte',
      '¿Seguro que deseas eliminar este reporte? '
          'Esta acción no se puede deshacer.',
    );
    if (!ok) return;
    try {
      await DatabaseService.instance.delete(incident.id!);
      try {
        await File(incident.photoPath).delete();
      } catch (_) {/* la foto ya no existe, se ignora */}
      if (context.mounted) Navigator.pop(context, true);
    } catch (_) {
      if (context.mounted) {
        showSnack(context, 'No se pudo eliminar.', error: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final i = incident;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del reporte'),
        actions: [
          IconButton(
            tooltip: 'Eliminar',
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _delete(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(i.photoPath),
              height: 240,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox(
                height: 240,
                child: Center(child: Icon(Icons.broken_image, size: 64)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(i.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Chip(
              avatar: Icon(AppConstants.iconFor(i.category), size: 18),
              label: Text(i.category),
            ),
          ),
          const SizedBox(height: 8),
          Text(i.description),
          const Divider(height: 32),
          _row(Icons.schedule, 'Fecha y hora', formatDateTime(i.createdAt)),
          _row(Icons.my_location, 'Latitud', i.latitude.toStringAsFixed(6)),
          _row(Icons.my_location, 'Longitud', i.longitude.toStringAsFixed(6)),
          _row(
            i.synced ? Icons.cloud_done : Icons.cloud_off,
            'Estado',
            i.synced ? 'Sincronizado' : 'Pendiente de sincronizar',
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) => ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: Icon(icon),
        title: Text(label),
        subtitle: Text(value),
      );
}
