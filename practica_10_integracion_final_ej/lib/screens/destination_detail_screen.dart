import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../core/constants.dart';
import '../core/formatters.dart';
import '../models/destination.dart';
import '../models/weather.dart';
import '../services/api_service.dart';
import '../services/database_service.dart';
import '../services/location_service.dart';
import '../widgets/dialogs.dart';
import '../widgets/weather_card.dart';

class DestinationDetailScreen extends StatefulWidget {
  final Destination destination;
  const DestinationDetailScreen({super.key, required this.destination});

  @override
  State<DestinationDetailScreen> createState() =>
      _DestinationDetailScreenState();
}

class _DestinationDetailScreenState extends State<DestinationDetailScreen> {
  late Destination _d;
  late Future<Weather> _weather;
  String? _distance;
  bool _loadingDistance = false;

    @override
  void initState() {
    super.initState();
    _d = widget.destination;
    _weather = ApiService.instance.fetchWeather(_d.latitude, _d.longitude);
  }

    void _loadWeather() {
    final future = ApiService.instance.fetchWeather(_d.latitude, _d.longitude);
    setState(() {
      _weather = future;
    });
  }

  Future<void> _toggleVisited() async {
    try {
      await DatabaseService.instance.setVisited(_d.id!, !_d.visited);
      setState(() => _d = _d.copyWith(visited: !_d.visited));
    } catch (_) {
      if (mounted) showSnack(context, 'No se pudo actualizar.', error: true);
    }
  }

  Future<void> _delete() async {
    final ok = await confirmDialog(context, 'Eliminar destino',
        '¿Seguro que deseas eliminar "${_d.name}"?');
    if (!ok) return;
    try {
      await DatabaseService.instance.delete(_d.id!);
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) showSnack(context, 'No se pudo eliminar.', error: true);
    }
  }

  Future<void> _calcDistance() async {
    setState(() => _loadingDistance = true);
    try {
      final pos = await LocationService.instance.getCurrentPosition();
      final meters = Geolocator.distanceBetween(
          pos.latitude, pos.longitude, _d.latitude, _d.longitude);
      setState(() => _distance = '${(meters / 1000).toStringAsFixed(1)} km');
    } on LocationException catch (e) {
      if (!mounted) return;
      if (e.action != SettingsAction.none) {
        await showSettingsDialog(context, message: e.message, action: e.action);
      } else {
        showSnack(context, e.message, error: true);
      }
    } finally {
      if (mounted) setState(() => _loadingDistance = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = _d;
    return Scaffold(
      appBar: AppBar(
        title: Text(d.name),
        actions: [
          IconButton(
              tooltip: 'Eliminar',
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(children: [
            Chip(
              avatar: Icon(AppConstants.iconFor(d.category), size: 18),
              label: Text(d.category),
            ),
            const SizedBox(width: 8),
            Chip(
              avatar: Icon(d.visited ? Icons.check_circle : Icons.schedule,
                  size: 18),
              label: Text(d.visited ? 'Visitado' : 'Pendiente'),
            ),
          ]),
          const SizedBox(height: 12),
          Text(d.notes),
          const Divider(height: 32),
          _row(Icons.event, 'Fecha planeada', formatDate(d.visitDate)),
          _row(Icons.payments_outlined, 'Presupuesto', formatMoney(d.budget)),
          _row(Icons.place_outlined, 'Coordenadas',
              '${d.latitude.toStringAsFixed(5)}, ${d.longitude.toStringAsFixed(5)}'),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _loadingDistance ? null : _calcDistance,
            icon: _loadingDistance
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.social_distance),
            label: Text(_distance == null
                ? '¿A qué distancia estoy? (GPS)'
                : 'Distancia desde ti: $_distance'),
          ),
          const SizedBox(height: 16),
          Text('Clima actual en el destino',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          FutureBuilder<Weather>(
            future: _weather,
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snap.hasError) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.cloud_off),
                    title: Text(snap.error.toString()),
                    trailing: IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _loadWeather),
                  ),
                );
              }
              return WeatherCard(weather: snap.data!);
            },
          ),
          const SizedBox(height: 16),
          FilledButton.tonalIcon(
            onPressed: _toggleVisited,
            icon: Icon(d.visited ? Icons.undo : Icons.check),
            label: Text(d.visited ? 'Marcar como pendiente' : 'Marcar como visitado'),
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
