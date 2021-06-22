import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fcm_template/notification/firebase/firebase_notification_handler.dart';
import 'package:flutter_fcm_template/ui/root_page.dart';
import 'package:flutter_fcm_template/util/utils.dart';

class SplashPage extends StatefulWidget {
  static const String routeName = "/splash";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await FirebaseNotificationHandler().configFirebaseNotification();
      FirebaseMessaging.instance.getToken().then((String? value) {
        logger.d('device fcm token:');
        logger.d(value.toString());
      });

      await Future.delayed(Duration(seconds: 4));

      Navigator.popAndPushNamed(context, RootPage.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
