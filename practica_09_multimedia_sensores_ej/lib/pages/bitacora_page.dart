import 'dart:io';
import 'package:flutter/material.dart';
import '../models/evidencia.dart';
import '../services/camara_service.dart';
import '../services/sensor_service.dart';

class BitacoraPage extends StatefulWidget {
  const BitacoraPage({super.key});

  @override
  State<BitacoraPage> createState() => _BitacoraPageState();
}

class _BitacoraPageState extends State<BitacoraPage> {
  final SensorService _sensorService = SensorService();
  final CamaraService _camaraService = CamaraService();

  final List<Evidencia> _evidencias = [];
  String? _errorSensores;
  bool _capturando = false;

  @override
  void initState() {
    super.initState();
    _sensorService.start(
      onUpdate: () {
        if (mounted) setState(() {});
      },
      onError: (e) {
        if (mounted) setState(() => _errorSensores = e.toString());
      },
    );
  }

  @override
  void dispose() {
    _sensorService.dispose();
    super.dispose();
  }

  Future<void> _registrarEvidencia() async {
    if (_capturando) return;
    setState(() => _capturando = true);

    try {
      final ruta = await _camaraService.capturarFoto();

      // ✅ Manejo explícito de cancelación
      if (ruta == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Captura cancelada. No se registró evidencia.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        return;
      }

      // Congelamos los valores del sensor en el instante de la foto
      final nueva = Evidencia(
        rutaFoto: ruta,
        fechaHora: DateTime.now(),
        acelerometro: _sensorService.acelerometro,
        giroscopio: _sensorService.giroscopio,
      );

      if (mounted) {
        setState(() => _evidencias.insert(0, nueva));
      }
    } on Exception catch (e) {
      // Manejo de permisos denegados / errores de plataforma
      if (mounted) {
        final mensaje = e.toString().toLowerCase();
        final esPermiso = mensaje.contains('permission') ||
            mensaje.contains('denied') ||
            mensaje.contains('camera_access_denied');

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            icon: const Icon(Icons.lock_outline, color: Colors.orange),
            title: Text(esPermiso ? 'Permiso denegado' : 'Error de cámara'),
            content: Text(
              esPermiso
                  ? 'No se concedió acceso a la cámara. '
                      'Actívalo en los ajustes del sistema.'
                  : 'No se pudo abrir la cámara: $e',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Entendido'),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _capturando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bitácora de inspección'),
        actions: [
          if (_evidencias.isNotEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Chip(label: Text('${_evidencias.length} registros')),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _capturando ? null : _registrarEvidencia,
        icon: _capturando
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.add_a_photo),
        label: Text(_capturando ? 'Capturando…' : 'Nueva evidencia'),
      ),
      body: Column(
        children: [
          if (_errorSensores != null)
            MaterialBanner(
              backgroundColor: Colors.red.shade50,
              content: Text('Sensor no disponible: $_errorSensores'),
              leading: const Icon(Icons.warning_amber, color: Colors.red),
              actions: [
                TextButton(
                  onPressed: () => setState(() => _errorSensores = null),
                  child: const Text('Cerrar'),
                ),
              ],
            ),
          Expanded(
            child: _evidencias.isEmpty
                ? const _EstadoVacio()
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _evidencias.length,
                    itemBuilder: (_, i) => TarjetaEvidencia(
                      evidencia: _evidencias[i],
                      indice: _evidencias.length - i,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class TarjetaEvidencia extends StatelessWidget {
  const TarjetaEvidencia({
    super.key,
    required this.evidencia,
    required this.indice,
  });

  final Evidencia evidencia;
  final int indice;

  @override
  Widget build(BuildContext context) {
    final fecha = evidencia.fechaHora.toLocal().toString().split('.').first;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Registro $indice',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Icon(Icons.access_time, color: Colors.grey.shade600, size: 18),
                const SizedBox(width: 4),
                Text(
                  fecha,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(evidencia.rutaFoto),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(Icons.broken_image_outlined, size: 40),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _DatoSensor(
                    label: 'Acelerómetro',
                    valor: evidencia.acelerometro.toString(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _DatoSensor(
                    label: 'Giroscopio',
                    valor: evidencia.giroscopio.toString(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DatoSensor extends StatelessWidget {
  const _DatoSensor({required this.label, required this.valor});

  final String label;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            valor,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _EstadoVacio extends StatelessWidget {
  const _EstadoVacio();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo_camera_outlined,
              size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Sin evidencias registradas',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text('Pulsa "Nueva evidencia" para comenzar'),
        ],
      ),
    );
  }
}