import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/formatters.dart';
import '../models/destination.dart';

class DestinationCard extends StatelessWidget {
  final Destination destination;
  final VoidCallback onTap;

  const DestinationCard(
      {super.key, required this.destination, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final d = destination;
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: cs.primaryContainer,
          child: Icon(AppConstants.iconFor(d.category),
              color: cs.onPrimaryContainer),
        ),
        title: Text(d.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          '${d.category} · ${formatDate(d.visitDate)}\n'
          'Presupuesto: ${formatMoney(d.budget)}',
        ),
        isThreeLine: true,
        trailing: Icon(
          d.visited ? Icons.check_circle : Icons.schedule,
          color: d.visited ? Colors.green : Colors.grey,
          semanticLabel: d.visited ? 'Visitado' : 'Pendiente',
        ),
      ),
    );
  }
}
