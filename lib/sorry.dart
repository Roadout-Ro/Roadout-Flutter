import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

class SorryScreen extends StatefulWidget {

  SorryScreen();
  SorryScreen.forDesignTime();
  @override
  _SorryScreenState createState() => _SorryScreenState();
}

class _SorryScreenState extends State<SorryScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
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
              Container(
                width: 264,
                child: Align(
                  child: Text(
                    '''We are really sorry :( 
Unfortunately Roadout does not support screens this small. We are sad to see you go, and will be waiting for your visit again on a supported device.''',
                    style: GoogleFonts.karla(
                        fontSize: 20.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                padding: EdgeInsets.only(top: 50.0, bottom: 40.0),
              ),
              Spacer(),
              Container(
                width: MediaQuery.of(context).size.width - 58,
                height: 45,
                child: CupertinoButton(
                  padding: EdgeInsets.all(0.0),
                  child: Text(
                      "Exit App",
                      style: GoogleFonts.karla(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600,)
                  ),
                  onPressed: () => {
                    print('yeah'),
                    exit(0)
                  },
                  borderRadius: BorderRadius.all(Radius.circular(13.0)),
                  disabledColor: Color.fromRGBO(255, 193, 25, 1.0),
                  color: Color.fromRGBO(255, 193, 25, 1.0),
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 20.0))
            ],
          ),
        )
      ),
    );
  }

}