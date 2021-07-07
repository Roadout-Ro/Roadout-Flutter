import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

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
                      fontSize: 30.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center,
                ),
             ), padding: EdgeInsets.only(top: 50.0, bottom: 20.0),
            ),
            Spacer(),
            Container(
                child: Align(
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
                      height: 70,
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
                      padding: EdgeInsets.only(bottom: 20.0, right: 20.0),
                    )
                  ],
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end),
              alignment: Alignment.bottomRight,
            ))
          ],
        ),
      ),
    );
  }
}
