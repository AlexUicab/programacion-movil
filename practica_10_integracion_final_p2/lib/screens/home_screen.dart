import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../services/database_service.dart';
import 'api_screen.dart';
import 'report_form_screen.dart';
import 'report_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _loadCount();
  }

  Future<void> _loadCount() async {
    final c = await DatabaseService.instance.count();
    if (mounted) setState(() => _count = c);
  }

  Future<void> _go(Widget screen) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    _loadCount();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.appName)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(children: [
              Icon(Icons.assignment_outlined,
                  size: 48, color: cs.onPrimaryContainer),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Reporta incidencias con foto, ubicación y fecha. '
                  'Todo se guarda en tu dispositivo, aun sin internet.\n\n'
                  'Reportes guardados: $_count',
                  style: TextStyle(color: cs.onPrimaryContainer),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          _MenuTile(
            icon: Icons.add_a_photo_outlined,
            title: 'Nuevo reporte',
            subtitle: 'Captura foto, ubicación y detalles',
            onTap: () => _go(const ReportFormScreen()),
          ),
          _MenuTile(
            icon: Icons.list_alt,
            title: 'Mis reportes',
            subtitle: 'Disponibles sin conexión',
            onTap: () => _go(const ReportListScreen()),
          ),
          _MenuTile(
            icon: Icons.campaign_outlined,
            title: 'Avisos de la comunidad',
            subtitle: 'Datos desde una API REST',
            onTap: () => _go(const ApiScreen()),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Icon(icon, size: 32),
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      );
}
