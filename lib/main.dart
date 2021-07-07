import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:roadout/welcome.dart';
import 'package:roadout/utilites.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Roadout',
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}