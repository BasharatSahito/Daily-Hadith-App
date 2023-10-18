import 'dart:convert';
import 'package:daily_hadees_app/Models/hadithmodel.dart';
import 'package:daily_hadees_app/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    getHadith();
  }

  List<HadithModel> hadithList = [];
  Future<void> getHadith() async {
    try {
      String jsonString = await rootBundle.loadString("assets/hadiths.json");
      List<dynamic> jsonResponse = jsonDecode(jsonString);
      List<HadithModel> loadedHadith = jsonResponse
          .map((dynamic data) => HadithModel.fromJson(data))
          .toList();
      setState(() {
        hadithList = loadedHadith;
      });
    } catch (e) {
      debugPrint("Error Loading Data ${e.toString()}");
    }
  }

  // void selectTime() async {
  //   TimeOfDay? selectedTime = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   );
  //   if (selectedTime != null) {
  //     // User has selected a time, schedule the notification.
  //     for (int i = 0; i < hadithList.length; i++) {
  //       int id = i; // You can use a unique ID for each notification
  //       String title = hadithList[i].title.toString();
  //       String body = hadithList[i].content.toString();

  //       notificationService.scheduleNotifications(
  //           id, title, body, selectedTime);
  //     }
  //   }
  // }

  void fetchNotifications() async {
    for (var data in hadithList) {
      final date = DateTime.parse(data.date.toString());
      notificationService.scheduleNotifications(
          data.id!, data.title.toString(), data.content.toString(), date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Hadees"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              // selectTime();
              fetchNotifications();
            },
            child: const Text("Schedule"),
          ),
          ElevatedButton(
            onPressed: () {
              notificationService.pendingNotifications();
            },
            child: const Text("Show Pending Notifications"),
          ),
          hadithList.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: hadithList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(hadithList[index].title ?? "No Title"),
                        subtitle:
                            Text(hadithList[index].content ?? "No Content"),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
