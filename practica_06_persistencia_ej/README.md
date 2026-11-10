
---

# README — Ejercicio Evaluable · "Gestor de Tareas Offline"

```markdown
# Gestor de Tareas Offline

Aplicación Flutter **evaluable** que implementa un gestor completo de tareas
con SQLite. Funciona al 100 % sin Internet y persiste la preferencia de
interfaz (filtro y nombre de usuario) con `SharedPreferences`.

---

## Requisitos cubiertos

| Requisito | Estado |
|-----------|--------|
| Crear tareas | ✅ |
| Consultar tareas | ✅ (con filtros) |
| Editar tareas | ✅ |
| Eliminar tareas | ✅ (con confirmación) |
| Marcar completada | ✅ (checkbox) |
| Preferencia UI persistente | ✅ (filtro + nombre) |
| Funciona sin Internet | ✅ |

---

## Stack

| Paquete | Uso |
|---------|-----|
| `sqflite` | Base de datos SQLite local |
| `shared_preferences` | Filtro seleccionado + nombre de usuario |
| `path` | Construcción de rutas de la BD |
| `intl` | Formato de fechas en la UI |

---

## Estructura del Proyecto
gestor_tareas/
├── pubspec.yaml
└── lib/
├── main.dart
├── models/
│ └── tarea.dart
├── database/
│ └── db_tareas.dart
├── services/
│ └── prefs_service.dart
└── screens/
└── tareas_screen.dart


---

## ⚙️ Instalación

```bash
git clone <repo>
cd gestor_tareas
flutter pub get
flutter run

Dependencias:
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.2.3
  sqflite: ^2.3.3
  path: ^1.9.0
  intl: ^0.19.0


Esquema de la Base de Datos
CREATE TABLE tareas(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  titulo TEXT NOT NULL,
  descripcion TEXT,
  completada INTEGER DEFAULT 0,
  actualizado_en INTEGER NOT NULL
);

