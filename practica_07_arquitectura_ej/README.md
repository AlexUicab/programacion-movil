# Práctica 07 — Arquitectura Flutter, Provider y Consumo REST

Refactorización de una aplicación que consumía una API REST con `FutureBuilder`
y estado local (`setState`), migrada a una arquitectura por capas con
`provider` como gestor de estado y `intl` como paquete externo para formateo
localizado de fechas.

---

## Objetivos

- Aplicar una arquitectura por capas: `models`, `services`, `providers`, `screens`, `widgets`.
- Reemplazar `FutureBuilder` + `setState` por `ChangeNotifier` + `ChangeNotifierProvider`.
- Consumir estado de forma eficiente con `context.watch` y `context.read`.
- Extraer widgets reutilizables y aplicar `const` en todo lo posible.
- Incorporar al menos un paquete externo útil (`intl`).
- Verificar calidad con `flutter analyze` y `flutter test`.
- Documentar una comparación breve entre Flutter y una solución nativa hipotética.

---

## Requisitos

- Flutter SDK `>=3.10` (Material 3)
- Dart `>=3.0`
- Conexión a Internet (se consume `jsonplaceholder.typicode.com`)
- Editor: VS Code o Android Studio

Verifica con:

```bash
flutter --version
flutter doctor

Dependencias principales
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2
  intl: ^0.19.0
  http: ^1.2.0

Añadidas con:
flutter pub add provider intl http

Estructura del proyecto
practica_07_usuarios/
├── lib/
│   ├── main.dart                    # ChangeNotifierProvider + MaterialApp
│   ├── models/
│   │   └── usuario.dart             # Modelo inmutable con fromJson
│   ├── services/
│   │   └── usuario_service.dart     # Cliente HTTP + parseo JSON
│   ├── providers/
│   │   └── usuario_provider.dart    # ChangeNotifier con estado de carga
│   ├── screens/
│   │   └── usuarios_screen.dart     # UI principal con ListView.builder
│   └── widgets/
│       ├── usuario_tile.dart        # Tile reutilizable por usuario
│       └── estado_vacio.dart        # Placeholder reutilizable
└── test/
    └── usuario_provider_test.dart   # Tests unitarios con fake del servicio

Ejecución
# Listar destinos disponibles
flutter devices

# Ejecutar en Chrome (Web)
flutter run -d chrome

# Ejecutar en Android / escritorio
flutter run -d <device-id>