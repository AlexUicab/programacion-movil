import 'package:flutter/material.dart';

/// Clima actual (API Open-Meteo).
class Weather {
  final double temperature;
  final double windSpeed;
  final int code;

  const Weather({
    required this.temperature,
    required this.windSpeed,
    required this.code,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final c = json['current'] as Map<String, dynamic>;
    return Weather(
      temperature: (c['temperature_2m'] as num).toDouble(),
      windSpeed: (c['wind_speed_10m'] as num).toDouble(),
      code: (c['weather_code'] as num).toInt(),
    );
  }

  String get description {
    if (code == 0) return 'Despejado';
    if (code <= 3) return 'Parcialmente nublado';
    if (code == 45 || code == 48) return 'Niebla';
    if (code >= 51 && code <= 57) return 'Llovizna';
    if (code >= 61 && code <= 67) return 'Lluvia';
    if (code >= 71 && code <= 77) return 'Nieve';
    if (code >= 80 && code <= 82) return 'Chubascos';
    if (code >= 95) return 'Tormenta';
    return 'Variable';
  }

  IconData get icon {
    if (code == 0) return Icons.wb_sunny;
    if (code <= 3) return Icons.wb_cloudy;
    if (code == 45 || code == 48) return Icons.foggy;
    if (code >= 71 && code <= 77) return Icons.ac_unit;
    if (code >= 95) return Icons.thunderstorm;
    return Icons.grain;
  }
}
