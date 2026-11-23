import 'package:geolocator/geolocator.dart';

enum SettingsAction { none, appSettings, locationSettings }

class LocationException implements Exception {
  final String message;
  final SettingsAction action;
  const LocationException(this.message, [this.action = SettingsAction.none]);
  @override
  String toString() => message;
}

class LocationService {
  LocationService._();
  static final LocationService instance = LocationService._();

  /// Devuelve la posición actual o lanza [LocationException] con un
  /// mensaje comprensible (GPS apagado, permiso denegado, tiempo agotado).
  Future<Position> getCurrentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationException(
        'El GPS está desactivado. Actívalo para continuar.',
        SettingsAction.locationSettings,
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw const LocationException('Permiso de ubicación denegado.');
    }
    if (permission == LocationPermission.deniedForever) {
      throw const LocationException(
        'El permiso de ubicación fue denegado permanentemente. '
        'Habilítalo desde los ajustes de la app.',
        SettingsAction.appSettings,
      );
    }

        try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 20),
      );
    } on Exception {
      throw const LocationException(
          'No se pudo obtener la ubicación. Intenta en un lugar abierto.');
    }
  }
}
