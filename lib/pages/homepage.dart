import 'dart:convert';
import 'package:daily_hadees_app/Models/hadithmodel.dart';
import 'package:daily_hadees_app/services/notification_service.dart';
import 'package:daily_hadees_app/services/payloadprovider.dart';
import 'package:daily_hadees_app/utils/alertbox.dart';
import 'package:daily_hadees_app/utils/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NotificationService? notificationService;

  @override
  void initState() {
    super.initState();
    notificationService = NotificationService(context);
    requestNotificationPermission();
    notificationService!.initializeNotifications();
    // Set up a listener for changes in the payload
    final payloadProvider =
        Provider.of<PayloadProvider>(context, listen: false);
    payloadProvider.addListener(handlePayloadChange);
  }

  // Function to handle changes in the payload
  void handlePayloadChange() {
    final payloadProvider =
        Provider.of<PayloadProvider>(context, listen: false);
    String payload = payloadProvider.payload;
    print("The value of payload is $payload");
    if (payload != "") {
      openAlertBoxForNotification(payload);
    }
  }

  List loadHadith = [];
  // Function to open the alert box for a specific hadith
  void openAlertBoxForNotification(String payload) {
    // Parse the payload to determine which hadith to display
    int hadithIndex = int.tryParse(payload) ?? 0;
    print("The index of hadith is ${hadithIndex}");
    getHadith();
    scheduleNotifications();
    notificationService!.pendingNotifications();

    // Check if the hadith has not already been added to the list
    if (!loadHadith.contains(hadithIndex)) {
      // Add the index to the list of shown notifications
      loadHadith.add(hadithIndex);
      // Update the UI to reflect the changes

      setState(() {});
    }
    print("Length of Hadith is ${loadHadith.length}");
    // Show the alert box for the specific hadith
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return AlertBox(
    //       hadith: hadithList[hadithIndex].urduHadith.toString(),
    //       hadithInfo: hadithList[hadithIndex].info.toString(),
    //     );
    //   },
    // );
  }

  @override
  void dispose() {
    // Remove the listener when the widget is disposed
    final payloadProvider =
        Provider.of<PayloadProvider>(context, listen: false);
    payloadProvider.removeListener(handlePayloadChange);
    super.dispose();
  }

  Future<void> requestNotificationPermission() async {
    PermissionStatus notificationStatus =
        await Permission.notification.request();

    if (notificationStatus.isGranted) {
      print("Notifications Permission Granted");
      getHadith();
      scheduleNotifications();
      notificationService!.pendingNotifications();
    }
    if (notificationStatus.isDenied) {
      openAppSettings();
    }
    if (notificationStatus.isPermanentlyDenied) {
      openAppSettings();
    }
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
    // TimeOfDay? pickedTime = await showTimePicker(
    //     context: context, initialTime: const TimeOfDay(hour: 10, minute: 7));
    // TimeOfDay selectedTime = pickedTime ?? const TimeOfDay(hour: 10, minute: 7);

    TimeOfDay? selectedTime =
        const TimeOfDay(hour: 03, minute: 42); // Set your fixed time
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
    notificationService!.scheduleDailyNotifications(
      hadithList[currentIndex].id!.toInt(),
      hadithList[currentIndex].info.toString(),
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
        backgroundColor: Colors.green,
        title: const Text("Daily Hadith"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                notificationService!.pendingNotifications();
              },
              child: Text("Pending Notifications")),
          ElevatedButton(
              onPressed: () {
                notificationService!.stopNotification();
              },
              child: Text("Stop Notifications")),
          loadHadith.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: loadHadith.length,
                    itemBuilder: (context, index) {
                      int hadithIndex = loadHadith[index];

                      var arabicHadith =
                          hadithList[hadithIndex].arabicHadith.toString();
                      var urduHadith =
                          hadithList[hadithIndex].urduHadith.toString();
                      var englishHadith =
                          hadithList[hadithIndex].englishHadith.toString();
                      var hadithInfo = hadithList[hadithIndex].info.toString();
                      return Cards(
                        arabicHadith: arabicHadith,
                        englishHadith: englishHadith,
                        hadithInfo: hadithInfo,
                        urduHadith: urduHadith,
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