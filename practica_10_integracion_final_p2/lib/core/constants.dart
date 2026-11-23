import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Reporte Móvil de Incidencias';

  /// Categorías disponibles en el formulario.
  static const Map<String, IconData> categories = {
    'Infraestructura': Icons.construction,
    'Seguridad': Icons.shield_outlined,
    'Servicios públicos': Icons.water_drop_outlined,
    'Medio ambiente': Icons.park_outlined,
    'Otro': Icons.more_horiz,
  };

  static IconData iconFor(String category) =>
      categories[category] ?? Icons.report_problem_outlined;
}
