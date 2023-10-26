import 'package:daily_hadees_app/services/fetchJsonData.dart';
import 'package:daily_hadees_app/services/notification_service.dart';
import 'package:daily_hadees_app/services/notificationpermission.dart';
import 'package:daily_hadees_app/services/payloadprovider.dart';
import 'package:daily_hadees_app/services/schedulenotification.dart';
import 'package:daily_hadees_app/utils/card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NotificationService? notificationService;
  GetHadith getHadith = GetHadith();
  ScheduleNotifications? scheduleNotifications;
  NotificationPermission? notificationPermission;

  @override
  void initState() {
    super.initState();
    notificationService = NotificationService(context);
    notificationPermission = NotificationPermission(notificationService!);
    notificationPermission!.requestNotificationPermission();
    notificationService!.initializeNotifications();
    scheduleNotifications = ScheduleNotifications(notificationService);
    fetchHadith();

    // Set up a listener for changes in the payload
    final payloadProvider =
        Provider.of<PayloadProvider>(context, listen: false);
    payloadProvider.addListener(handlePayloadChange);
  }

  List loadHadith = [];
  // Function to handle changes in the payload
  void handlePayloadChange() async {
    final payloadProvider =
        Provider.of<PayloadProvider>(context, listen: false);

    bool? payloadBool = payloadProvider.payloadBool;
    int? pendingIndex = payloadProvider.hadithIndex;
    int? payloadIndex = payloadProvider.payloadIndex;

    int? hadithIndex;
    if (pendingIndex != null) {
      hadithIndex = pendingIndex;

      if (!loadHadith.contains(pendingIndex)) {
        loadHadith.add(pendingIndex);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('loadHadith',
            loadHadith.join(',')); // Convert to a comma-separated string
        setState(() {});
      }
    } else {
      hadithIndex = payloadIndex;

      if (!loadHadith.contains(payloadIndex)) {
        loadHadith.add(payloadIndex);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('loadHadith',
            loadHadith.join(',')); // Convert to a comma-separated string

        setState(() {});
      }
    }

    if (payloadBool == true) {
      openDetailNotificationPage(payloadBool!, hadithIndex!);
      loadLoadHadith();
    }
  }

  void openDetailNotificationPage(bool payloadBool, int hadithIndex) {
    getHadith.getHadith();
    scheduleNotifications!.scheduleNotifications();
    bool? newPayloadBool;
    if (payloadBool == true) {
      notificationService!.pendingNotifications();
      newPayloadBool = false;
      Provider.of<PayloadProvider>(context, listen: false)
          .setPayload(newPayloadBool);
    }
    // Move the navigation logic to fetchHadith's completion callback
    fetchHadith().then((_) {
      if (hadithList.isNotEmpty) {
        if (hadithIndex >= 0 && hadithIndex < hadithList.length) {
          Navigator.pushNamed(context, "/hadithdetail", arguments: {
            'hadithId': hadithList[hadithIndex].id,
            'hadithTitle': hadithList[hadithIndex].title.toString(),
            'arabicHadith': hadithList[hadithIndex].arabicHadith.toString(),
            'urduHadith': hadithList[hadithIndex].urduHadith.toString(),
            'englishHadith': hadithList[hadithIndex].englishHadith.toString(),
            'hadithInfo': hadithList[hadithIndex].info.toString(),
          });
          debugPrint("It Worked");
        } else {
          debugPrint("It's Out of Bound");
        }
      }
    });
    // // Show the alert box for the specific hadith
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

  Future<void> loadLoadHadith() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedLoadHadith = prefs.getString('loadHadith');
    if (savedLoadHadith != null && savedLoadHadith.isNotEmpty) {
      final loadHadithList = savedLoadHadith.split(',').map(int.parse).toList();
      setState(() {
        loadHadith = loadHadithList;
      });
    }
  }

  List hadithList = [];
  Future<void> fetchHadith() async {
    await getHadith.getHadith();
    setState(() {
      hadithList = getHadith.hadithList;
      loadLoadHadith(); // Load data from SharedPreferences after fetching
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Hadith"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          loadHadith.isEmpty || hadithList.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: loadHadith.length,
                    itemBuilder: (context, index) {
                      int hadithIndex =
                          loadHadith[loadHadith.length - 1 - index];

                      var hadithId = hadithList[hadithIndex].id;
                      var hadithTitle =
                          hadithList[hadithIndex].title.toString();
                      var arabicHadith =
                          hadithList[hadithIndex].arabicHadith.toString();
                      var urduHadith =
                          hadithList[hadithIndex].urduHadith.toString();
                      var englishHadith =
                          hadithList[hadithIndex].englishHadith.toString();
                      var hadithInfo = hadithList[hadithIndex].info.toString();
                      return Cards(
                        hadithId: hadithId,
                        hadithIndex: index + 1,
                        hadithTitle: hadithTitle,
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
