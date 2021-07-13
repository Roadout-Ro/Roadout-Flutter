import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roadout/auth_service.dart';
import 'package:roadout/utilites.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';


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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    'Title one',
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.',
                    CupertinoIcons.map,
                    255,
                    193,
                    25),
                _tile(
                    'Title one',
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.',
                    CupertinoIcons.creditcard,
                    143,
                    102,
                    13),
                _tile(
                    'Title one',
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.',
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
                            child: Image.asset('assets/Logo.jpeg'),
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
                color: Colors.black54)),
        leading: Icon(
          icon,
          color: Color.fromRGBO(colorR, colorG, colorB, 1.0),
          size: 30,
        ),
      );

  Widget showSignUp() => Container(
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
                  keyboardAppearance: Brightness.light,
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
                  keyboardAppearance: Brightness.light,
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
                  keyboardAppearance: Brightness.light,
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
                  keyboardAppearance: Brightness.light,
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
          width: 210,
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
              const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
              final regExp = RegExp(pattern);
              const  patternPassword = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
              final regExpPassword =  RegExp(patternPassword);
              if (nameController.text == null  || nameController.text.isEmpty) {
               showDialog(
                 context: context,
                 builder: (context) {
                   return CupertinoAlertDialog(
                       title: Text("Please enter your name!"),
                       actions: <Widget>[
                         CupertinoDialogAction(
                             textStyle: TextStyle(
                                 color: Color.fromRGBO(146, 82, 24, 1.0)),
                             isDefaultAction: true,
                             onPressed: () {
                               Navigator.pop(context);
                             },
                             child: Text("OK")
                         ),
                       ]
                   );
                 },
               );
             } else if (!regExp.hasMatch(emailController.text)) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                        title: Text("Invalid email!"),
                        actions: <Widget>[
                          CupertinoDialogAction(
                              textStyle: TextStyle(
                                  color: Color.fromRGBO(146, 82, 24, 1.0)),
                              isDefaultAction: true,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("OK")
                          ),
                        ]
                    );
                  },
                );
              }else if(!regExpPassword.hasMatch(passwordController.text)){
                showDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                        title: Text("Invalid password!"),
                        actions: <Widget>[
                          CupertinoDialogAction(
                              textStyle: TextStyle(
                                  color: Color.fromRGBO(146, 82, 24, 1.0)),
                              isDefaultAction: true,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("OK")
                          ),
                        ]
                    );
                  },
                );
              } else if(passwordController.text != verifyPasswordController.text){
                showDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                        title: Text("Passwords do not match!"),
                        actions: <Widget>[
                          CupertinoDialogAction(
                              textStyle: TextStyle(
                                  color: Color.fromRGBO(146, 82, 24, 1.0)),
                              isDefaultAction: true,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("OK")
                          ),
                        ]
                    );
                  },
                );
              }
                AuthenticationService(FirebaseAuth.instance).signUp(
                    email: emailController.text,
                    password: passwordController.text);
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
                  keyboardAppearance: Brightness.light,
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
                  keyboardAppearance: Brightness.light,
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
          width: 210,
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
            onPressed: () {
               AuthenticationService(FirebaseAuth.instance).signIn(email: signInEmailController.text, password: signInPasswordController.text);
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

