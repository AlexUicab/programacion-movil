import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';

class UsuarioService {
  static const _url = 'https://jsonplaceholder.typicode.com/users';

  Future<List<Usuario>> obtenerUsuarios() async {
    final r = await http.get(Uri.parse(_url));
    if (r.statusCode != 200) {
      throw Exception('HTTP ${r.statusCode}');
    }
    final List datos = jsonDecode(r.body) as List;
    return datos
        .map((e) => Usuario.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}