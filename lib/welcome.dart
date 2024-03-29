import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roadout/auth_service.dart';
import 'package:roadout/utilites.dart';
import 'package:firebase_auth/firebase_auth.dart';

final GlobalKey<ScaffoldState> welcomeKey = GlobalKey<ScaffoldState>();

class WelcomeScreen extends StatefulWidget {

  WelcomeScreen();
  WelcomeScreen.forDesignTime();
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController verifyPasswordController = TextEditingController();
TextEditingController nameController = TextEditingController();
TextEditingController signInEmailController = TextEditingController();
TextEditingController signInPasswordController = TextEditingController();


class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: welcomeKey,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              width: 264,
              child: Align(
                child: Text(
                  'Welcome to Roadout',
                  style: GoogleFonts.karla(
                      fontSize: 30.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              padding: EdgeInsets.only(top: 50.0, bottom: 40.0),
            ),
            ListView(
              primary: false,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                _tile(
                    'Parking Spaces',
                    'Check the vacancy of parking spaces in real time.',
                    CupertinoIcons.map,
                    255,
                    193,
                    25),
                _tile(
                    'Credit Card Payment',
                    'You can reserve a parking space by paying safely online in our app.',
                    CupertinoIcons.creditcard,
                    143,
                    102,
                    13),
                _tile(
                    'Live directions',
                    'Receive directions to the desired parking spot in your favourite maps app.',
                    CupertinoIcons.arrow_branch,
                    255,
                    158,
                    25),
              ],
            ),
            Spacer(),
            Container(
                child: Column(children: <Widget>[
                  Container(
                    child: GradientText(
                      "Let's get started",
                      gradient: LinearGradient(colors: [
                        Color.fromRGBO(255, 193, 25, 1.0),
                        Color.fromRGBO(146, 82, 24, 1.0)
                      ]),
                    ),
                    padding: EdgeInsets.only(bottom: 25.0),
                  ),
                  Align(
                    child: Column(
                        children: <Widget>[
                          Container(
                            width: 270,
                            height: 60,
                            child: CupertinoButton(
                              child: Text(
                                'Sign In',
                                style: GoogleFonts.karla(
                                    fontSize: 17.0, fontWeight: FontWeight.w600),
                              ),
                              onPressed: () => showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(23),
                                      )), // BorderRadius. vertical// RoundedRectangleBorder
                                  builder: (context) => showSignIn()),
                              disabledColor: Color.fromRGBO(255, 193, 25, 1.0),
                              color: Color.fromRGBO(255, 193, 25, 1.0),
                              borderRadius: BorderRadius.all(Radius.circular(17.0)),
                            ),
                            padding: EdgeInsets.only(bottom: 10.0, right: 20.0),
                          ),
                          Container(
                            width: 298,
                            height: 60,
                            child: CupertinoButton(
                              child: Text(
                                'Sign Up',
                                style: GoogleFonts.karla(
                                    fontSize: 17.0, fontWeight: FontWeight.w600),
                              ),
                              onPressed: () => showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(23),
                                      )), // BorderRadius. vertical// RoundedRectangleBorder
                                  builder: (context) => showSignUp()),
                              disabledColor: Color.fromRGBO(143, 102, 13, 1.0),
                              borderRadius: BorderRadius.all(Radius.circular(17.0)),
                              color: Color.fromRGBO(143, 102, 13, 1.0),
                            ),
                            padding: EdgeInsets.only(bottom: 10.0, right: 20.0),
                          )
                        ],
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end),
                    alignment: Alignment.bottomRight,
                  ),
                  Container(
                    child: Row(
                        children: <Widget>[
                          Container(
                            width: 42.0,
                            height: 42.0,
                            child: Image.asset('assets/Logo.png'),
                            padding: EdgeInsets.only(right: 10.0),
                          ),
                          Text('Terms of Use & Privacy Policy',
                              style: GoogleFonts.karla(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center)
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center),
                  )
                ]))
          ],
        ),
      ),
    );
  }

  ListTile _tile(String title, String description, IconData icon, int colorR,
      int colorG, int colorB) =>
      ListTile(
        title: Text(title,
            style:
            GoogleFonts.karla(fontSize: 16.0, fontWeight: FontWeight.bold)),
        subtitle: Text(description,
            style: GoogleFonts.karla(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).indicatorColor)),
        leading: Icon(
          icon,
          color: Color.fromRGBO(colorR, colorG, colorB, 1.0),
          size: 30,
        ),
      );

  Widget showSignUp() => Container(
    decoration: BoxDecoration(
      color: Theme.of(context).dialogBackgroundColor,
      borderRadius: BorderRadius.all(Radius.circular(23)),),
    padding: MediaQuery.of(context).viewInsets,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Align(
          child: Container(
              padding: EdgeInsets.only(left: 23, bottom: 27, top: 20),
              child: Text(
                "Sign Up",
                style: GoogleFonts.karla(
                    fontSize: 24.0, fontWeight: FontWeight.bold),
              )),
          alignment: Alignment.centerLeft,
        ),
        Form(
          child:Column(
          children: <Widget>[
            Container(
                height: 50,
                padding: EdgeInsets.only(left: 24, right: 24, bottom: 10),
                child: TextFormField(
                  controller: nameController,
                  cursorColor: Color.fromRGBO(103, 72, 5, 1.0),
                  autocorrect: false,
                  keyboardAppearance: MediaQuery.of(context).platformBrightness,
                  decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(
                          color: Color.fromRGBO(103, 72, 5, 1.0),
                          fontWeight: FontWeight.w600),
                      filled: true,
                      fillColor: Color.fromRGBO(103, 72, 5, 0.22),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3,
                            color: Color.fromRGBO(103, 72, 5, 0.0)),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3,
                            color: Color.fromRGBO(103, 72, 5, 0.0)),
                        borderRadius: BorderRadius.circular(15),
                      )),
                )),
            Container(
                height: 50,
                padding: EdgeInsets.only(left: 24, right: 24, bottom: 10),
                child: TextFormField(
                  controller: emailController,
                  cursorColor: Color.fromRGBO(255, 158, 25, 1.0),
                  autocorrect: false,
                  keyboardAppearance: MediaQuery.of(context).platformBrightness,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                          color: Color.fromRGBO(255, 158, 25, 1.0),
                          fontWeight: FontWeight.w600),
                      filled: true,
                      fillColor: Color.fromRGBO(255, 158, 25, 0.22),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3,
                            color: Color.fromRGBO(255, 158, 25, 0.0)),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3,
                            color: Color.fromRGBO(255, 158, 25, 0.0)),
                        borderRadius: BorderRadius.circular(15),
                      )),
                )),
            Container(
                height: 50,
                padding: EdgeInsets.only(left: 24, right: 24, bottom: 10),
                child: TextFormField(
                  controller: passwordController,
                  cursorColor: Color.fromRGBO(255, 193, 25, 1.0),
                  obscureText: true,
                  autocorrect: false,
                  keyboardAppearance: MediaQuery.of(context).platformBrightness,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                          color: Color.fromRGBO(255, 193, 25, 1.0),
                          fontWeight: FontWeight.w600),
                      filled: true,
                      fillColor: Color.fromRGBO(255, 193, 25, 0.22),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3,
                            color: Color.fromRGBO(255, 193, 25, 0.0)),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3,
                            color: Color.fromRGBO(255, 193, 25, 0.0)),
                        borderRadius: BorderRadius.circular(15),
                      )),
                )),
            Container(
                height: 50,
                padding: EdgeInsets.only(left: 24, right: 24, bottom: 10),
                child: TextFormField(
                  controller: verifyPasswordController,
                  cursorColor: Color.fromRGBO(143, 102, 13, 1.0),
                  obscureText: true,
                  autocorrect: false,
                  keyboardAppearance: MediaQuery.of(context).platformBrightness,
                  decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(
                          color: Color.fromRGBO(143, 102, 13, 1.0),
                          fontWeight: FontWeight.w600),
                      filled: true,
                      fillColor: Color.fromRGBO(143, 102, 13, 0.22),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3,
                            color: Color.fromRGBO(143, 102, 13, 0.0)),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3,
                            color: Color.fromRGBO(143, 102, 13, 0.0)),
                        borderRadius: BorderRadius.circular(15),
                      )),
                ))
          ],
        ),
        ),
        Container(
          width: MediaQuery.of(context).size.width - 58,
          height: 90,
          child: CupertinoButton(
            child: Align(
              child: Text(
                'Sign Up',
                style: GoogleFonts.karla(
                    fontSize: 17.0, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              alignment: Alignment.center,
            ),
            onPressed: (){
              const patternPassword = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
              final regExpPassword =  RegExp(patternPassword);
              if (passwordController.text != verifyPasswordController.text ) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      insetPadding: EdgeInsets.all(40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      title: Text('Sign Up Error', style: GoogleFonts.karla(
                          fontSize: 20.0, fontWeight: FontWeight.w600)),
                      content: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget> [
                              Text('Passwords do not match!', style: GoogleFonts.karla(
                                  fontSize: 17.0, fontWeight: FontWeight.w500)),
                              Container(
                                  padding: EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
                                  width: MediaQuery.of(context).size.width-100,
                                  height: 60,
                                  child: CupertinoButton(
                                    padding: EdgeInsets.all(0.0),
                                    child: Text('Ok', style: GoogleFonts.karla(fontSize: 18.0, fontWeight: FontWeight.w600),),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    disabledColor: Color.fromRGBO(220, 170, 57, 1.0),
                                    color: Color.fromRGBO(220, 170, 57, 1.0),
                                    borderRadius: BorderRadius.all(Radius.circular(13.0)),
                                  )
                              ),
                            ],
                          )
                      ),
                    );
                  },
                );
             }
              else if (!regExpPassword.hasMatch(passwordController.text)) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      insetPadding: EdgeInsets.all(40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      title: Text('Sign Up Error', style: GoogleFonts.karla(
                          fontSize: 20.0, fontWeight: FontWeight.w600)),
                      content: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget> [
                              Text('Password should be at least 8 characters long, have a capital letter and a number!', style: GoogleFonts.karla(
                                  fontSize: 17.0, fontWeight: FontWeight.w500)),
                              Container(
                                  padding: EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
                                  width: MediaQuery.of(context).size.width-100,
                                  height: 60,
                                  child: CupertinoButton(
                                    padding: EdgeInsets.all(0.0),
                                    child: Text('Ok', style: GoogleFonts.karla(fontSize: 18.0, fontWeight: FontWeight.w600),),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    disabledColor: Color.fromRGBO(220, 170, 57, 1.0),
                                    color: Color.fromRGBO(220, 170, 57, 1.0),
                                    borderRadius: BorderRadius.all(Radius.circular(13.0)),
                                  )
                              ),
                            ],
                          )
                      ),
                    );
                  },
                );
              }
              else if (nameController.text == ''  || nameController.text.isEmpty){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      insetPadding: EdgeInsets.all(40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      title: Text('Sign Up Error', style: GoogleFonts.karla(
                          fontSize: 20.0, fontWeight: FontWeight.w600)),
                      content: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget> [
                              Text('Please enter your name!', style: GoogleFonts.karla(
                                  fontSize: 17.0, fontWeight: FontWeight.w500)),
                              Container(
                                  padding: EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
                                  width: MediaQuery.of(context).size.width-100,
                                  height: 60,
                                  child: CupertinoButton(
                                    padding: EdgeInsets.all(0.0),
                                    child: Text('Ok', style: GoogleFonts.karla(fontSize: 18.0, fontWeight: FontWeight.w600),),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    disabledColor: Color.fromRGBO(220, 170, 57, 1.0),
                                    color: Color.fromRGBO(220, 170, 57, 1.0),
                                    borderRadius: BorderRadius.all(Radius.circular(13.0)),
                                  )
                              ),
                            ],
                          )
                      ),
                    );
                  },
                );
              }
              if (regExpPassword.hasMatch(passwordController.text) && passwordController.text == verifyPasswordController.text && !nameController.text.isEmpty) {
                AuthenticationService(FirebaseAuth.instance).signUp(
                    email: emailController.text,
                    password: passwordController.text,
                    context: context,
                    name: nameController.text);
                }
              },
            disabledColor: Color.fromRGBO(143, 102, 13, 1.0),
            borderRadius: BorderRadius.all(Radius.circular(17.0)),
            color: Color.fromRGBO(143, 102, 13, 1.0),
          ),
          padding: EdgeInsets.only(top: 12.0, bottom: 30.0),
        )
      ],
    ),
  );

  Widget showSignIn() => Container(
    decoration: BoxDecoration(
        color: Theme.of(context).dialogBackgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(23)),),
    padding: MediaQuery.of(context).viewInsets,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Align(
          child: Container(
              padding: EdgeInsets.only(left: 23, bottom: 27, top: 20),
              child: Text(
                "Sign In",
                style: GoogleFonts.karla(
                    fontSize: 24.0, fontWeight: FontWeight.bold),
              )),
          alignment: Alignment.centerLeft,
        ),
        Column(
          children: <Widget>[
            Container(
                height: 50,
                padding: EdgeInsets.only(left: 24, right: 24, bottom: 10),
                child: TextFormField(
                  controller: signInEmailController,
                  cursorColor: Color.fromRGBO(255, 193, 25, 1.0),
                  autocorrect: false,
                  keyboardAppearance: MediaQuery.of(context).platformBrightness,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                          color: Color.fromRGBO(255, 193, 25, 1.0),
                          fontWeight: FontWeight.w600),
                      filled: true,
                      fillColor: Color.fromRGBO(255, 193, 25, 0.22),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3,
                            color: Color.fromRGBO(255, 193, 25, 0.0)),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3,
                            color: Color.fromRGBO(255, 193, 25, 0.0)),
                        borderRadius: BorderRadius.circular(15),
                      )),
                )),
            Container(
                height: 50,
                padding: EdgeInsets.only(left: 24, right: 24, bottom: 10),
                child: TextFormField(
                  controller: signInPasswordController,
                  cursorColor: Color.fromRGBO(143, 102, 13, 1.0),
                  obscureText: true,
                  autocorrect: false,
                  keyboardAppearance: MediaQuery.of(context).platformBrightness,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                          color: Color.fromRGBO(143, 102, 13, 1.0),
                          fontWeight: FontWeight.w600),
                      filled: true,
                      fillColor: Color.fromRGBO(143, 102, 13, 0.22),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3,
                            color: Color.fromRGBO(143, 102, 13, 0.0)),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3,
                            color: Color.fromRGBO(143, 102, 13, 0.0)),
                        borderRadius: BorderRadius.circular(15),
                      )),
                ))
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width - 58,
          height: 90,
          child: CupertinoButton(
            child: Align(
              child: Text(
                'Sign In',
                style: GoogleFonts.karla(
                    fontSize: 17.0, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              alignment: Alignment.center,
            ),
            onPressed:() {
               AuthenticationService(FirebaseAuth.instance).signIn(email: signInEmailController.text, password: signInPasswordController.text, context: context);
            },
            disabledColor: Color.fromRGBO(255, 193, 25, 1.0),
            borderRadius: BorderRadius.all(Radius.circular(17.0)),
            color: Color.fromRGBO(255, 193, 25, 1.0),
          ),
          padding: EdgeInsets.only(top: 12.0, bottom: 30.0),
        )
      ],
    ),
  );


}

