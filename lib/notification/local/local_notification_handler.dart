import 'package:flutter_fcm_template/util/utils.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationHandler {
  static LocalNotificationHandler _instance = LocalNotificationHandler._();

  LocalNotificationHandler._();

  factory LocalNotificationHandler(
      {DidReceiveLocalNotificationCallback? onDidReceivedLocalNotifications}) {
    if (onDidReceivedLocalNotifications != null) {
      _instance.onDidReceivedLocalNotifications = onDidReceivedLocalNotifications;
    }
    return _instance;
  }

  DidReceiveLocalNotificationCallback? onDidReceivedLocalNotifications;

  FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future initLocalHandler() async {
    var requestPermission = true;

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    IOSInitializationSettings iosSettings = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceivedLocalNotification,
      requestAlertPermission: requestPermission,
      requestBadgePermission: requestPermission,
      requestSoundPermission: requestPermission,
    );

    InitializationSettings initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await localNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<dynamic> onSelectNotification(String? payload) async {
    if (payload != null) {
      logger.d('notification payload: $payload');
    }
    await localNotificationsPlugin.cancelAll();
  }

  Future onDidReceivedLocalNotification(
      int id, String? title, String? body, String? payload) {
    logger.d("received notification: $id, $title, $body, $payload");

    if (onDidReceivedLocalNotifications != null)
      return onDidReceivedLocalNotifications!(id, title, body, payload);
    else
      return Future.value();
  }
}
