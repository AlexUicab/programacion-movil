import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/location_service.dart';

Future<void> showSettingsDialog(
  BuildContext context, {
  required String message,
  required SettingsAction action,
}) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Permiso necesario'),
      content: Text(message),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar')),
        FilledButton(
          onPressed: () async {
            Navigator.pop(ctx);
            if (action == SettingsAction.locationSettings) {
              await Geolocator.openLocationSettings();
            } else {
              await openAppSettings();
            }
          },
          child: const Text('Abrir ajustes'),
        ),
      ],
    ),
  );
}

Future<bool> confirmDialog(
    BuildContext context, String title, String body) async {
  final r = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar')),
        FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar')),
      ],
    ),
  );
  return r ?? false;
}

void showSnack(BuildContext context, String message, {bool error = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: error ? Colors.red.shade700 : null,
    ));
}
