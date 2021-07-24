import 'package:flutter/material.dart';

class Themes {

static final lightRoadout = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.black,
    colorScheme: ColorScheme.light(),
    accentColor: Color.fromRGBO(102, 102, 102, 1.0),
    dialogBackgroundColor: Colors.white
);

static final darkRoadout = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    primaryColor: Colors.white,
    colorScheme: ColorScheme.dark(),
    accentColor: Color.fromRGBO(146, 145, 145, 1.0),
    dialogBackgroundColor: Color.fromRGBO(17, 17, 17, 1.0)
);
}