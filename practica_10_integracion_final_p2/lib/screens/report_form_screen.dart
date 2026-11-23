import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:permission_handler/permission_handler.dart';

import '../core/constants.dart';
import '../core/date_utils.dart';
import '../models/incident.dart';
import '../services/database_service.dart';
import '../services/location_service.dart';
import '../services/notification_service.dart';
import '../widgets/dialogs.dart';
import '../widgets/primary_button.dart';

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({super.key});

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _picker = ImagePicker();

  String? _category;
  File? _photo;
  double? _lat;
  double? _lng;
  final DateTime _openedAt = DateTime.now();

  bool _loadingLocation = false;
  bool _saving = false;
  String? _photoError;
  String? _locationError;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  // ---------- Fotografía ----------
  Future<void> _takePhoto() async {
    final status = await Permission.camera.request();
    if (status.isPermanentlyDenied) {
      if (!mounted) return;
      await showSettingsDialog(
        context,
        message: 'El permiso de cámara fue denegado permanentemente. '
            'Habilítalo desde los ajustes.',
        action: SettingsAction.appSettings,
      );
      return;
    }
    if (!status.isGranted) {
      setState(
          () => _photoError = 'Se necesita permiso de cámara para continuar.');
      return;
    }

    try {
          String step = 'abrir la cámara';
    try {
      final x = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
        maxWidth: 1280,
      );
      if (x == null) return; // el usuario canceló

      step = 'guardar el archivo';
      // Carpeta privada de la app (la misma donde vive la base de datos).
      // Evita depender de path_provider.
      final dir = Directory(await getDatabasesPath());
      await dir.create(recursive: true);
      final dest =
          p.join(dir.path, 'img_${DateTime.now().millisecondsSinceEpoch}.jpg');
      final saved = await File(x.path).copy(dest);

      setState(() {
        _photo = saved;
        _photoError = null;
      });
    } catch (e) {
      final msg = e.toString().split('\n').first;
      setState(() => _photoError = 'Falló al $step: $msg');
    }
    } catch (e) {
      setState(() => _photoError = 'No se pudo capturar la fotografía: $e');
    }
  }

  // ---------- Ubicación ----------
  Future<void> _getLocation() async {
    setState(() {
      _loadingLocation = true;
      _locationError = null;
    });
    try {
      final pos = await LocationService.instance.getCurrentPosition();
      setState(() {
        _lat = pos.latitude;
        _lng = pos.longitude;
      });
    } on LocationException catch (e) {
      setState(() => _locationError = e.message);
      if (e.action != SettingsAction.none && mounted) {
        await showSettingsDialog(context, message: e.message, action: e.action);
      }
    } finally {
      if (mounted) setState(() => _loadingLocation = false);
    }
  }

  // ---------- Guardado ----------
  Future<void> _save() async {
    final formOk = _formKey.currentState!.validate();
    setState(() {
      _photoError = _photo == null ? 'La fotografía es obligatoria.' : null;
      _locationError = _lat == null ? 'La ubicación es obligatoria.' : null;
    });
    if (!formOk || _photo == null || _lat == null) return;

    setState(() => _saving = true);
    try {
      final incident = Incident(
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        category: _category!,
        photoPath: _photo!.path,
        latitude: _lat!,
        longitude: _lng!,
        createdAt: DateTime.now(), // fecha y hora del reporte
      );
      await DatabaseService.instance.insert(incident);
      await NotificationService.instance.showReportSaved(incident.title);

      if (!mounted) return;
      showSnack(context, 'Reporte guardado correctamente.');
      Navigator.pop(context, true);
    } catch (_) {
      if (mounted) {
        showSnack(context, 'Error al guardar el reporte. Intenta de nuevo.',
            error: true);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo reporte')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _titleCtrl,
                maxLength: 60,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) {
                  final t = v?.trim() ?? '';
                  if (t.isEmpty) return 'El título es obligatorio.';
                  if (t.length < 5) return 'Mínimo 5 caracteres.';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descCtrl,
                maxLines: 4,
                maxLength: 300,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  alignLabelWithHint: true,
                ),
                validator: (v) {
                  final t = v?.trim() ?? '';
                  if (t.isEmpty) return 'La descripción es obligatoria.';
                  if (t.length < 10) return 'Mínimo 10 caracteres.';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Categoría'),
                items: AppConstants.categories.keys
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _category = v),
                validator: (v) =>
                    v == null ? 'Selecciona una categoría.' : null,
              ),
              const SizedBox(height: 16),
              _PhotoSection(
                  photo: _photo, error: _photoError, onTap: _takePhoto),
              const SizedBox(height: 16),
              _LocationSection(
                lat: _lat,
                lng: _lng,
                loading: _loadingLocation,
                error: _locationError,
                onTap: _getLocation,
              ),
              const SizedBox(height: 16),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.schedule),
                title: Text('Fecha y hora: ${formatDateTime(_openedAt)}'),
                subtitle: const Text('Se registra la hora exacta al guardar'),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Guardar reporte',
                icon: Icons.save,
                loading: _saving,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhotoSection extends StatelessWidget {
  final File? photo;
  final String? error;
  final VoidCallback onTap;
  const _PhotoSection(
      {required this.photo, required this.error, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (photo != null)
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(photo!,
              height: 200, width: double.infinity, fit: BoxFit.cover),
        ),
      const SizedBox(height: 8),
      OutlinedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.camera_alt_outlined),
        label: Text(photo == null ? 'Tomar fotografía' : 'Cambiar fotografía'),
      ),
      if (error != null)
        Padding(
          padding: const EdgeInsets.only(top: 6, left: 4),
          child: Text(error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error)),
        ),
    ]);
  }
}

class _LocationSection extends StatelessWidget {
  final double? lat, lng;
  final bool loading;
  final String? error;
  final VoidCallback onTap;
  const _LocationSection({
    required this.lat,
    required this.lng,
    required this.loading,
    required this.error,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (lat != null)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            'Latitud: ${lat!.toStringAsFixed(6)}\n'
            'Longitud: ${lng!.toStringAsFixed(6)}',
          ),
        ),
      OutlinedButton.icon(
        onPressed: loading ? null : onTap,
        icon: loading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2))
            : const Icon(Icons.my_location),
        label: Text(lat == null ? 'Obtener ubicación' : 'Actualizar ubicación'),
      ),
      if (error != null)
        Padding(
          padding: const EdgeInsets.only(top: 6, left: 4),
          child: Text(error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error)),
        ),
    ]);
  }
}
