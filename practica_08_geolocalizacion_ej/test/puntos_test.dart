import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'package:practica_08_geolocalizacion_ej/main.dart';

class MockGeolocator extends Mock
    with MockPlatformInterfaceMixin
    implements GeolocatorPlatform {}

Position _pos({double lat = 19.4326, double lon = -99.1332}) => Position(
      latitude: lat,
      longitude: lon,
      timestamp: DateTime.now(),
      accuracy: 5.0,
      altitude: 0.0,
      altitudeAccuracy: 0.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    );

void main() {
  late MockGeolocator mockGeo;

  setUpAll(() {
    registerFallbackValue(LocationAccuracy.high);
  });

  setUp(() {
  mockGeo = MockGeolocator();
  GeolocatorPlatform.instance = mockGeo;

  // 👇 Agrega esto
  when(() => mockGeo.distanceBetween(
        any(), any(), any(), any(),
      )).thenReturn(1234.5); // metros de prueba
});

  testWidgets('Estado inicial', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PuntosPage()));
    expect(find.text('Sin ubicación'), findsOneWidget);
    expect(find.text('Aún no hay puntos guardados'), findsOneWidget);
  });

  testWidgets('Obtiene ubicación', (tester) async {
    when(() => mockGeo.isLocationServiceEnabled())
        .thenAnswer((_) async => true);
    when(() => mockGeo.checkPermission())
        .thenAnswer((_) async => LocationPermission.whileInUse);
    when(() => mockGeo.getCurrentPosition(
          locationSettings: any(named: 'locationSettings'),
        )).thenAnswer((_) async => _pos());

    await tester.pumpWidget(const MaterialApp(home: PuntosPage()));
    await tester.tap(find.text('Obtener ubicación'));
    await tester.pumpAndSettle();

    expect(find.text('Ubicación obtenida'), findsOneWidget);
    expect(find.textContaining('Latitud: 19.432600'), findsOneWidget);
  });

  testWidgets('Agrega un punto y muestra distancia', (tester) async {
    when(() => mockGeo.isLocationServiceEnabled())
        .thenAnswer((_) async => true);
    when(() => mockGeo.checkPermission())
        .thenAnswer((_) async => LocationPermission.whileInUse);
    when(() => mockGeo.getCurrentPosition(
          locationSettings: any(named: 'locationSettings'),
        )).thenAnswer((_) async => _pos());

    await tester.pumpWidget(const MaterialApp(home: PuntosPage()));
    await tester.tap(find.text('Obtener ubicación'));
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('Agregar'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'CETI');
    await tester.enterText(find.byType(TextField).at(1), '19.4400');
    await tester.enterText(find.byType(TextField).at(2), '-99.1400');

    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('CETI'), findsOneWidget);
    expect(find.textContaining('Distancia:'), findsOneWidget);
  });

  testWidgets('No permite más de 3 puntos', (tester) async {
    when(() => mockGeo.isLocationServiceEnabled())
        .thenAnswer((_) async => true);
    when(() => mockGeo.checkPermission())
        .thenAnswer((_) async => LocationPermission.whileInUse);
    when(() => mockGeo.getCurrentPosition(
          locationSettings: any(named: 'locationSettings'),
        )).thenAnswer((_) async => _pos());

    await tester.pumpWidget(const MaterialApp(home: PuntosPage()));
    await tester.tap(find.text('Obtener ubicación'));
    await tester.pumpAndSettle();

    for (var i = 1; i <= 3; i++) {
      await tester.tap(find.textContaining('Agregar'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).at(0), 'P$i');
      await tester.enterText(find.byType(TextField).at(1), '19.4$i');
      await tester.enterText(find.byType(TextField).at(2), '-99.1$i');
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();
    }

    expect(find.text('P1'), findsOneWidget);
    expect(find.text('P2'), findsOneWidget);
    expect(find.text('P3'), findsOneWidget);
  });
}