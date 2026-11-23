import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/formatters.dart';
import '../models/country.dart';
import '../services/api_service.dart';
import '../widgets/state_views.dart';

/// Sección que consume la API REST de países.
class ExploreView extends StatefulWidget {
  final void Function(Country) onSelect;
  const ExploreView({super.key, required this.onSelect});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  String _region = 'americas';
  late Future<List<Country>> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.instance.fetchCountries(_region);
  }

  void _load() =>
      setState(() => _future = ApiService.instance.fetchCountries(_region));

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 56,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          children: AppConstants.regions.entries
              .map((e) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(e.value),
                      selected: _region == e.key,
                      onSelected: (_) {
                        _region = e.key;
                        _load();
                      },
                    ),
                  ))
              .toList(),
        ),
      ),
      Expanded(
        child: FutureBuilder<List<Country>>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return ErrorView(message: snap.error.toString(), onRetry: _load);
            }
            final list = snap.data!;
            if (list.isEmpty) {
              return const EmptyState(
                  icon: Icons.public_off, message: 'Sin resultados.');
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: list.length,
              itemBuilder: (_, i) {
                final c = list[i];
                return Card(
                  child: ListTile(
                    leading:
                        Text(c.flag, style: const TextStyle(fontSize: 28)),
                    title: Text(c.name),
                    subtitle: Text(
                        'Capital: ${c.capital} · ${formatCompact(c.population)} hab.'),
                    trailing: const Icon(Icons.add_location_alt_outlined),
                    onTap: () => widget.onSelect(c),
                  ),
                );
              },
            );
          },
        ),
      ),
    ]);
  }
}
