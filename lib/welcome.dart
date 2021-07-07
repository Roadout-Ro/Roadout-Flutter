import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:roadout/utilites.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen();
  WelcomeScreen.forDesignTime();
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                _tile(
                    'Title one',
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.',
                    CupertinoIcons.car_fill,255,193,25),
                _tile(
                    'Title one',
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.',
                    CupertinoIcons.creditcard,143,102,13),
                _tile(
                    'Title one',
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.',
                    CupertinoIcons.arrow_branch,255,158,25),
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
                        child: CupertinoButton.filled(
                          child: Text(
                            'Sign In',
                            style: GoogleFonts.karla(
                                fontSize: 17.0, fontWeight: FontWeight.w600),
                          ),
                          onPressed: null,
                          disabledColor: Color.fromRGBO(255, 193, 25, 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(17.0)),
                        ),
                        padding: EdgeInsets.only(bottom: 10.0, right: 20.0),
                      ),
                      Container(
                        width: 298,
                        height: 60,
                        child: CupertinoButton.filled(
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.karla(
                                fontSize: 17.0, fontWeight: FontWeight.w600),
                          ),
                          onPressed: null,
                          disabledColor: Color.fromRGBO(143, 102, 13, 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(17.0)),
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
                      children: <Widget> [
                        Container(
                          width: 42.0,
                          height: 42.0,
                          child: Image.asset('assets/Logo.jpeg'),
                          padding: EdgeInsets.only(right: 10.0),
                        ),
                        Text('Terms of Use & Privacy Policy', style: GoogleFonts.karla(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center)
                      ],
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center
                    ),
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

}

