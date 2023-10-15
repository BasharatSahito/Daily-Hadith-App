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

  TimeOfDay? testTime;

  void selectTime() async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      // User has selected a time, schedule the notification.
      notificationService.scheduleNotifications(
          "Zoned Schedule", "This is a Zoned Schedule body", selectedTime);
      setState(() {
        testTime = selectedTime;
      });
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
          Text(testTime.toString()),
          ElevatedButton(
            onPressed: () {
              selectTime();
            },
            child: const Text("Select Time"),
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
