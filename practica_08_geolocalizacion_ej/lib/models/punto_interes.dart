import 'package:geolocator/geolocator.dart';

class PuntoInteres {
  final String nombre;
  final double latitud;
  final double longitud;

  const PuntoInteres({
    required this.nombre,
    required this.latitud,
    required this.longitud,
  });

  /// Distancia en metros desde la posición actual.
  double distanciaDesde(Position actual) {
    return Geolocator.distanceBetween(
      actual.latitude,
      actual.longitude,
      latitud,
      longitud,
    );
  }
}