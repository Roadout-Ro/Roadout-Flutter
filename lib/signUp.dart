import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class SignUpScreen extends StatefulWidget {
  SignUpScreen();
  SignUpScreen.forDesignTime();
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Container(
      color: Colors.transparent,
    ));
  }
}