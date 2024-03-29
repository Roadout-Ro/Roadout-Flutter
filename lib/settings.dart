import 'package:roadout/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:roadout/homescreen.dart';
import 'package:roadout/menus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'mail_utils.dart';

String selectedMapsApp = '';

Widget showSettings(BuildContext context, StateSetter setState, SharedPreferences preferences) {
  _readUserName();
  _readPrefferedMapsApp();
  return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).dialogBackgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(23)),),
      width: 390,
      //height: 600,
      padding: EdgeInsets.all(15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 170,
                height: 44,
                child: CupertinoButton(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                  child: Row(
                    children: <Widget>[
                      Container(width: 5.0),
                      Icon(
                        CupertinoIcons.hourglass,
                        color: Color.fromRGBO(229, 167, 0, 1.0),
                        size: 23,
                      ),
                      Text(' Active Reservation',
                          style: GoogleFonts.karla(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(229, 167, 0, 1.0))),
                    ],
                  ),
                  onPressed: () {
                    if (duration.inMinutes == 0 && duration.inSeconds == 0 && activeReservationExpiry.isAfter(DateTime.now())) {
                      currentCard = Cards.unlockedCard;
                      setState(() {});
                      Navigator.pop(context);
                    } else if (activeReservationExpiry.isAfter(DateTime.now())) {
                      currentCard = Cards.unlockCard;
                      setState(() {});
                      Navigator.pop(context);
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            insetPadding: EdgeInsets.all(40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            title: Text('No Active Reservation!', style: GoogleFonts.karla(
                                fontSize: 20.0, fontWeight: FontWeight.w600)),
                            content: Container(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget> [
                                    Text('You do not have an active reservation at this moment!', style: GoogleFonts.karla(
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
                                          disabledColor: Color.fromRGBO(149, 46, 0, 1.0),
                                          color: Color.fromRGBO(149, 46, 0, 1.0),
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
                  },
                  disabledColor: Color.fromRGBO(255, 193, 25, 0.4),
                  color: Color.fromRGBO(255, 193, 25, 0.4),
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
              ),
              Container(
                width: 10,
                height: 44,
                child: Text("   "),
              ),
              Container(
                width: 87,
                height: 44,
                child: CupertinoButton(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                  child: Row(children: <Widget>[
                    Container(width: 3.0),
                    Icon(
                      CupertinoIcons.rosette,
                      color: Color.fromRGBO(229, 167, 0, 1.0),
                      size: 23,
                    ),
                    Text(' Prizes',
                        style: GoogleFonts.karla(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(229, 167, 0, 1.0))),
                  ]),
                  onPressed: () {
                    Navigator.pop(context);
                    var brightness = MediaQuery.of(context).platformBrightness;
                    bool darkModeOn = brightness == Brightness.dark;
                    var themeName = 'Light';
                    if (darkModeOn)
                      themeName = 'Dark';
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.vertical(
                        top: Radius.circular(23),
                    )),
                    // BorderRadius. vertical// RoundedRectangleBorder
                    builder: (context) => showPrizes(context, themeName)
                    );
                  },
                  disabledColor: Color.fromRGBO(255, 193, 25, 0.4),
                  color: Color.fromRGBO(255, 193, 25, 0.4),
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
              ),
              Spacer(),
              Container(
                width: 37,
                height: 39,
                child: IconButton(
                  icon: const Icon(CupertinoIcons.xmark, size: 27),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  disabledColor: Color.fromRGBO(229, 167, 0, 1.0),
                  color: Color.fromRGBO(229, 167, 0, 1.0),
                ),
                padding: EdgeInsets.only(right: 5.0),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 10),
                width: 54,
                height: 64,
                child: CupertinoButton(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                    onPressed: () {
                      print(username[0]);
                    },
                    child: Text(username.replaceAll(' ', '')[0],
                        style: GoogleFonts.karla(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(229, 167, 0, 1.0))),
                    disabledColor: Color.fromRGBO(255, 193, 25, 0.4),
                    color: Color.fromRGBO(255, 193, 25, 0.4),
                    borderRadius: BorderRadius.all(Radius.circular(19.0))),
              ),
              Container(
                height: 52,
                padding: EdgeInsets.only(top: 10, left: 15.0),
                child: Center(
                  child: Text(username,
                      style: GoogleFonts.karla(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor)),
                ),
              ),
              Spacer(),
              Container(
                  width: 40,
                  padding: EdgeInsets.only(top: 10.0, right: 7.0),
                  child: IconButton(
                    icon: const Icon(
                      CupertinoIcons.hammer,
                      size: 27,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(23),
                              )), // BorderRadius. vertical// RoundedRectangleBorder
                          builder: (context) {
                            return showEditAccount(context, preferences);
                          });
                    },
                    disabledColor: Color.fromRGBO(229, 167, 0, 1.0),
                    color: Color.fromRGBO(229, 167, 0, 1.0),
                  ))
            ],
          ),
          Row(children: <Widget>[
            Container(
              width: 70,
              height: 30,
              padding: EdgeInsets.only(top: 10),
              child: Text("Settings",
                  style: GoogleFonts.karla(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor)),
            )
          ]),
          ListView(
              primary: false,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                _tile("Notifications", CupertinoIcons.bell, context, setState, preferences),
                _tile("Payment Methods", CupertinoIcons.creditcard, context, setState, preferences),
                _tile("Default Directions App", CupertinoIcons.arrow_branch, context, setState, preferences),
                _tile("Reminders", CupertinoIcons.clock, context, setState, preferences),
                _tile("Invite Friends", CupertinoIcons.envelope_open, context, setState, preferences),
                _tile("About Roadout", CupertinoIcons.app, context, setState, preferences),
                _tile("Report a Bug",
                    CupertinoIcons.ant, context, setState, preferences),
                _tile("Sign Out", CupertinoIcons.lock_open, context, setState, preferences),
              ])
        ],
      ));
}

ListTile _tile(String title, IconData icon, BuildContext context, StateSetter setState, SharedPreferences preferences) => ListTile(
      title: Transform(
          transform: Matrix4.translationValues(-15, 0.0, 0.0),
          child: Text(title,
              style: GoogleFonts.karla(
                  fontSize: 17.0, fontWeight: FontWeight.bold))),
      leading: Icon(
        icon,
        color: Color.fromRGBO(229, 167, 0, 1.0),
        size: 25,
      ),
      onTap: () async {
        if (title == "Sign Out") {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                insetPadding: EdgeInsets.all(40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                title: Text('Sign Out', style: GoogleFonts.karla(
                    fontSize: 20.0, fontWeight: FontWeight.w600)),
                content: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget> [
                        Text('Do you really want to sign out?', style: GoogleFonts.karla(
                            fontSize: 17.0, fontWeight: FontWeight.w500)),
                        Container(
                            padding: EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
                            width: MediaQuery.of(context).size.width-100,
                            height: 60,
                            child: CupertinoButton(
                              padding: EdgeInsets.all(0.0),
                              child: Text('Yes', style: GoogleFonts.karla(fontSize: 18.0, fontWeight: FontWeight.w600),),
                              onPressed: () async {
                                await AuthenticationService(FirebaseAuth.instance)
                                    .signOut(context: context);
                              },
                              disabledColor: Color.fromRGBO(146, 82, 24, 1.0),
                              color: Color.fromRGBO(146, 82, 24, 1.0),
                              borderRadius: BorderRadius.all(Radius.circular(13.0)),
                            )
                        ),
                        Container(
                            padding: EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
                            width: 250,
                            height: 40,
                            child: CupertinoButton(
                              padding: EdgeInsets.all(0.0),
                              child: Text('Cancel', style: GoogleFonts.karla(fontSize: 18.0, fontWeight: FontWeight.w600, color: Color.fromRGBO(146, 82, 24, 1.0)),),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              borderRadius: BorderRadius.all(Radius.circular(13.0)),
                            )
                        )
                      ],
                    )
                ),
              );
            },
          );
        } else if (title == "Notifications") {
          Navigator.pop(context);
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                top: Radius.circular(23),
              )), // BorderRadius. vertical// RoundedRectangleBorder
              builder: (context) {
                return showNotifications(context, preferences);
              });
        } else if (title == "Payment Methods") {
          Navigator.pop(context);
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                top: Radius.circular(23),
              )), // BorderRadius. vertical// RoundedRectangleBorder
              builder: (context) => showPayment(context));
        } else if (title == "Default Directions App") {
          Navigator.pop(context);
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                top: Radius.circular(23),
              )), builder: (context) => showDirectionsApp(context));
        } else if (title == "About Roadout") {
            Navigator.pop(context);
            showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
            top: Radius.circular(23),
            )), builder: (context) => showAbout(context));
        } else if (title == "Report a Bug") {
          Navigator.pop(context);
          sendEmail(context);
        } else if (title == "Invite Friends") {
          Navigator.pop(context);
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(23),
                  )), builder: (context) => showInviteFriends(context));
        } else if (title == "Reminders") {
          Navigator.pop(context);
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(23),
                  )), builder: (context) => showReminders(context));
        } else
          print(FirebaseAuth.instance.currentUser?.uid);
      },
    );

_readPrefferedMapsApp() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'directions_app_pref';
  var value = prefs.getString(key) ?? 'Google Maps';
  if (Platform.isIOS) {
     value = prefs.getString(key) ?? 'Apple Maps';
  }
  selectedMapsApp = value;
  print('Read: $value');
}

_readUserName() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'user_name';
  final value = prefs.getString(key) ?? 'User Name';
  username = value;
  print('Read: $value');
}
