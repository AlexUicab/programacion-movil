import 'package:flutter/material.dart';

import '../models/weather.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;
  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      color: cs.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Icon(weather.icon, size: 48, color: cs.onSecondaryContainer),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${weather.temperature.toStringAsFixed(1)} °C',
                      style: Theme.of(context).textTheme.headlineSmall),
                  Text(weather.description),
                  Text('Viento: ${weather.windSpeed.toStringAsFixed(1)} km/h'),
                ]),
          ),
        ]),
      ),
    );
  }
}
