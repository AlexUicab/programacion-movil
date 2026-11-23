import 'dart:io';

import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/date_utils.dart';
import '../models/incident.dart';

class IncidentCard extends StatelessWidget {
  final Incident incident;
  final VoidCallback onTap;

  const IncidentCard({super.key, required this.incident, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 64,
            height: 64,
            child: Image.file(
              File(incident.photoPath),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const ColoredBox(
                color: Colors.black12,
                child: Icon(Icons.broken_image),
              ),
            ),
          ),
        ),
        title:
            Text(incident.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              Icon(AppConstants.iconFor(incident.category), size: 14),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${incident.category} · ${formatDateTime(incident.createdAt)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        trailing: Icon(
          incident.synced ? Icons.cloud_done : Icons.cloud_off,
          color: incident.synced ? Colors.green : Colors.grey,
          semanticLabel: incident.synced ? 'Sincronizado' : 'Pendiente',
        ),
      ),
    );
  }
}
