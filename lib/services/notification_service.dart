import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings _androidInitializationSettings =
      const AndroidInitializationSettings("flutter_logo");

  void initializeNotifications() async {
    tz.initializeTimeZones();
    await flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(android: _androidInitializationSettings),
    );
  }

  void showNotifications(title, body) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      "channelId",
      "channelName",
      priority: Priority.high,
      importance: Importance.max,
    );
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    try {
      await flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        notificationDetails,
      );
      print('Notification scheduled successfully');
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }

  // void scheduleNotifications(String title, String body) async {
  //   AndroidNotificationDetails androidNotificationDetails =
  //     const AndroidNotificationDetails(
  //     "channelId",
  //     "channelName",
  //     priority: Priority.high,
  //     importance: Importance.max,
  //   );
  //   NotificationDetails notificationDetails =
  //       NotificationDetails(android: androidNotificationDetails);

  //   try {
  //     await flutterLocalNotificationsPlugin.periodicallyShow(
  //       10,
  //       title,
  //       body,
  //       RepeatInterval.everyMinute,
  //       notificationDetails,
  //     );
  //     print('Notification scheduled successfully');
  //   } catch (e) {
  //     print('Error scheduling notification: $e');
  //   }
  // }

  void scheduleNotifications(
      String title, String body, TimeOfDay notificationTime) async {
    final int hour = notificationTime.hour;
    final int minute = notificationTime.minute;

    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      "channelId",
      "channelName",
      priority: Priority.high,
      importance: Importance.max,
    );
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    final DateTime now = DateTime.now();
    final DateTime scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        1,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents:
            DateTimeComponents.time, // Set this to repeat daily
      );
      print('Notification scheduled successfully');
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }

  void stopNotification() async {
    flutterLocalNotificationsPlugin.cancel(10);
  }

  void pendingNotifications() async {
    print("clicked");
    final List<PendingNotificationRequest> pendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    for (var notification in pendingNotifications) {
      print('Scheduled notification: ${notification.title} ');
    }
  }
}
