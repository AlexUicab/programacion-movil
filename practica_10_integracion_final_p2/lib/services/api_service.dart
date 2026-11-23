import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/incident.dart';
import '../models/post.dart';

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);
  @override
  String toString() => message;
}

/// Consumo de API REST pública (JSONPlaceholder).
class ApiService {
  ApiService._();
  static final ApiService instance = ApiService._();

  static const _base = 'https://jsonplaceholder.typicode.com';
  static const _timeout = Duration(seconds: 10);

  /// GET: lista de "avisos de la comunidad".
  Future<List<Post>> fetchPosts() async {
    return _guard(() async {
      final res =
          await http.get(Uri.parse('$_base/posts?_limit=15')).timeout(_timeout);
      if (res.statusCode != 200) {
        throw ApiException('Error del servidor (${res.statusCode}).');
      }
      final list = jsonDecode(res.body) as List<dynamic>;
      return list.map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
    });
  }

  /// POST: sincronización de un reporte (el servidor es de pruebas,
  /// responde 201 pero no almacena realmente el dato).
  Future<void> syncIncident(Incident i) async {
    await _guard(() async {
      final res = await http
          .post(
            Uri.parse('$_base/posts'),
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: jsonEncode({
              'title': i.title,
              'body': '${i.description}\n[${i.category}] '
                  '${i.latitude},${i.longitude}',
              'userId': 1,
            }),
          )
          .timeout(_timeout);
      if (res.statusCode != 201) {
        throw ApiException('No se pudo sincronizar (${res.statusCode}).');
      }
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
    }
  }
}
