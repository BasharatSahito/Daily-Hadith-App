import 'package:daily_hadees_app/services/fetchJsonData.dart';
import 'package:daily_hadees_app/services/notification_service.dart';
import 'package:daily_hadees_app/services/schedulenotification.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationPermission {
  NotificationService notificationService;
  NotificationPermission(this.notificationService);

  GetHadith getHadith = GetHadith();
  ScheduleNotifications? scheduleNotifications;

  Future<void> requestNotificationPermission() async {
    scheduleNotifications = ScheduleNotifications(notificationService);
    PermissionStatus notificationStatus =
        await Permission.notification.request();

    if (notificationStatus.isGranted) {
      await getHadith.getHadith(); // Await here

      scheduleNotifications!.scheduleNotifications();
    }
    if (notificationStatus.isDenied) {
      openAppSettings();
    }
    if (notificationStatus.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
