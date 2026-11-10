import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// Ajusta el import a tu archivo real
import 'package:practica_08_geolocalizacion/main.dart';

class MockGeolocator extends Mock 
    with MockPlatformInterfaceMixin 
    implements GeolocatorPlatform {}

void main() {
  late MockGeolocator mockGeolocator;

  setUpAll(() {
    registerFallbackValue(LocationAccuracy.high);
  });

  setUp(() {
    mockGeolocator = MockGeolocator();
    GeolocatorPlatform.instance = mockGeolocator;
  });

  testWidgets('Muestra el estado inicial sin ubicación', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: UbicacionPage()));

    expect(find.text('Sin ubicación'), findsOneWidget);
    expect(find.text('Latitud:'), findsNothing);
    expect(find.text('Obtener ubicación'), findsOneWidget);
    expect(find.text('Abrir en mapa'), findsOneWidget);
  });

  testWidgets('Obtiene y muestra la ubicación correctamente', (tester) async {
    when(() => mockGeolocator.isLocationServiceEnabled())
        .thenAnswer((_) async => true);
    when(() => mockGeolocator.checkPermission())
        .thenAnswer((_) async => LocationPermission.whileInUse);
    when(() => mockGeolocator.getCurrentPosition(
          locationSettings: any(named: 'locationSettings'),
        )).thenAnswer((_) async => Position(
          latitude: 19.4326,
          longitude: -99.1332,
          timestamp: DateTime.now(),
          accuracy: 5.0,
          altitude: 0.0,
          altitudeAccuracy: 0.0,
          heading: 0.0,
          headingAccuracy: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
        ));

    await tester.pumpWidget(const MaterialApp(home: UbicacionPage()));

    await tester.tap(find.text('Obtener ubicación'));
    await tester.pumpAndSettle();

    expect(find.text('Ubicación obtenida'), findsOneWidget);
    expect(find.text('Latitud: 19.4326'), findsOneWidget);
    expect(find.text('Longitud: -99.1332'), findsOneWidget);
    expect(find.text('Precisión: 5.0 m'), findsOneWidget);
  });

  testWidgets('Muestra mensaje cuando el servicio está desactivado',
      (tester) async {
    when(() => mockGeolocator.isLocationServiceEnabled())
        .thenAnswer((_) async => false);

    await tester.pumpWidget(const MaterialApp(home: UbicacionPage()));

    await tester.tap(find.text('Obtener ubicación'));
    await tester.pumpAndSettle();

    expect(find.text('Activa el servicio de ubicación'), findsOneWidget);
  });

  testWidgets('Muestra mensaje cuando el permiso es denegado',
      (tester) async {
    when(() => mockGeolocator.isLocationServiceEnabled())
        .thenAnswer((_) async => true);
    when(() => mockGeolocator.checkPermission())
        .thenAnswer((_) async => LocationPermission.denied);
    when(() => mockGeolocator.requestPermission())
        .thenAnswer((_) async => LocationPermission.denied);

    await tester.pumpWidget(const MaterialApp(home: UbicacionPage()));

    await tester.tap(find.text('Obtener ubicación'));
    await tester.pumpAndSettle();

    expect(find.text('Permiso de ubicación no disponible'), findsOneWidget);
  });
}