import 'package:flutter/material.dart';

class EstadoVacio extends StatelessWidget {
  final String mensaje;
  final IconData icono;
  const EstadoVacio({
    super.key,
    required this.mensaje,
    this.icono = Icons.info_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 48, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 12),
          Text(mensaje, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}