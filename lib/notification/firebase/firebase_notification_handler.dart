import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_fcm_template/main.dart';
import 'package:flutter_fcm_template/notification/local/local_notification_handler.dart';
import 'package:flutter_fcm_template/util/utils.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

///
// This method must be put on top and outside of everything
///
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  logger.d(
      ':firebase:: I might have died but I have a message from background ${message.data}');

  firebaseNotificationHandler.localNotificationHandler = localNotificationHandler;
  firebaseNotificationHandler.showNotification(message);
}

class FirebaseNotificationHandler {
  factory FirebaseNotificationHandler() {
    return _instance;
  }

  FirebaseNotificationHandler._private();

  static final FirebaseNotificationHandler _instance =
      FirebaseNotificationHandler._private();

  late LocalNotificationHandler localNotificationHandler;

  static const String generalChannelName = "general_notification_channel";
  final AndroidNotificationChannel generalChannel = AndroidNotificationChannel(
    generalChannelName, // this id must set in android project manifest.xml
    'Common notification', // title
    'This channel is used for common public notifications.', // description
    importance: Importance.high,
  );

  Future initFirebaseHandler(
      LocalNotificationHandler localNotificationHandler) async {
    this.localNotificationHandler = localNotificationHandler;

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    /**
     * Setup general channel
     */
    await localNotificationHandler.localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(generalChannel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future configFirebaseNotification() async {

    /**
     * when app opened from terminated state
     */
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        logger.d(
            ':firebase:Handling opened app from terminated state ${message.messageId}');
        showNotification(message);
      }
    });

    /**
     * when the app is on foreground and being used
     */
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message);
    });

    /**
     * when app come back from background, but not be terminated
     */
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logger.d(
          ':firebase: I am not dead, I am coming back from background ${message.data}');
      showNotification(message);
    });
  }

  void showNotification(RemoteMessage message) {
    logger.d(':firebase: showing notification');
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android!;
    if (notification != null && android != null && !kIsWeb) {
      AndroidNotificationChannel channel = generalChannel;

      localNotificationHandler.localNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              visibility: NotificationVisibility.public,
              // largeIcon: DrawableResourceAndroidBitmap('res/mipmap/ic_launcher.png'),
              priority: Priority.high,
              importance: Importance.max,
              icon: 'launch_background',
            ),
          ));
    }
  }
}
