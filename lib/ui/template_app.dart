import 'package:flutter/material.dart';
import 'package:flutter_fcm_template/notification/firebase/firebase_notification_handler.dart';
import 'package:flutter_fcm_template/ui/root_page.dart';
import 'package:flutter_fcm_template/ui/splash/splash_page.dart';
import 'package:overlay_support/overlay_support.dart';

class AppTemplate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        title: 'Firebase Messaging',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: SplashPage.routeName,
        routes: {
          SplashPage.routeName: (_) => SplashPage(),
          RootPage.routeName: (_) => RootPage(),
        },
      ),
    );
  }
}
