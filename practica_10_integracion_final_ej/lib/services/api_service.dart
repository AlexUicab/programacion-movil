import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/country.dart';
import '../models/weather.dart';

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);
  @override
  String toString() => message;
}

/// Consumo de APIs REST/JSON:
///  - REST Countries (lista de países por región)
///  - Open-Meteo (clima actual por coordenadas)
class ApiService {
  ApiService._();
  static final ApiService instance = ApiService._();

  static const _timeout = Duration(seconds: 12);

  Future<List<Country>> fetchCountries(String region) {
    return _guard(() async {
      final uri = Uri.parse(
        'https://restcountries.com/v3.1/region/$region'
        '?fields=name,capital,population,latlng,flag',
      );
      final res = await http.get(uri).timeout(_timeout);
      if (res.statusCode != 200) {
        throw ApiException('Error del servidor (${res.statusCode}).');
      }
      final list = jsonDecode(res.body) as List<dynamic>;
      final countries = list
          .map((e) => Country.fromJson(e as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));
      return countries;
    });
  }

  Future<Weather> fetchWeather(double lat, double lng) {
    return _guard(() async {
      final uri = Uri.parse(
        'https://api.open-meteo.com/v1/forecast'
        '?latitude=$lat&longitude=$lng'
        '&current=temperature_2m,wind_speed_10m,weather_code',
      );
      final res = await http.get(uri).timeout(_timeout);
      if (res.statusCode != 200) {
        throw ApiException('Error del servidor (${res.statusCode}).');
      }
      return Weather.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    });
  }

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on SocketException {
      throw const ApiException('Sin conexión a internet.');
    } on TimeoutException {
      throw const ApiException('El servidor tardó demasiado en responder.');
    } on FormatException {
      throw const ApiException('Respuesta inválida del servidor.');
    } on http.ClientException {
      throw const ApiException('Error de red. Verifica tu conexión.');
    } on TypeError {
      throw const ApiException('Datos inesperados del servidor.');
    }
  }
}
