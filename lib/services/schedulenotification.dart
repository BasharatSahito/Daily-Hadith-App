import 'package:daily_hadees_app/services/fetchJsonData.dart';
import 'package:daily_hadees_app/services/notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleNotifications {
  NotificationService? notificationService;
  ScheduleNotifications(this.notificationService);
  GetHadith getHadith = GetHadith();
  void scheduleNotifications() async {
    await getHadith.getHadith(); // Fetch the data before scheduling
    try {
      List hadithList = getHadith.hadithList;

      // TimeOfDay? pickedTime = await showTimePicker(
      //     context: context, initialTime: const TimeOfDay(hour: 10, minute: 7));
      // TimeOfDay selectedTime = pickedTime ?? const TimeOfDay(hour: 10, minute: 7);

      TimeOfDay? selectedTime =
          const TimeOfDay(hour: 23, minute: 45); // Set your fixed time
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
    } catch (e) {
      if (kDebugMode) {
        print("Error Scheduling Time");
      }
    }
  }
}
