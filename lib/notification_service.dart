import 'package:flutter/cupertino.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initAwesomeNotifications() async {
    AwesomeNotifications().initialize('resource://drawable/notificationicon', [
      NotificationChannel(
          channelKey: 'roadout.reservation_channel',
          channelName: 'Roadout Reservation Notifications',
          channelDescription: 'Get notifications about your reservations status',
          enableVibration: true,
          enableLights: true,
          playSound: true,
          ledColor: Color.fromRGBO(214, 109, 0, 1.0),
          importance: NotificationImportance.High,
          defaultColor: Color.fromRGBO(214, 109, 0, 1.0),
          soundSource: 'resource://raw/hornsound'
      ),
      NotificationChannel(
          channelKey: 'roadout.reminders_channel',
          channelName: 'Roadout Reminder Notifications',
          channelDescription: 'Get reminder notifications that you set',
          enableVibration: true,
          enableLights: true,
          playSound: true,
          ledColor: Color.fromRGBO(255, 193, 25, 1.0),
          importance: NotificationImportance.High,
          defaultColor: Color.fromRGBO(255, 193, 25, 1.0),
          soundSource: 'resource://raw/hornsound'
      )
    ],
    );

}

Future<bool> getReservationStatusNot() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'reservationStatusNot';
  final value = prefs.getBool(key) ?? true;
  return value;
}

Future<bool> getRemindersNot() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'remindersNot';
  final value = prefs.getBool(key) ?? true;
  return value;
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
  bool remindersNot = await getRemindersNot();
  if (remindersNot) {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: createUniqueId(),
            channelKey: 'roadout.reminders_channel',
            title: 'Reservation Reminder',
            body: 'You wanted to make a reservation for $reason'),
        schedule: NotificationCalendar.fromDate(date: reminderDate)
    );
  }
}

int createUniqueId() {
  return DateTime.now( ).millisecondsSinceEpoch.remainder(10);
}

Future<void> create5MinNotification(int durationMin, int durationSec) async {
  await AwesomeNotifications().cancel(55);
  bool reservationNot = await getReservationStatusNot();
  if (reservationNot) {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 55,
            channelKey: 'roadout.reservation_channel',
            title: '5 Minutes Left',
            body: "You have 5 more minutes left from your reservation, you can delay it if you think you won't make it on time"),
        schedule: NotificationCalendar.fromDate(date: DateTime.now().add(
            Duration(minutes: durationMin, seconds: durationSec)))
    );
  }
}

Future<void> create1MinNotification(int durationMin, int durationSec) async {
  await AwesomeNotifications().cancel(11);
  bool reservationNot = await getReservationStatusNot();
  if (reservationNot) {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 11,
            channelKey: 'roadout.reservation_channel',
            title: '1 Minute Left',
            body: "You have 1 more minute left from your reservation, you can delay it if you think you won't make it on time"),
        schedule: NotificationCalendar.fromDate(date: DateTime.now().add(
            Duration(minutes: durationMin, seconds: durationSec)))
    );
  }
}

Future<void> createReservationNotification(int durationMin, int durationSec) async {
  await AwesomeNotifications().cancel(00);
  bool reservationNot = await getReservationStatusNot();
  if (reservationNot) {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 00,
            channelKey: 'roadout.reservation_channel',
            title: 'Reservation Done',
            body: 'We hope you enjoyed using Roadout'),
        schedule: NotificationCalendar.fromDate(date: DateTime.now().add(
            Duration(minutes: durationMin, seconds: durationSec)))
    );
  }
}

Future<void> cancelReservationNotification() async {
  await AwesomeNotifications().cancel(00);
  await AwesomeNotifications().cancel(11);
  await AwesomeNotifications().cancel(55);
}