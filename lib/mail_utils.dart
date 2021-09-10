import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> sendEmail(BuildContext context) async {
  final Email email = Email(
    body: 'Enter your issue and steps to reproduce it, attach screenshots if you have any.',
    subject: 'Bug Report',
    recipients: ['roadout.ro@gmail.com'],
    attachmentPaths: [],
    isHTML: false,
  );

  String platformResponse;

  try {
    await FlutterEmailSender.send(email);
    platformResponse = 'success';
  } catch (error) {
    platformResponse = error.toString();
  }

  //if (!mounted) return;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: EdgeInsets.all(40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: Text('Email Error', style: GoogleFonts.karla(
            fontSize: 20.0, fontWeight: FontWeight.w600)),
        content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget> [
                Text('There was an error: $platformResponse. Please screenshot this, go to your mail app and send the screenshot along with your issue to roadout.ro@gmail.com', style: GoogleFonts.karla(
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
                      disabledColor: Color.fromRGBO(1, 144, 26, 1.0),
                      color: Color.fromRGBO(1, 144, 26, 1.0),
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