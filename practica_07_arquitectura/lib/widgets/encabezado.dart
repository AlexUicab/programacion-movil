import 'package:flutter/material.dart';

class Encabezado extends StatelessWidget {
  final String titulo;
  final String? subtitulo;

  const Encabezado({super.key, required this.titulo, this.subtitulo});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo,
            style: Theme.of(context).textTheme.headlineSmall),
        if (subtitulo != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(subtitulo!,
                style: Theme.of(context).textTheme.bodySmall),
          ),
      ],
    );
  }
}