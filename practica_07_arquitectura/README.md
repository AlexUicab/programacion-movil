# Práctica 07 — Arquitectura Flutter, Componentes, Paquetes y Optimización

Aplicación de ejemplo que demuestra una arquitectura limpia en Flutter usando
`provider` como gestor de estado, `intl` para formateo de fechas, y una serie de
técnicas de optimización de rendimiento (widgets `const`, `ListView.builder`,
`Consumer` localizado, trabajo costoso fuera de `build()`).

---

## Objetivos

- Aplicar una arquitectura por capas: `models`, `services`, `providers`, `screens`, `widgets`.
- Gestionar estado reactivo con `ChangeNotifier` + `ChangeNotifierProvider`.
- Consumir estado de forma eficiente con `Consumer` y `context.watch` / `context.read`.
- Extraer widgets reutilizables y aplicar `const` en todo lo que sea posible.
- Optimizar listas extensas con `ListView.builder`.
- Verificar calidad con `flutter analyze` y pruebas con `flutter test`.

---

## Requisitos

- Flutter SDK `>=3.10` (Material 3)
- Dart `>=3.0`
- Editor: VS Code o Android Studio

Verifica con:

```bash
flutter --version
flutter doctor

Instalación
git clone <url-del-repositorio> practica_07_arquitectura
cd practica_07_arquitectura
flutter pub get

Dependencias principales
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2
  intl: ^0.19.0

Añadidas con:
flutter pub add provider
flutter pub add intl

Estructura del proyecto
practica_07_arquitectura/
├── lib/
│   ├── main.dart                    # MultiProvider + MaterialApp + NavigationBar
│   ├── models/
│   │   └── tarea.dart               # Modelo inmutable con copyWith
│   ├── services/
│   │   └── tarea_service.dart       # Simula API + formateo con intl
│   ├── providers/
│   │   ├── contador_provider.dart   # ChangeNotifier del contador
│   │   └── tarea_provider.dart      # ChangeNotifier de tareas
│   ├── screens/
│   │   ├── home_screen.dart         # ListView.builder con 200 tareas
│   │   └── contador_screen.dart     # Consumer + context.watch
│   └── widgets/
│       ├── encabezado.dart          # Título + subtítulo reutilizable
│       ├── boton_accion.dart        # FilledButton.icon reutilizable
│       └── tarjeta_contador.dart    # Card que solo escucha ContadorProvider
└── test/
    ├── contador_provider_test.dart  # Tests unitarios del contador
    ├── tarea_provider_test.dart     # Tests unitarios de tareas
    └── contador_widget_test.dart    # Test de widget del contador

Ejecución
# Listar destinos disponibles
flutter devices

# Ejecutar en Chrome (Web)
flutter run -d chrome

# Ejecutar en Android / escritorio
flutter run -d <device-id>