# Práctica 05 - API REST

Aplicación Flutter que consume la API pública de [JSONPlaceholder](https://jsonplaceholder.typicode.com/users) para mostrar una lista de usuarios.

## Características
- Petición HTTP usando el paquete `http`.
- Parseo de JSON a un modelo de datos (`Usuario`).
- Manejo de estados de carga (`CircularProgressIndicator`) y errores.
- Soporte para recargar la lista deslizando hacia abajo (Pull-to-refresh).

## Estructura del proyecto
- `lib/main.dart`: Contiene toda la lógica (Modelo, Vista y Controlador).
- `test/widget_test.dart`: Pruebas unitarias y de interfaz.

## Ejecución
1. Instala las dependencias:
   ```bash
   flutter pub get