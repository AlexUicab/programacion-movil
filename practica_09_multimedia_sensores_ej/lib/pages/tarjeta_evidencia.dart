import 'dart:io';
import 'package:flutter/material.dart';
import '../models/evidencia.dart';

class TarjetaEvidencia extends StatelessWidget {
  final Evidencia evidencia;
  final int indice;

  const TarjetaEvidencia({
    super.key,
    required this.evidencia,
    required this.indice,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Encabezado: número y fecha/hora ---
          Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  child: Text('$indice',
                      style: const TextStyle(fontSize: 12)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    evidencia.fechaFormateada,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                const Icon(Icons.verified, size: 18),
              ],
            ),
          ),

          // --- Fotografía ---
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Image.file(
              File(evidencia.rutaFoto),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const ColoredBox(
                color: Colors.black12,
                child: Center(
                  child: Icon(Icons.broken_image, size: 48),
                ),
              ),
            ),
          ),

          // --- Lectura de sensores ---
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FilaSensor(
                  icono: Icons.speed,
                  titulo: 'Acelerómetro (m/s²)',
                  datos: evidencia.acelerometro.toString(),
                ),
                const SizedBox(height: 6),
                _FilaSensor(
                  icono: Icons.rotate_right,
                  titulo: 'Giroscopio (rad/s)',
                  datos: evidencia.giroscopio.toString(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilaSensor extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String datos;

  const _FilaSensor({
    required this.icono,
    required this.titulo,
    required this.datos,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icono, size: 18, color: Colors.blueGrey),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titulo,
                  style: Theme.of(context).textTheme.labelSmall),
              Text(datos,
                  style: const TextStyle(
                      fontFamily: 'monospace', fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }
}