import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fcm_template/notification/firebase/firebase_notification_handler.dart';
import 'package:flutter_fcm_template/notification/local/local_notification_handler.dart';
import 'package:flutter_fcm_template/ui/template_app.dart';

LocalNotificationHandler localNotificationHandler = LocalNotificationHandler();
FirebaseNotificationHandler firebaseNotificationHandler =
    FirebaseNotificationHandler();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp().then((value) async {
    await localNotificationHandler.initLocalHandler();

    await firebaseNotificationHandler
        .initFirebaseHandler(localNotificationHandler);

    runApp(AppTemplate());
  });
}
