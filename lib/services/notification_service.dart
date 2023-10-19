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

  void scheduleDailyNotifications(
      String title, String body, DateTime date) async {
    var tzDateNotif = tz.TZDateTime.from(date, tz.local);

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
      await flutterLocalNotificationsPlugin.zonedSchedule(
        10,
        title,
        body,
        tzDateNotif,
        notificationDetails,
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      print('Notification scheduled successfully');
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }

  List<PendingNotificationRequest> pendingNotification = [];
  void pendingNotifications() async {
    print("clicked");
    pendingNotification =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    for (var notification in pendingNotification) {
      print('Scheduled notification: ${notification.title} ');
    }
  }

  void stopNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    print('All Notifications Cancelled');
  }
}








// Function to Show Notifications With Date & Time
 // void showNotifications(title, body) async {
  //   AndroidNotificationDetails androidNotificationDetails =
  //       const AndroidNotificationDetails(
  //     "channelId",
  //     "channelName",
  //     priority: Priority.high,
  //     importance: Importance.max,
  //   );
  //   NotificationDetails notificationDetails =
  //       NotificationDetails(android: androidNotificationDetails);

  //   try {
  //     await flutterLocalNotificationsPlugin.show(
  //       0,
  //       title,
  //       body,
  //       notificationDetails,
  //     );
  //     print('Notification scheduled successfully');
  //   } catch (e) {
  //     print('Error scheduling notification: $e');
  //   }
  // }

  // void scheduleNotifications(
  //     int id, String title, String body, DateTime date) async {
  //   var tzDateNotif = tz.TZDateTime.from(date, tz.local);

  //   AndroidNotificationDetails androidNotificationDetails =
  //       const AndroidNotificationDetails(
  //     "channelId",
  //     "channelName",
  //     priority: Priority.high,
  //     importance: Importance.max,
  //   );
  //   NotificationDetails notificationDetails =
  //       NotificationDetails(android: androidNotificationDetails);

  //   try {
  //     await flutterLocalNotificationsPlugin.zonedSchedule(
  //       id,
  //       title,
  //       body,
  //       tzDateNotif,
  //       notificationDetails,
  //       uiLocalNotificationDateInterpretation:
  //           UILocalNotificationDateInterpretation.absoluteTime,
  //     );
  //     print('Notification scheduled successfully');
  //   } catch (e) {
  //     print('Error scheduling notification: $e');
  //   }
  // }
// Function for periodicallyShow
  // void scheduleperiodicallyNotifications(String title, String body) async {
  //   AndroidNotificationDetails androidNotificationDetails =
  //       const AndroidNotificationDetails(
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
  //       RepeatInterval.daily,
  //       notificationDetails,
  //     );
  //     print('Notification scheduled successfully');
  //   } catch (e) {
  //     print('Error scheduling notification: $e');
  //   }
  // }