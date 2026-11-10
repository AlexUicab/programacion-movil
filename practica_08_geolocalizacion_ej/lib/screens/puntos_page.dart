import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/punto_interes.dart';

class PuntosPage extends StatefulWidget {
  const PuntosPage({super.key});

  @override
  State<PuntosPage> createState() => _PuntosPageState();
}

class _PuntosPageState extends State<PuntosPage> {
  Position? _posicionActual;
  final List<PuntoInteres> _puntos = [];
  String _mensaje = 'Sin ubicación';
  bool _cargando = false;

  static const int _maxPuntos = 3;

  // ---------- Ubicación ----------
  Future<void> _obtenerUbicacion() async {
    setState(() {
      _cargando = true;
      _mensaje = 'Obteniendo ubicación...';
    });

    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        setState(() => _mensaje = 'Activa el servicio de ubicación');
        return;
      }

      var permiso = await Geolocator.checkPermission();
      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
      }
      if (permiso == LocationPermission.denied ||
          permiso == LocationPermission.deniedForever) {
        setState(() => _mensaje = 'Permiso de ubicación no disponible');
        return;
      }

      final p = await Geolocator.getCurrentPosition();
      setState(() {
        _posicionActual = p;
        _mensaje = 'Ubicación obtenida';
      });
    } catch (e) {
      setState(() => _mensaje = 'Error: $e');
    } finally {
      setState(() => _cargando = false);
    }
  }

  // ---------- Guardar punto ----------
  Future<void> _agregarPunto() async {
    if (_posicionActual == null) {
      _snack('Primero obtén tu ubicación actual');
      return;
    }
    if (_puntos.length >= _maxPuntos) {
      _snack('Ya guardaste los $_maxPuntos puntos permitidos');
      return;
    }

    final nombreCtrl = TextEditingController();
    final latCtrl = TextEditingController();
    final lonCtrl = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nuevo punto de interés'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: latCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true, signed: true),
              decoration: const InputDecoration(labelText: 'Latitud'),
            ),
            TextField(
              controller: lonCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true, signed: true),
              decoration: const InputDecoration(labelText: 'Longitud'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    final nombre = nombreCtrl.text.trim();
    final lat = double.tryParse(latCtrl.text.trim());
    final lon = double.tryParse(lonCtrl.text.trim());

    if (nombre.isEmpty || lat == null || lon == null) {
      _snack('Datos inválidos');
      return;
    }
    if (lat < -90 || lat > 90 || lon < -180 || lon > 180) {
      _snack('Coordenadas fuera de rango');
      return;
    }

    setState(() {
      _puntos.add(PuntoInteres(nombre: nombre, latitud: lat, longitud: lon));
    });
  }

  // ---------- Abrir mapa ----------
  Future<void> _abrirMapa(double lat, double lon) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lon',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      _snack('No se pudo abrir el mapa');
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ---------- UI ----------
  String _fmtDistancia(double metros) {
    if (metros < 1000) return '${metros.toStringAsFixed(1)} m';
    return '${(metros / 1000).toStringAsFixed(2)} km';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Puntos de interés')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _cardUbicacion(),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _cargando ? null : _obtenerUbicacion,
                    icon: const Icon(Icons.my_location),
                    label: const Text('Obtener ubicación'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _posicionActual == null ? null : _agregarPunto,
                    icon: const Icon(Icons.add_location_alt),
                    label: Text('Agregar (${_puntos.length}/$_maxPuntos)'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Mis puntos:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: _puntos.isEmpty
                  ? const Center(
                      child: Text('Aún no hay puntos guardados'),
                    )
                  : ListView.builder(
                      itemCount: _puntos.length,
                      itemBuilder: (_, i) {
                        final p = _puntos[i];
                        final dist = _posicionActual == null
                            ? null
                            : p.distanciaDesde(_posicionActual!);
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.place),
                            title: Text(p.nombre),
                            subtitle: Text(
                              'Lat: ${p.latitud.toStringAsFixed(6)}\n'
                              'Lon: ${p.longitud.toStringAsFixed(6)}\n'
                              'Distancia: ${dist == null ? "—" : _fmtDistancia(dist)}',
                            ),
                            isThreeLine: true,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.map),
                                  tooltip: 'Abrir en mapa',
                                  onPressed: () =>
                                      _abrirMapa(p.latitud, p.longitud),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  tooltip: 'Eliminar',
                                  onPressed: () => setState(
                                      () => _puntos.removeAt(i)),
                                ),
                              ],
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

  Widget _cardUbicacion() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_mensaje,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            if (_posicionActual != null) ...[
              const SizedBox(height: 4),
              Text('Latitud: ${_posicionActual!.latitude.toStringAsFixed(6)}'),
              Text('Longitud: ${_posicionActual!.longitude.toStringAsFixed(6)}'),
              Text(
                  'Precisión: ${_posicionActual!.accuracy.toStringAsFixed(1)} m'),
            ],
          ],
        ),
      ),
    );
  }
}