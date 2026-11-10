import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/contador_provider.dart';
import '../widgets/encabezado.dart';
import '../widgets/boton_accion.dart';
import '../widgets/tarjeta_contador.dart';

class ContadorScreen extends StatelessWidget {
  const ContadorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contador con Provider')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Encabezado(
              titulo: 'Contador',
              subtitulo: 'ChangeNotifier + Consumer',
            ),
            const SizedBox(height: 24),
            Center(
              child: Consumer<ContadorProvider>(
                builder: (context, p, _) => TarjetaContador(),
              ),
            ),
            const SizedBox(height: 24),
            // Consumer SOLO para los botones (evita reconstruir el encabezado)
            Consumer<ContadorProvider>(
              builder: (context, p, _) => Wrap(
                spacing: 12,
                children: [
                  BotonAccion(
                    texto: 'Incrementar',
                    icono: Icons.add,
                    onPressed: p.incrementar,
                  ),
                  BotonAccion(
                    texto: 'Reiniciar',
                    icono: Icons.refresh,
                    onPressed: p.reiniciar,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}