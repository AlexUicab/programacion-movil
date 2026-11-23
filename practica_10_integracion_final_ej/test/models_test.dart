import 'package:flutter_test/flutter_test.dart';
import 'package:mis_destinos/models/country.dart';
import 'package:mis_destinos/models/destination.dart';
import 'package:mis_destinos/models/weather.dart';

void main() {
  test('Destination se serializa y deserializa', () {
    final d = Destination(
      id: 1,
      name: 'Tulum',
      notes: 'Visitar las ruinas y la playa',
      category: 'Playa',
      budget: 450.5,
      visitDate: DateTime(2027, 1, 10),
      latitude: 20.2114,
      longitude: -87.4654,
      visited: true,
    );
    final c = Destination.fromMap(d.toMap());
    expect(c.name, 'Tulum');
    expect(c.budget, 450.5);
    expect(c.visited, true);
  });

  test('Country.fromJson interpreta la respuesta de la API', () {
    final c = Country.fromJson({
      'name': {'common': 'México'},
      'capital': ['Ciudad de México'],
      'population': 128000000,
      'latlng': [23.0, -102.0],
      'flag': '🇲🇽',
    });
    expect(c.name, 'México');
    expect(c.capital, 'Ciudad de México');
    expect(c.latitude, 23.0);
  });

  test('Weather.fromJson interpreta Open-Meteo', () {
    final w = Weather.fromJson({
      'current': {
        'temperature_2m': 28.4,
        'wind_speed_10m': 12.1,
        'weather_code': 0,
      }
    });
    expect(w.description, 'Despejado');
    expect(w.temperature, 28.4);
  });
}
