import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  factory NotificationService() => _instance;

  NotificationService._internal();

  Future<void> init() async {
    if (kIsWeb || Platform.environment.containsKey('FLUTTER_TEST')) return;
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    final dynamic plugin = flutterLocalNotificationsPlugin;
    await plugin.initialize(initializationSettings);
  }

  Future<void> showNotification(int id, String title, String body, {bool silent = false}) async {
    if (silent || kIsWeb || Platform.environment.containsKey('FLUTTER_TEST')) return;
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'masar_channel',
      'Masar Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    final dynamic plugin = flutterLocalNotificationsPlugin;
    await plugin.show(id, title, body, platformChannelSpecifics);
  }

  Future<void> scheduleNotification(int id, String title, String body, DateTime scheduledTime, {bool silent = false}) async {
    if (silent || kIsWeb || Platform.environment.containsKey('FLUTTER_TEST')) return;
    final dynamic plugin = flutterLocalNotificationsPlugin;
    await plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails('masar_channel', 'Masar Notifications'),
      ),
      androidScheduleMode: (dynamic as dynamic).AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: (dynamic as dynamic).UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
