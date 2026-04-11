import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    try {
      initializeTimeZones();

      // https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
      setLocalLocation(getLocation('Asia/Kolkata'));

      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings();

      const InitializationSettings initializationSettings =
          InitializationSettings(android: androidSettings, iOS: iosSettings);
      await notificationsPlugin.initialize(settings: initializationSettings);

      // Android 13+ and iOS require an explicit runtime permission request.
      await notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();

      await notificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } catch (_) {
      // Keep app startup resilient if notification setup fails.
    }
  }

  // This is to test the notification functionality
  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await notificationsPlugin.show(
      id: 0,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'instant-clannel',
          'Relay Instant Notification',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
    String? imagePath,
  }) async {
    TZDateTime now = TZDateTime.now(local);

    TZDateTime scheduledTime = TZDateTime(
      local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledTime.isBefore(now)) {
      scheduledTime.add(Duration(days: 1));
    }

    BigPictureStyleInformation? bigPictureStyleInformation;

    if (imagePath != null) {
      bigPictureStyleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(imagePath),
      );
    } else {
      bigPictureStyleInformation = null;
    }

    await notificationsPlugin.zonedSchedule(
      id: id,
      scheduledDate: scheduledTime,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'recall-clannel',
          'Relay Notification',
          styleInformation: (imagePath == null)
              ? null
              : bigPictureStyleInformation,
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: imagePath == null
            ? const DarwinNotificationDetails()
            : DarwinNotificationDetails(
                attachments: [DarwinNotificationAttachment(imagePath)],
              ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  // Future<void> cancelNotification(...) async {
  //    ...
  // }
}
