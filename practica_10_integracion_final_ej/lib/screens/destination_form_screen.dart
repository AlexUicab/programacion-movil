import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/formatters.dart';
import '../models/destination.dart';
import '../services/database_service.dart';
import '../services/location_service.dart';
import '../services/notification_service.dart';
import '../widgets/dialogs.dart';
import '../widgets/primary_button.dart';

class DestinationFormScreen extends StatefulWidget {
  final String? initialName;
  final String? initialNotes;
  final double? initialLat;
  final double? initialLng;

  const DestinationFormScreen({
    super.key,
    this.initialName,
    this.initialNotes,
    this.initialLat,
    this.initialLng,
  });

  @override
  State<DestinationFormScreen> createState() => _DestinationFormScreenState();
}

class _DestinationFormScreenState extends State<DestinationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _notesCtrl;
  final _budgetCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();

  String? _category;
  DateTime? _date;
  double? _lat;
  double? _lng;

  bool _loadingLocation = false;
  bool _saving = false;
  String? _locationError;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialName ?? '');
    _notesCtrl = TextEditingController(text: widget.initialNotes ?? '');
    _lat = widget.initialLat;
    _lng = widget.initialLng;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _notesCtrl.dispose();
    _budgetCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _date = picked;
        _dateCtrl.text = formatDate(picked);
      });
    }
  }

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

  Future<void> _save() async {
    final formOk = _formKey.currentState!.validate();
    setState(() =>
        _locationError = _lat == null ? 'Las coordenadas son obligatorias.' : null);
    if (!formOk || _lat == null) return;

    setState(() => _saving = true);
    try {
      final budget = double.parse(_budgetCtrl.text.trim().replaceAll(',', '.'));
      final d = Destination(
        name: _nameCtrl.text.trim(),
        notes: _notesCtrl.text.trim(),
        category: _category!,
        budget: budget,
        visitDate: _date!,
        latitude: _lat!,
        longitude: _lng!,
      );
      await DatabaseService.instance.insert(d);
      await NotificationService.instance
          .showDestinationSaved(d.name, formatDate(d.visitDate));

      if (!mounted) return;
      showSnack(context, 'Destino guardado correctamente.');
      Navigator.pop(context, true);
    } catch (_) {
      if (mounted) {
        showSnack(context, 'Error al guardar el destino. Intenta de nuevo.',
            error: true);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo destino')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _nameCtrl,
                maxLength: 50,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Nombre del destino'),
                validator: (v) {
                  final t = v?.trim() ?? '';
                  if (t.isEmpty) return 'El nombre es obligatorio.';
                  if (t.length < 3) return 'Mínimo 3 caracteres.';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesCtrl,
                maxLines: 3,
                maxLength: 250,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Notas / qué quieres hacer',
                  alignLabelWithHint: true,
                ),
                validator: (v) {
                  final t = v?.trim() ?? '';
                  if (t.isEmpty) return 'Las notas son obligatorias.';
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
                validator: (v) => v == null ? 'Selecciona una categoría.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _budgetCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                    labelText: 'Presupuesto (USD)', prefixText: '\$ '),
                validator: (v) {
                  final n = double.tryParse((v ?? '').trim().replaceAll(',', '.'));
                  if (n == null) return 'Ingresa un número válido.';
                  if (n <= 0) return 'Debe ser mayor a 0.';
                  if (n > 1000000) return 'Máximo \$1,000,000.';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateCtrl,
                readOnly: true,
                onTap: _pickDate,
                decoration: const InputDecoration(
                  labelText: 'Fecha planeada de visita',
                  suffixIcon: Icon(Icons.calendar_month),
                ),
                validator: (_) => _date == null ? 'Selecciona una fecha.' : null,
              ),
              const SizedBox(height: 16),
              if (_lat != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Latitud: ${_lat!.toStringAsFixed(6)}\n'
                    'Longitud: ${_lng!.toStringAsFixed(6)}',
                  ),
                ),
              OutlinedButton.icon(
                onPressed: _loadingLocation ? null : _getLocation,
                icon: _loadingLocation
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.my_location),
                label: Text(_lat == null
                    ? 'Usar mi ubicación actual (GPS)'
                    : 'Actualizar con mi ubicación'),
              ),
              if (_locationError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Text(_locationError!,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error)),
                ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Guardar destino',
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
