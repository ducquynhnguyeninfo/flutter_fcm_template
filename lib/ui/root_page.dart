import 'package:flutter/material.dart';

class RootPage extends StatefulWidget {
  static const String routeName = "/root";

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FCM template'),
      ),
      body: Center(
        child: Text(
          '',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}
