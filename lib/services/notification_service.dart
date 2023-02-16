import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationController {
  final _channelId = 'safir_notification';
  final _channelName = 'Safir notification channel';
  final _channelDescription = 'Safir notification';

  late AndroidInitializationSettings initializationSettingsAndroid;
  late FlutterLocalNotificationsPlugin plugin;
  late InitializationSettings initializationSettings;
  NotificationController() {
    initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');
    initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    plugin = FlutterLocalNotificationsPlugin();
  }

  showNotification(int id, String? title, String? body,
      {bool clearAll = false}) async {
    var init = await plugin.initialize(initializationSettings);
    if (init == true) {
      if (clearAll) {
        plugin.cancelAll();
      }
      await plugin.show(
          id,
          title ?? 'No title',
          body ?? 'No body',
          NotificationDetails(
            android: AndroidNotificationDetails(_channelId, _channelName,
                channelDescription: _channelDescription,
                importance: Importance.high,
                visibility: NotificationVisibility.public),
          ));
    }
  }

  void clearAll() async {
    await plugin.initialize(initializationSettings);
    plugin.cancelAll();
  }
}
