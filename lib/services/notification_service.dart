import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings _androidInitializationSettings =
      const AndroidInitializationSettings("logo");

  void initializeNotifications() async {
    tz.initializeTimeZones();
    await flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(android: _androidInitializationSettings),
      // onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  // void onDidReceiveNotificationResponse(NotificationResponse details) async {
  //   final String? payload = details.payload;
  //   String initialContent = "Default Content";
  //   String fullContent = "Default Content";
  //   if (payload != null) {
  //     final List<String> parts = payload.split(':');
  //     if (parts.length == 2) {
  //       initialContent = parts[0];
  //       fullContent = parts[1];

  //       // Now you have the title and body to work with
  //       print(
  //           'Received Notification - Title: $initialContent, Body: $fullContent');
  //     }
  //   }

  //   final String? actionId = details.actionId;
  //   if (actionId == "action_id") {
  //     print("PRESSED");

  //     AndroidNotificationDetails updatedAndroidNotificationDetails =
  //         AndroidNotificationDetails(
  //       "channelId",
  //       "channelName",
  //       priority: Priority.high,
  //       importance: Importance.max,
  //       styleInformation: BigTextStyleInformation(initialContent + fullContent),
  //       actions: [
  //         const AndroidNotificationAction(
  //           'action_id', // Action ID
  //           'Expanded', // Action button label
  //           cancelNotification: false,
  //         ),
  //       ],
  //     );

  //     NotificationDetails updatedNotificationDetails =
  //         NotificationDetails(android: updatedAndroidNotificationDetails);

  //     await flutterLocalNotificationsPlugin.show(
  //       0, // Same notification ID
  //       "Daily Hadees",
  //       initialContent,
  //       updatedNotificationDetails, // Use the updated notification details
  //     );
  //   }
  //   print('Pressed Action Button: ${actionId}');
  // }

  // void showNotifications(title, body) async {
  //   AndroidNotificationDetails androidNotificationDetails =
  //       const AndroidNotificationDetails(
  //     "channelId",
  //     "channelName",
  //     priority: Priority.high,
  //     importance: Importance.max,
  //     actions: [
  //       AndroidNotificationAction(
  //         'action_id', // Action ID
  //         'Test Button', // Action button label
  //         showsUserInterface: true,
  //         cancelNotification: false,
  //       ),
  //     ],
  //   );
  //   NotificationDetails notificationDetails =
  //       NotificationDetails(android: androidNotificationDetails);

  //   try {
  //     await flutterLocalNotificationsPlugin.show(
  //       0,
  //       title,
  //       body,
  //       notificationDetails,
  //       payload: body,
  //     );
  //     print('Notification scheduled successfully');
  //   } catch (e) {
  //     print('Error scheduling notification: $e');
  //   }
  // }

  void scheduleDailyNotifications(
      String title, String urduHadith, DateTime date) async {
    var tzDateNotif = tz.TZDateTime.from(date, tz.local);
    // final String payload = '$initialContent:$fullContent';
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channelId', 'channelName',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(urduHadith),
      //     actions: [
      //   const AndroidNotificationAction(
      //     "action_id",
      //     "Expand",
      //     showsUserInterface: true,
      //   )
      // ],
    );
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        10,
        title,
        urduHadith,
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
