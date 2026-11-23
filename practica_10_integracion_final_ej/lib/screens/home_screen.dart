import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../models/country.dart';
import 'destination_form_screen.dart';
import 'destinations_view.dart';
import 'explore_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  final _listKey = GlobalKey<DestinationsViewState>();

  Future<void> _openForm({Country? country}) async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => DestinationFormScreen(
          initialName: country == null
              ? null
              : (country.capital != '—' ? country.capital : country.name),
          initialNotes: country == null ? null : 'País: ${country.name}. ',
          initialLat: country?.latitude,
          initialLng: country?.longitude,
        ),
      ),
    );
    if (saved == true) {
      setState(() => _index = 0);
      _listKey.currentState?.reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_index == 0 ? AppConstants.appName : 'Explorar países'),
      ),
      body: IndexedStack(
        index: _index,
        children: [
          DestinationsView(key: _listKey),
          ExploreView(onSelect: (c) => _openForm(country: c)),
        ],
      ),
      floatingActionButton: _index == 0
          ? FloatingActionButton.extended(
              onPressed: () => _openForm(),
              icon: const Icon(Icons.add_location_alt),
              label: const Text('Nuevo destino'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.luggage_outlined),
              selectedIcon: Icon(Icons.luggage),
              label: 'Mis destinos'),
          NavigationDestination(
              icon: Icon(Icons.public_outlined),
              selectedIcon: Icon(Icons.public),
              label: 'Explorar'),
        ],
      ),
    );
  }
}
