import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notificaciones {
  static final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> iniciar() async {
    const AndroidInitializationSettings android =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(
      android: android,
    );

    await plugin.initialize(settings: settings);
  }

  static Future<void> mostrar() async {
    const NotificationDetails detalles =
        NotificationDetails(
      android: AndroidNotificationDetails(
        'canal_practica',
        'Práctica móvil',
        channelDescription: 'Alertas de la aplicación',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    await plugin.show(
      id: 1,
      title: 'Tópicos de Programación Móvil',
      body: 'Tienes una actividad pendiente',
      notificationDetails: detalles,
    );
  }
}