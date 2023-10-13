import 'dart:async';

import 'package:daily_hadees_app/services/notification_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    notificationService.initializeNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification Testing"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Timer.periodic(const Duration(seconds: 3), (timer) {
                    notificationService.showNotifications("Test Notification",
                        "This is a First Test Notitifcation");
                  });
                },
                child: const Text("Show Notification")),
            // ElevatedButton(
            //     onPressed: () {
            //       notificationService.scheduleNotifications(
            //         "Test",
            //         "This is a body Test Notitifcation",
            //         DateTime.now().add(const Duration(seconds: 3)),
            //       );
            //     },
            //     child: const Text("Schedule Notification")),
          ],
        ),
      ),
    );
  }
}
