import 'package:daily_hadees_app/services/payloadprovider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final BuildContext context;

  NotificationService(this.context);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings _androidInitializationSettings =
      const AndroidInitializationSettings("logo");

  void initializeNotifications() async {
    tz.initializeTimeZones();
    await flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(android: _androidInitializationSettings),
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  String payload = "";
  bool? payloadBool;
  void onDidReceiveNotificationResponse(NotificationResponse details) async {
    payload = details.payload!;
    pendingNotifications();
    if (payload != "") {
      payloadBool = true;
      int? payloadIndex = int.tryParse(payload);
      if (payloadIndex != null) {
        Provider.of<PayloadProvider>(context, listen: false)
            .setPayloadIndex(payloadIndex);
      }
      Provider.of<PayloadProvider>(context, listen: false)
          .setPayload(payloadBool!);
    }
  }

  void scheduleDailyNotifications(
      int id, String title, String urduHadith, DateTime date) async {
    var tzDateNotif = tz.TZDateTime.from(date, tz.local);
    // final String payload = '$initialContent:$fullContent';
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(urduHadith),
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
        payload: id.toString(),
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      pendingNotifications();
    } catch (e) {
      if (kDebugMode) {
        print("Error Scheduling Data");
      }
    }
  }

  List<PendingNotificationRequest> pendingNotification = [];
  void pendingNotifications() async {
    pendingNotification =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    for (var notification in pendingNotification) {
      int hadithIndex = int.tryParse(notification.payload.toString()) ?? 0;
      if (kDebugMode) {
        print(
            "Pending Scheduled Notification: Title: ${notification.title}, ID: ${notification.payload}");
      }
      // ignore: use_build_context_synchronously
      Provider.of<PayloadProvider>(context, listen: false)
          .setHadithIndex(hadithIndex);
    }
  }

  void stopNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
