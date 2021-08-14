import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> initAwesomeNotifications() async {
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: 'roadout_channel',
        channelName: 'Roadout Notifications',
        channelDescription: 'Get notifications about your reservations status',
        enableVibration: true,
        enableLights: true,
        playSound: true,
        ledColor: CupertinoColors.activeOrange
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