import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/contador_provider.dart';

class TarjetaContador extends StatelessWidget {
  const TarjetaContador({super.key});

  @override
  Widget build(BuildContext context) {
    // context.watch → SOLO este widget se reconstruye con el cambio
    final valor = context.watch<ContadorProvider>().valor;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text('$valor',
            style: Theme.of(context).textTheme.displayLarge),
      ),
    );
  }
}