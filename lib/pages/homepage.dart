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
        const TimeOfDay(hour: 01, minute: 37); // Set your fixed time
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
      hadithList[currentIndex].urduHadith.toString(),
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
          // ElevatedButton(
          //   onPressed: () {
          //     // notificationService.showNotifications(
          //     // "Title 1", "This is a Body");
          //   },
          //   child: const Text("Show Notification"),
          // ),
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
            flex: 1,
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
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Card(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: Column(
                            children: [
                              hadithList[index].arabicHadith!.length > 100
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          hadithList[index]
                                              .arabicHadith
                                              .toString()
                                              .substring(0, 200),
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextButton(
                                            onPressed: () {},
                                            child: Text("...More")),
                                      ],
                                    )
                                  : Text(
                                      hadithList[index].arabicHadith.toString(),
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                              const SizedBox(height: 30),
                              hadithList[index].urduHadith!.length > 100
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          hadithList[index]
                                              .urduHadith
                                              .toString()
                                              .substring(0, 100),
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextButton(
                                            onPressed: () {},
                                            child: Text("...More")),
                                      ],
                                    )
                                  : Text(
                                      hadithList[index].urduHadith.toString(),
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                              const SizedBox(height: 10),
                              Text(hadithList[index].info.toString())
                            ],
                          ),
                        )),
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