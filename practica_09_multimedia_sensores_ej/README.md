# Bitácora de Inspección

Aplicación Flutter que permite **capturar evidencia fotográfica** de una inspección, registrando automáticamente la **fecha/hora** y los **valores actuales del acelerómetro y giroscopio** del dispositivo. Cada captura se presenta como una **tarjeta de evidencia** con todos los datos asociados.

Ideal para auditorías de campo, mantenimiento industrial, inspecciones de seguridad o cualquier escenario donde se necesite dejar constancia verificable de un estado físico.

---

## Características

- **Captura de fotografía** con la cámara del dispositivo.
- **Timestamp automático** con formato `dd/MM/yyyy HH:mm:ss`.
- **Lectura de sensores en tiempo real**:
  - Acelerómetro (m/s²) — ejes X, Y, Z
  - Giroscopio (rad/s) — ejes X, Y, Z
- **Lista de evidencias** presentadas como tarjetas con foto, fecha y lecturas.
- **Manejo de cancelación**: si el usuario cancela la cámara, no se registra evidencia (SnackBar informativo).
- **Manejo de permisos**: diálogo específico cuando el acceso a la cámara es denegado.
- **Ciclo de vida correcto**: los streams de sensores se cancelan al salir de la pantalla.
- **Tolerancia a fallos**: aviso si el sensor no está disponible en el dispositivo.

---

## Arquitectura

El proyecto sigue una separación por capas para facilitar el testing y la escalabilidad:
lib/
├── main.dart # Punto de entrada
├── models/
│ ├── sensor_data.dart # Lectura X/Y/Z de un sensor
│ └── evidencia.dart # Agrupa foto + timestamp + sensores
├── services/
│ ├── sensor_service.dart # Streams de acelerómetro y giroscopio
│ └── camara_service.dart # Encapsula ImagePicker
└── pages/
├── bitacora_page.dart # UI principal + lógica de captura
└── tarjeta_evidencia.dart # Widget de tarjeta de evidencia


---

## Instalación

### Requisitos previos

- Flutter SDK `>=3.0.0`
- Dart `>=3.0.0`
- Dispositivo físico (la cámara no funciona igual en emuladores)

### Pasos

```bash
# 1. Clonar el repositorio
git clone https://github.com/tu-usuario/bitacora-inspeccion.git
cd bitacora-inspeccion

# 2. Instalar dependencias
flutter pub get

# 3. Ejecutar en dispositivo físico
flutter run

Dependencias principales
dependencies:
  flutter:
    sdk: flutter
  image_picker: ^1.0.4
  sensors_plus: ^4.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.4