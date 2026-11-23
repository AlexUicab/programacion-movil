import 'package:flutter/material.dart';

import '../models/destination.dart';
import '../services/database_service.dart';
import '../widgets/destination_card.dart';
import '../widgets/state_views.dart';
import 'destination_detail_screen.dart';

/// Lista de destinos guardados (disponible sin conexión).
class DestinationsView extends StatefulWidget {
  const DestinationsView({super.key});

  @override
  State<DestinationsView> createState() => DestinationsViewState();
}

class DestinationsViewState extends State<DestinationsView> {
  List<Destination> _items = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    reload();
  }

  Future<void> reload() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await DatabaseService.instance.getAll();
      if (mounted) setState(() => _items = data);
    } catch (_) {
      if (mounted) setState(() => _error = 'No se pudieron leer los destinos.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _open(Destination d) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DestinationDetailScreen(destination: d)),
    );
    reload();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return ErrorView(message: _error!, onRetry: reload);
    if (_items.isEmpty) {
      return const EmptyState(
        icon: Icons.luggage_outlined,
        message:
            'Aún no tienes destinos.\nToca "Nuevo destino" o elige uno desde Explorar.',
      );
    }
    return RefreshIndicator(
      onRefresh: reload,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
        itemCount: _items.length,
        itemBuilder: (_, i) =>
            DestinationCard(destination: _items[i], onTap: () => _open(_items[i])),
      ),
    );
  }
}
