# Notas Offline

Aplicación Flutter que demuestra **persistencia local** y **funcionamiento offline**
usando `sqflite` (SQLite) y `shared_preferences`. Incluye una **bandera de
sincronización** para preparar la app frente a un futuro backend.

---

##  Objetivo

- Guardar notas localmente y consultarlas sin conexión a Internet.
- Recordar el nombre del usuario entre sesiones.
- Identificar visualmente las notas **pendientes de sincronizar** con un servidor.

---

## Stack

| Paquete | Uso |
|---------|-----|
| `sqflite` | Base de datos SQLite local |
| `shared_preferences` | Preferencias clave-valor (nombre de usuario) |
| `path` | Construcción de rutas de la BD |

---

## Estructura del Proyecto
├── pubspec.yaml
└── lib/
├── main.dart
├── database/
│ └── db.dart
├── services/
│ └── prefs_service.dart
└── screens/
└── notas_screen.dart

Dependencias requeridas en pubspec.yaml:
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.2.3
  sqflite: ^2.3.3
  path: ^1.9.0

Esquema de la Base de Datos
CREATE TABLE notas(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  titulo TEXT,
  contenido TEXT,
  pendiente_sincronizar INTEGER DEFAULT 1
);


Funcionalidades
CRUD de notas
Crear — formulario con título y contenido
Leer — listado ordenado por id DESC
Actualizar — tocar una nota carga sus datos en el formulario
Eliminar — con diálogo de confirmación
