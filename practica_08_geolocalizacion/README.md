# 📍 Práctica 08 — Geolocalización en Flutter

Aplicación Flutter que obtiene la ubicación actual del dispositivo usando el paquete `geolocator` y permite abrir las coordenadas en Google Maps mediante `url_launcher`.

---

## 📋 Descripción

La app muestra una pantalla (`UbicacionPage`) con:

- Un botón **"Obtener ubicación"** que solicita permisos y obtiene la posición actual (latitud, longitud y precisión).
- Un botón **"Abrir en mapa"** que abre Google Maps en la aplicación externa con las coordenadas obtenidas.

También maneja los casos de error más comunes:

- Servicio de ubicación desactivado.
- Permiso de ubicación denegado o denegado permanentemente.

---

## 🛠️ Requisitos

- Flutter SDK `>=3.x`
- Dart `>=3.x`
- Dispositivo o emulador con servicios de ubicación (Android / iOS)

---

## 📦 Dependencias

Agrega en tu `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  geolocator: ^12.0.0
  url_launcher: ^6.2.6

dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.4
  plugin_platform_interface: ^2.1.8
```

Luego ejecuta:

```bash
flutter pub get
```

---

## ⚙️ Configuración por plataforma

### Android

En `android/app/src/main/AndroidManifest.xml`, agrega los permisos dentro de `<manifest>`:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.INTERNET"/>
```

> Para `url_launcher` en Android 11+ no se requieren cambios adicionales si se usa `LaunchMode.externalApplication`.

### iOS

En `ios/Runner/Info.plist`, agrega las descripciones de uso:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Esta app necesita tu ubicación para mostrarla en el mapa.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>Esta app necesita tu ubicación para mostrarla en el mapa.</string>
```

Y en `ios/Runner/Info.plist` para `url_launcher`, agrega los esquemas permitidos:

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>https</string>
  <string>http</string>
</array>
```

---

## ▶️ Ejecución

```bash
flutter run
```

1. Presiona **"Obtener ubicación"**.
2. Acepta el permiso de ubicación cuando el sistema lo solicite.
3. Se mostrarán latitud, longitud y precisión.
4. Presiona **"Abrir en mapa"** para ver las coordenadas en Google Maps.

---

## 🧪 Tests

El proyecto incluye tests de widget que mockean `GeolocatorPlatform` para verificar:

1. Estado inicial (`Sin ubicación`).
2. Obtención exitosa de la ubicación (lat/lon/precisión mostradas).
3. Servicio de ubicación desactivado.
4. Permiso de ubicación denegado.

### Ejecutar tests

```bash
flutter test
```

### Ejecutar análisis estático

```bash
flutter analyze
```

### Estructura del test

```dart
class MockGeolocator extends Mock
    with MockPlatformInterfaceMixin
    implements GeolocatorPlatform {}
```

> ⚠️ Importante: usar `MockPlatformInterfaceMixin` es obligatorio, ya que `GeolocatorPlatform` extiende `PlatformInterface` y prohíbe implementaciones directas con `implements`.

---

## 🧩 Estructura del proyecto

```
practica_08_geolocalizacion/
├── lib/
│   └── main.dart              # UI + lógica de ubicación
├── test/
│   └── widget_test.dart       # Tests de widget con mocks
├── pubspec.yaml
└── README.md
```

---

## 🧠 Lógica principal

```dart
Future<void> obtener() async {
  // 1. Verifica que el servicio esté activo
  // 2. Verifica/solicita permiso
  // 3. Obtiene la posición con Geolocator.getCurrentPosition()
  // 4. Actualiza el estado con la posición obtenida
}

Future<void> abrirMapa() async {
  // Abre Google Maps con las coordenadas en la app externa
}
```

---

## 🐞 Problemas comunes

| Problema | Solución |
|---|---|
| `Assertion failed: "Platform interfaces must not be implemented with implements"` | Usar `MockPlatformInterfaceMixin` en la clase mock. |
| `The imported package 'plugin_platform_interface' isn't a dependency` | Agregar `plugin_platform_interface` a `dev_dependencies`. |
| No se obtiene la ubicación en emulador | Configurar una ubicación simulada en el emulador (Extended Controls → Location). |
| `launchUrl` no abre el mapa | Verificar `LSApplicationQueriesSchemes` en iOS y permisos de Internet en Android. |

---

## 📚 Referencias

- [geolocator](https://pub.dev/packages/geolocator)
- [url_launcher](https://pub.dev/packages/url_launcher)
- [mocktail](https://pub.dev/packages/mocktail)
- [plugin_platform_interface](https://pub.dev/packages/plugin_platform_interface)

---

## 👤 Autor

- **Nombre:** _(tu nombre)_
- **Materia:** Prácticas Móvil
- **Práctica:** 08 — Geolocalización