import 'package:flutter_test/flutter_test.dart';
import 'package:reporte_movil/models/incident.dart';

void main() {
  test('Incident se serializa y deserializa correctamente', () {
    final original = Incident(
      id: 1,
      title: 'Bache grande',
      description: 'Bache frente a la escuela primaria',
      category: 'Infraestructura',
      photoPath: '/tmp/foto.jpg',
      latitude: 20.1234,
      longitude: -89.5678,
      createdAt: DateTime(2026, 11, 19, 10, 30),
      synced: true,
    );
    final copy = Incident.fromMap(original.toMap());
    expect(copy.title, original.title);
    expect(copy.latitude, original.latitude);
    expect(copy.createdAt, original.createdAt);
    expect(copy.synced, true);
  });
}
