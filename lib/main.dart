import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:roadout/theme_provider.dart';
import 'package:roadout/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    Widget firstWidget;

    if (firebaseUser != null) {
      firstWidget = MainScreen();
    } else {
      firstWidget = WelcomeScreen();
    }

    return MaterialApp(
      title: 'Roadout',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: Themes.lightRoadout,
      darkTheme: Themes.darkRoadout,
      home: firstWidget,
    );
  }
}

