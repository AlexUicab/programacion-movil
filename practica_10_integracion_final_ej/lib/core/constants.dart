import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Mis Destinos';

  static const Map<String, IconData> categories = {
    'Playa': Icons.beach_access,
    'Montaña': Icons.terrain,
    'Ciudad': Icons.location_city,
    'Cultural': Icons.museum,
    'Gastronomía': Icons.restaurant,
  };

  static IconData iconFor(String category) =>
      categories[category] ?? Icons.place;

  /// Regiones disponibles en la sección Explorar (API REST Countries).
  static const Map<String, String> regions = {
    'americas': 'Américas',
    'europe': 'Europa',
    'asia': 'Asia',
    'africa': 'África',
    'oceania': 'Oceanía',
  };
}
