import 'package:flutter/cupertino.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> initAwesomeNotifications() async {
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: 'roadout.reservation_channel',
        channelName: 'Roadout Reservation Notifications',
        channelDescription: 'Get notifications about your reservations status',
        enableVibration: true,
        enableLights: true,
        playSound: true,
        ledColor: CupertinoColors.activeOrange,
        importance: NotificationImportance.High,
        soundSource: 'assets/horn-sound.mp3'
    ),
    NotificationChannel(
        channelKey: 'roadout.reminders_channel',
        channelName: 'Roadout Reminder Notifications',
        channelDescription: 'Get reminder notifications that you set',
        enableVibration: true,
        enableLights: true,
        playSound: true,
        ledColor: CupertinoColors.systemYellow,
        importance: NotificationImportance.High,
        soundSource: 'assets/horn-sound.mp3'
    )
  ],
  );
}

Future<void> requestNotificationPermission() async {
  AwesomeNotifications().isNotificationAllowed().then((allowed) {
    if (!allowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
}

Future<bool> checkNotificationPermission() async {
  AwesomeNotifications().isNotificationAllowed().then((allowed) {
    if (!allowed) {
      return false;
    } else {
      return true;
    }
  });
  return false;
}

Future<void> createReminderNotification(String reason, DateTime reminderDate) async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'roadout.reminders_channel',
      title: 'Reservation Reminder',
      body: 'You wanted to make a reservation for $reason'),
      schedule: NotificationCalendar.fromDate(date: reminderDate)
  );
}

int createUniqueId() {
  return DateTime.now( ).millisecondsSinceEpoch.remainder(10);
}

Future<void> create5MinNotification(int durationMin, int durationSec) async {
  await AwesomeNotifications().cancel(55);
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 55,
          channelKey: 'roadout.reservation_channel',
          title: '5 Minutes Left',
          body: "You have 5 more minutes left from your reservation, you can delay it if you think you won't make it on time"),
      schedule: NotificationCalendar.fromDate(date: DateTime.now().add(Duration(minutes: durationMin, seconds: durationSec)))
  );
}

Future<void> create1MinNotification(int durationMin, int durationSec) async {
  await AwesomeNotifications().cancel(11);
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 11,
          channelKey: 'roadout.reservation_channel',
          title: '1 Minute Left',
          body: "You have 1 more minute left from your reservation, you can delay it if you think you won't make it on time"),
      schedule: NotificationCalendar.fromDate(date: DateTime.now().add(Duration(minutes: durationMin, seconds: durationSec)))
  );
}

Future<void> createReservationNotification(int durationMin, int durationSec) async {
  await AwesomeNotifications().cancel(00);
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 00,
          channelKey: 'roadout.reservation_channel',
          title: 'Reservation Done',
          body: 'We hope you enjoyed using Roadout'),
      schedule: NotificationCalendar.fromDate(date: DateTime.now().add(Duration(minutes: durationMin, seconds: durationSec)))
  );
}

Future<void> cancelReservationNotification() async {
  await AwesomeNotifications().cancel(00);
  await AwesomeNotifications().cancel(11);
  await AwesomeNotifications().cancel(55);
}