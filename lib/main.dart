import 'package:flutter/material.dart';

import 'package:app_dialog/views/home.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:app_dialog/providers/dialog_provider.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  requestPermission(Permission permission) async => await permission.request();
  
  @override
  Widget build(BuildContext context) {
    DialogProvider.instance.init();
    requestPermission(Permission.microphone);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dialog Flow app',
      home: Home(),
      theme: ThemeData(primaryColor: Colors.deepPurpleAccent),
    );
  }
}