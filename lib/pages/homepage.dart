import 'dart:convert';
import 'package:daily_hadees_app/Models/hadithmodel.dart';
import 'package:daily_hadees_app/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    scheduleNotifications();
    notificationService.pendingNotifications();
  }

// Fetching the Hadith from Hadith.JSON into hadithList
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

  void scheduleNotifications() async {
    TimeOfDay? selectedTime =
        const TimeOfDay(hour: 22, minute: 39); // Set your fixed time
    DateTime now = DateTime.now();
    DateTime scheduledDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    // Get the current index from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentIndex = prefs.getInt('currentIndex') ?? 0;

    // Get the last scheduled date from SharedPreferences
    DateTime lastScheduledDate = DateTime.fromMillisecondsSinceEpoch(
        prefs.getInt('lastScheduledDate') ?? 0);

    // Check if the date has changed
    if (scheduledDateTime.difference(lastScheduledDate).inDays != 0) {
      // The date has changed, so update the index
      currentIndex = (currentIndex + 1) % hadithList.length;
      // Store the updated index in SharedPreferences
      await prefs.setInt('currentIndex', currentIndex);
    }

    // Schedule the notification for the current index
    notificationService.scheduleDailyNotifications(
      hadithList[currentIndex].title.toString(),
      hadithList[currentIndex].content.toString(),
      scheduledDateTime,
    );
    // Store the current scheduled date in SharedPreferences
    await prefs.setInt(
        'lastScheduledDate', scheduledDateTime.millisecondsSinceEpoch);
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
              scheduleNotifications();
              // fetchNotifications();
            },
            child: const Text("Schedule"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                notificationService.pendingNotifications();
              });
            },
            child: const Text("Show Pending Notifications"),
          ),
          ElevatedButton(
            onPressed: () {
              notificationService.stopNotification();
            },
            child: const Text("Stop All Notifications"),
          ),
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: notificationService.pendingNotification.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Center(
                    child: Text(
                        "Pending Notification is ${notificationService.pendingNotification[index].title.toString()}"),
                  ),
                );
              },
            ),
          ),
          hadithList.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  flex: 12,
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



// Function to Show Notifications With Date & Time
  // void fetchNotifications() async {
  //   for (var data in hadithList) {
  //     final date = DateTime.parse(data.date.toString());
  //     notificationService.scheduleNotifications(
  //         data.id!, data.title.toString(), data.content.toString(), date);
  //   }
  // }

// Function to schedule new notifications when the app opens
// void selectTime() async {
//     TimeOfDay? selectedTime =
//         const TimeOfDay(hour: 19, minute: 43); // Set your fixed time
//     DateTime now = DateTime.now();
//     DateTime scheduledDateTime = DateTime(
//       now.year,
//       now.month,
//       now.day,
//       selectedTime.hour,
//       selectedTime.minute,
//     );
//     // Get the current index from SharedPreferences
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     int currentIndex = prefs.getInt('currentIndex') ?? 0;

//     // Schedule the notification for the current index
//     notificationService.scheduleDailyNotifications(
//       hadithList[currentIndex].title.toString(),
//       hadithList[currentIndex].content.toString(),
//       scheduledDateTime,
//     );

//     // Increment the index for the next day, or reset to 0 if it exceeds the list length
//     currentIndex = (currentIndex + 1) % hadithList.length;

//     // Store the updated index in SharedPreferences
//     await prefs.setInt('currentIndex', currentIndex);
//   }