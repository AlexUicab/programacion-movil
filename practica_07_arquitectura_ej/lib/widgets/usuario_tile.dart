import 'package:flutter/material.dart';
import '../models/usuario.dart';

class UsuarioTile extends StatelessWidget {
  final Usuario usuario;
  const UsuarioTile({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text('${usuario.id}')),
      title: Text(usuario.nombre),
      subtitle: Text(usuario.correo),
    );
  }
}