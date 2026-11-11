# Práctica 08: App de Puntos de Interés (POI)

Aplicación Flutter desarrollada como ejercicio evaluable para la materia de Prácticas Móviles. La app obtiene la ubicación actual del dispositivo, permite guardar hasta tres puntos de interés (POI) con nombre y coordenadas, calcula la distancia entre el usuario y cada punto, y ofrece acceso a un mapa externo.

---

## Características

- **Ubicación en tiempo real**: Obtiene latitud, longitud y precisión usando el GPS del dispositivo.
- **Gestión de Puntos de Interés**:
  - Permite guardar hasta **3 puntos** con nombre personalizado.
  - Valida que las coordenadas ingresadas estén en rangos correctos (Lat: -90 a 90, Lon: -180 a 180).
- **Cálculo de distancias**: Utiliza `Geolocator.distanceBetween` para mostrar la distancia exacta (en metros o kilómetros) desde tu ubicación actual a cada punto guardado.
- **Mapa externo**: Abre la ubicación del punto seleccionado en Google Maps.
- **Manejo de errores**: Notifica al usuario si el GPS está apagado o si los permisos son denegados.

---

## Requisitos y Dependencias

Agrega las siguientes dependencias en tu `pubspec.yaml`:

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
  flutter_lints: ^3.0.0

