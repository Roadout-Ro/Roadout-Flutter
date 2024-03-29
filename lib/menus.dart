import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:roadout/settings.dart';
import 'package:roadout/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:app_settings/app_settings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'auth_service.dart';
import 'notification_service.dart';
import 'database_service.dart';
import 'dart:io';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

TextEditingController cvvController = TextEditingController();
TextEditingController expiryController = TextEditingController();
TextEditingController nameController = TextEditingController();
TextEditingController numberController = TextEditingController();
TextEditingController changeName = TextEditingController();
TextEditingController oldPsw = TextEditingController();
TextEditingController newPsw = TextEditingController();
TextEditingController confPsw = TextEditingController();

TextEditingController deleteEmailController = TextEditingController();
TextEditingController deletePasswordController = TextEditingController();

TextEditingController notificationLabelController = TextEditingController();

int month1 = 2;
int month2 = 3;

Color color1 = Color.fromRGBO(149, 46, 0, 1.0);
Color color2 = Color.fromRGBO(11, 7, 0, 1.0);

bool getReservationStatusNot(SharedPreferences prefs) {
  final key = 'reservationStatusNot';
  final value = prefs.getBool(key) ?? true;
  return value;
}

bool getRemindersNot(SharedPreferences prefs) {
  final key = 'remindersNot';
  final value = prefs.getBool(key) ?? true;
  return value;
}

List<String> prizes = ["Diploma", "Medal", "Trophy", "Cup", "Wreath"];
int currentPrize = 0;
List<String> prizeNames = [
  "Road Diploma",
  "Drive Medal",
  "Planner Trophy",
  "Traffic Cup",
  "Wreath of Gratitude"
];
List<String> prizeChallenges = [
  "Make one reservation and invite 5 friends",
  "Make five reservations and invite 10 friends",
  "Make ten reservations and invite 15 friends",
  "Make ten reservations, invite 20 friends and make one delay",
  "Make fifteen reservation, invite 30 friends and make five delays"
];
List<Color> prizeButtonColors = [
  Color.fromRGBO(255, 193, 25, 1.0),
  Color.fromRGBO(214, 109, 0, 1.0),
  Color.fromRGBO(220, 170, 57, 1.0),
  Color.fromRGBO(103, 72, 5, 1.0),
  Color.fromRGBO(149, 46, 0, 1.0),
];
List<Color> prizeTextColors = [
  Color.fromRGBO(219, 161, 15, 1.0),
  Color.fromRGBO(214, 109, 0, 1.0),
  Color.fromRGBO(220, 170, 57, 1.0),
  Color.fromRGBO(103, 72, 5, 1.0),
  Color.fromRGBO(149, 46, 0, 1.0),
];

List<String> permissions = ["Notifications", "Location"];
int currentPermission = 0;
List<String> permissionTexts = [
  "Roadout needs permission to send notifications in order to give you status updates for your reservations and reminders about our promotions. You can control which notifications you get in notification settings.",
  "Roadout needs access to your location in order to be able to show you parking spots near you and allow you to make reservations. We do not share your location with third parties and do not use it to serve you ads."
];
List<Color> permissionColors = [
  Color.fromRGBO(255, 193, 25, 1.0),
  Color.fromRGBO(214, 90, 0, 1.0),
];

List<String> tutorials = ["The Search Bar", "Roadout Preferences", "Park Indicator"];
List<String> tutorialImages = ["TheSearchBar", "RoadoutPreferences", "ParkIndicator"];
List<String> tutorialTexts = ["You can use the search bar to look for specific parking places, you will also get at a glance how many free spots there are at the places that match, just tap it and start typing.", "On the search bar you will also find the preferences button, looks just like this, tap it and you’ll see the preferences. Pretty straight forward, right?", "You will also see park indicators on the map, indicating, you guessed it, where parking locations are. Tap it and you’ll get some details, then you can pick a spot and reserve it!"];
List<Color> tutorialColors = [
  Color.fromRGBO(143, 102, 13, 1.0),
  Color.fromRGBO(103, 72, 5, 1.0),
  Color.fromRGBO(214, 90, 0, 1.0),
];
int currentTutorial = 0;
List<String> tutorialTopBtns = ["Next", "Next", "Done"];
List<String> tutorialBottomBtns = ["Dismiss", "Previous", "Previous"];
List<double> tutorialHeights = [52.0, 80.0, 96.0];
List<double> tutorialPaddings = [30.0, 15.0, 10.0];

double editHeight = 320;
String userDeleted = '';


List<Widget> cards = [
  Dismissible(
    key: Key('0'),
      direction: DismissDirection.endToStart,
      onDismissed: (direction){
        cards.removeAt(0);
      },
      background: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          alignment: Alignment.centerRight,
          child: Icon(CupertinoIcons.trash, color: Color.fromRGBO(
              149, 46, 0, 1.0))
      ),
      child:Center(
    child: _cardTile(
        '**** **** **** 9000',
        LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(255, 193, 25, 1.0),
              Color.fromRGBO(103, 72, 5, 1.0)
            ]),
        Color.fromRGBO(103, 72, 5, 1.0)))),
 Dismissible(
   key: Key('1'),
   direction: DismissDirection.endToStart,
   onDismissed: (direction){
     cards.removeAt(1);
   },
   background: Container(
       margin: EdgeInsets.symmetric(horizontal: 15),
       alignment: Alignment.centerRight,
       child: Icon(CupertinoIcons.trash, color: Color.fromRGBO(
           149, 46, 0, 1.0))
   ),
   child:Center(
    child: _cardTile(
        '**** **** **** 9900',
        LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              Color.fromRGBO(255, 158, 25, 1.0),
              Color.fromRGBO(143, 102, 13, 1.0)
            ]),
        Color.fromRGBO(143, 102, 13, 1.0)),
  ),)
];

DateTime reminderDate = DateTime.now().add(Duration(minutes: 15 - DateTime.now().minute % 15));
String formattedDate = DateFormat('MMM dd, hh:mm').format(reminderDate);

Widget showNotifications(BuildContext context, SharedPreferences preferences) {
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return Container(
        height: 280,
        decoration: BoxDecoration(
          color: Theme.of(context).dialogBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(23)),
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 200,
                  height: 80,
                  padding: EdgeInsets.only(left: 20.0, top: 30.0),
                  child: Text(
                    "Notifications",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.karla(
                        fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                ),
                Spacer(),
                Container(
                  height: 80,
                  width: 50,
                  padding: EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    icon: const Icon(CupertinoIcons.xmark, size: 23),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    disabledColor: Color.fromRGBO(255, 193, 25, 1.0),
                    color: Color.fromRGBO(255, 193, 25, 1.0),
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 250,
                  height: 50,
//padding: EdgeInsets.only(left: 10),
                  child: Column(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                            "Reservation Status Notifications",
                            style: GoogleFonts.karla(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          )),
                      Container(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            "Get timely notifications about the remaining time",
                            style: GoogleFonts.karla(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(152, 152, 152, 1.0)),
                          ))
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  width: 51,
                  height: 55,
                  padding: EdgeInsets.only(right: 30),
                  child: CupertinoSwitch(
                    value: getReservationStatusNot(preferences),
                    onChanged: (bool value) async {
                      final prefs = await SharedPreferences.getInstance();
                      final key = 'reservationStatusNot';
                      prefs.setBool(key, value);
                      print('Saved $value');
                      setState(() {});
//Navigator.pop(context);
/*showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.vertical(
                                top: Radius.circular(23),
                              )),
                          // BorderRadius. vertical// RoundedRectangleBorder
                          builder: (context) =>
                              showSettings(
                                  context, setState, prefs));*/
                    },
                    activeColor: Color.fromRGBO(255, 193, 25, 1.0),
                  ),
                ),
              ],
            ),
            Container(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 219,
                  height: 50,
//padding: EdgeInsets.only(left: 10),
                  child: Column(
                    children: <Widget>[
                      Container(
//padding: EdgeInsets.only(left: 21),
                          padding: EdgeInsets.only(right: 104),
                          child: Text(
                            "Reminders",
                            style: GoogleFonts.karla(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          )),
                      Container(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            "Get reminders you set to make reservations",
                            style: GoogleFonts.karla(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(152, 152, 152, 1.0)),
                          ))
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  width: 51,
                  height: 55,
                  padding: EdgeInsets.only(right: 30),
                  child: CupertinoSwitch(
                    value: getRemindersNot(preferences),
                    onChanged: (bool value) async {
                      final prefs = await SharedPreferences.getInstance();
                      final key = 'remindersNot';
                      prefs.setBool(key, value);
                      print('Saved $value');
                      setState(() {});
                    },
                    activeColor: Color.fromRGBO(255, 193, 25, 1.0),
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Center(
              child: InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.only(top: 10),
                        alignment: Alignment.center,
                        height: 30,
                        child: Row(children: <Widget>[
                          Text(
                            "Notifications are enabled. ",
                            style: GoogleFonts.karla(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(152, 152, 152, 1.0)),
                          ),
                          Text(
                            "See settings",
                            style: GoogleFonts.karla(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(143, 102, 13, 1.0)),
                          )
                        ]))
                  ],
                ),
                onTap: () {
                  AppSettings.openNotificationSettings();
                },
              ),
            )
          ],
        ));
  });
}

Widget showPayment(BuildContext context) =>
 StatefulBuilder(builder: (BuildContext context, StateSetter setState){
    return Container(
    width: 390,
    decoration: BoxDecoration(
      color: Theme.of(context).dialogBackgroundColor,
      borderRadius: BorderRadius.all(Radius.circular(23)),
    ),
    padding: MediaQuery.of(context).viewInsets,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 200,
              height: 60,
              padding: EdgeInsets.only(left: 20.0, top: 30.0),
              child: Text(
                "Payment",
                textAlign: TextAlign.left,
                style: GoogleFonts.karla(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor),
              ),
            ),
            Spacer(),
            Container(
              height: 50,
              width: 50,
              padding: EdgeInsets.only(right: 8.0, top: 17.0),
              child: IconButton(
                icon: const Icon(CupertinoIcons.xmark, size: 23),
                onPressed: () {
                  Navigator.pop(context);
                },
                disabledColor: Color.fromRGBO(229, 167, 0, 1.0),
                color: Color.fromRGBO(229, 167, 0, 1.0),
              ),
            )
          ],
        ),
        ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height/2-80,
            ),
            child: ListView(
              primary: false,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: cards,
            )
        ),
        Container(
          width: MediaQuery.of(context).size.width - 58,
          height: 45,
          child: CupertinoButton(
            padding: EdgeInsets.all(0.0),
            child: Text(
              'Add Card',
              style: GoogleFonts.karla(
                  fontSize: 17.0, fontWeight: FontWeight.w600),
            ),
            onPressed: () => {
              Navigator.pop(context),
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                    top: Radius.circular(23),
                  )),
                  builder: (context) => showAddCard(context))
            },
            disabledColor: Color.fromRGBO(255, 193, 25, 1.0),
            color: Color.fromRGBO(255, 193, 25, 1.0),
            borderRadius: BorderRadius.all(Radius.circular(13.0)),
          ),
        ),
        Padding(padding: EdgeInsets.only(bottom: 30.0))
   ],
    ));});

ListTile _cardTile(String number, Gradient gradient, Color numberColor) => ListTile(
        title: Transform(
            transform: Matrix4.translationValues(-10, 0.0, 0.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                ),
                Container(
                  child: Text(number,
                      style: GoogleFonts.karla(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: numberColor)),
                ),
              ],
            )),
        leading: Container(
          width: 69,
          height: 38,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
        ));

Widget showDirectionsApp(BuildContext context) {
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    List<Widget> apps = [
      _appTile("Apple Maps", 'assets/apple-maps.png', 0.0, context,
          setState),
      _appTile("Google Maps", 'assets/google-maps.png', 0.0,
          context, setState),
      _appTile("Waze", 'assets/waze.png', 0.0, context, setState)
    ];
    if (Platform.isAndroid) {
      apps.removeAt(0);
    }
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).dialogBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(23)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 200,
                  height: 60,
                  padding: EdgeInsets.only(left: 20.0, top: 30.0),
                  child: Text(
                    "Directions App",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.karla(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
                Spacer(),
                Container(
                  height: 50,
                  width: 50,
                  padding: EdgeInsets.only(right: 8.0, top: 17.0),
                  child: IconButton(
                    icon: const Icon(CupertinoIcons.xmark, size: 23),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    disabledColor: Color.fromRGBO(229, 167, 0, 1.0),
                    color: Color.fromRGBO(229, 167, 0, 1.0),
                  ),
                )
              ],
            ),
            Container(
              height: 10.0,
            ),
            ListView(
                primary: false,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: apps),
            Padding(padding: EdgeInsets.only(bottom: 20.0))
          ],
        ));
  });
}

ListTile _appTile(String name, String imageName, double opacity,
    BuildContext context, StateSetter setState) {
  if (selectedMapsApp == name) opacity = 0.3;
  return ListTile(
    title: Transform(
        transform: Matrix4.translationValues(-20, 0.0, 0.0),
        child: Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 20,
                ),
                Container(
                    height: 48,
                    width: MediaQuery.of(context).size.width - 52,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(180, 180, 180, opacity),
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    )),
              ],
            ),
            Column(
              children: <Widget>[
                Container(
                  height: 3.5,
                ),
                Row(
                  children: <Widget>[
                    Container(
                        width: 77.0,
                        height: 40.0,
                        child: Image.asset(imageName),
                        padding: EdgeInsets.only(left: 25.0, right: 12.0)),
                    Text(
                      name,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.karla(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor),
                    )
                  ],
                )
              ],
            )
          ],
        )),
    leading: null,
    onTap: () =>
        {selectedMapsApp = name, _savePrefferedMapsApp(name), setState(() {})},
  );
}

Widget showAbout(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Theme.of(context).dialogBackgroundColor,
      borderRadius: BorderRadius.all(Radius.circular(23)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 200,
              height: 60,
              padding: EdgeInsets.only(left: 20.0, top: 18.0),
              child: Text(
                "About",
                textAlign: TextAlign.left,
                style: GoogleFonts.karla(
                    fontSize: 20.0, fontWeight: FontWeight.w600),
              ),
            ),
            Spacer(),
            Container(
              width: 50,
              height: 63,
              padding: EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: const Icon(CupertinoIcons.xmark, size: 23),
                onPressed: () {
                  Navigator.pop(context);
                },
                disabledColor: Color.fromRGBO(255, 193, 25, 1.0),
                color: Color.fromRGBO(255, 193, 25, 1.0),
              ),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              width: 80,
              height: 55,
              padding: EdgeInsets.only(left: 20.0),
              child: Image.asset('assets/Logo.png'),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                children: <Widget>[
                  Text(
                    "Roadout",
                    style: GoogleFonts.karla(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Container(
                      padding: EdgeInsets.only(right: 42),
                      child: Text(
                        "v1.0",
                        style: GoogleFonts.karla(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(101, 101, 101, 1.0)),
                      ))
                ],
              ),
            )
          ],
        ),
        Padding(padding: EdgeInsets.only(top: 8.0)),
        Container(
          width: MediaQuery.of(context).size.width - 22,
          height: 70,
          padding: EdgeInsets.only(top: 5),
          child: CupertinoButton(
            padding: EdgeInsets.all(0.0),
            child: Column(
              children: <Widget> [
                Padding(padding: EdgeInsets.only(top: 7.0)),
                Container(
                    alignment: Alignment.center,
                    child: Text("https://roadout.ro",
                        style: GoogleFonts.karla(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(255, 193, 25, 1.0)))),
                Padding(padding: EdgeInsets.only(top: 8.0)),
                Row(
                    children: <Widget> [
                      Padding(padding: EdgeInsets.only(left: 10.0)),
                      Text("Parking, made easy",
                          style: GoogleFonts.karla(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor)),
                      Spacer(),
                      Text("Made in Cluj",
                          style: GoogleFonts.karla(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(255, 193, 25, 1.0))),
                      Padding(padding: EdgeInsets.only(right: 10.0)),
                    ]
                )
              ]
            ),
            disabledColor: Color.fromRGBO(130, 130, 130, 0.18),
            color: Color.fromRGBO(130, 130, 130, 0.18),
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            onPressed: () async {
              if (await canLaunch('https://www.roadout.ro')) {
              await launch('https://www.roadout.ro', forceSafariVC: false);
              } else {
              throw 'Could not open the map.';
              }
            }
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 8.0)),
        Container(
          height: 50,
          padding: EdgeInsets.only(top: 5),
          child: CupertinoButton(
              padding: EdgeInsets.all(0.0),
              child: Container(
                  alignment: Alignment.center,
                  child: Text("Privacy Policy & Terms of Use",
                      style: GoogleFonts.karla(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(255, 193, 25, 1.0)))),
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
              onPressed: () {
                Navigator.pop(context);
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(23),
                        )), builder: (context) => showLegal(context));
              }
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 10.0)),
        Container(
            padding: EdgeInsets.only(bottom: 30),
            alignment: Alignment.center,
            child: Text(
              "Copyright © 2021 Codebranch",
              style:
                  GoogleFonts.karla(fontSize: 13, fontWeight: FontWeight.w500),
            ))
      ],
    ));


Widget showLegal(BuildContext context) => Container(
    height: 536,
    decoration: BoxDecoration(
      color: Theme.of(context).dialogBackgroundColor,
      borderRadius: BorderRadius.all(Radius.circular(23)),
    ),
    child: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 200,
              height: 90,
              padding: EdgeInsets.only(left: 20.0, top: 30.0),
              child: Text(
                "Legal",
                textAlign: TextAlign.left,
                style: GoogleFonts.karla(
                    fontSize: 20.0, fontWeight: FontWeight.w600),
              ),
            ),
            Spacer(),
            Container(
              height: 90,
              width: 50,
              padding: EdgeInsets.only(right: 8.0, bottom: 10),
              child: IconButton(
                icon: const Icon(CupertinoIcons.xmark, size: 23),
                onPressed: () {
                  Navigator.pop(context);
                },
                disabledColor: Color.fromRGBO(229, 167, 0, 1.0),
                color: Color.fromRGBO(229, 167, 0, 1.0),
              ),
            )
          ],
        ),
      ],
    ));

Widget showInviteFriends(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Theme.of(context).dialogBackgroundColor,
      borderRadius: BorderRadius.all(Radius.circular(23)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 100,
              height: 60,
              padding: EdgeInsets.only(left: 20.0, top: 26.0),
              child: Text(
                "Invites",
                textAlign: TextAlign.left,
                style: GoogleFonts.karla(
                    fontSize: 20.0, fontWeight: FontWeight.w600),
              ),
            ),
            Spacer(),
            Container(
              height: 60,
              width: 50,
              padding: EdgeInsets.only(right: 8.0, bottom: 10, top: 17),
              child: IconButton(
                icon: const Icon(CupertinoIcons.xmark, size: 23),
                onPressed: () {
                  Navigator.pop(context);
                },
                disabledColor: Color.fromRGBO(229, 167, 0, 1.0),
                color: Color.fromRGBO(229, 167, 0, 1.0),
              ),
            )
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width - 22,
          height: 50,
          padding: EdgeInsets.only(top: 5),
          child: CupertinoButton(
            onPressed: null,
            padding: EdgeInsets.all(0.0),
            child: Container(
                alignment: Alignment.center,
                child: Text("https://roadout.com/invite-friends",
                    style: GoogleFonts.karla(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(220, 170, 57, 1.0)))),
            disabledColor: Color.fromRGBO(130, 130, 130, 0.18),
            color: Color.fromRGBO(130, 130, 130, 0.18),
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
        ),
        Container(
          width: 274,
          height: 35,
          padding: EdgeInsets.only(top: 5),
          child: Text(
              "When you invite 5 friends you get a free reservation for a parking spot",
              textAlign: TextAlign.center,
              style: GoogleFonts.karla(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(152, 152, 152, 1.0))),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.0),
        ),
        Container(
          width: MediaQuery.of(context).size.width - 58,
          height: 80,
          padding: EdgeInsets.only(bottom: 35.0),
          child: CupertinoButton(
            padding: EdgeInsets.all(0.0),
            onPressed: () {
              Clipboard.setData(
                  ClipboardData(text: "https://roadout.com/invite-friends"));
            },
            child: Text("Copy Invite Link",
                style: GoogleFonts.karla(
                    fontSize: 16.0, fontWeight: FontWeight.w600)),
            disabledColor: Color.fromRGBO(220, 170, 57, 1.0),
            color: Color.fromRGBO(220, 170, 57, 1.0),
            borderRadius: BorderRadius.all(Radius.circular(13.0)),
          ),
        )
      ],
    ));

Widget showAddCard(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Theme.of(context).dialogBackgroundColor,
      borderRadius: BorderRadius.all(Radius.circular(23)),
    ),
    padding: MediaQuery.of(context).viewInsets,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 15.0)),
        Row(
          children: <Widget>[
            Container(
              width: 200,
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                "Add Card",
                textAlign: TextAlign.left,
                style: GoogleFonts.karla(
                    fontSize: 20.0, fontWeight: FontWeight.w600),
              ),
            ),
            Spacer(),
            Container(
              width: 50,
              padding: EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: const Icon(CupertinoIcons.xmark, size: 23),
                onPressed: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                        top: Radius.circular(23),
                      )),
                      builder: (context) => showPayment(context));
                },
                disabledColor: Color.fromRGBO(149, 46, 0, 1.0),
                color: Color.fromRGBO(149, 46, 0, 1.0),
              ),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(left: 20.0)),
            InkWell(
              child: Container(
                width: 85,
                height: 47,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                       color1,
                        color2
                      ]),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                      top: Radius.circular(23),
                    )),
                    builder: (context) => showCardStyle(context));
              },
            ),
            Padding(padding: EdgeInsets.only(left: 15.0)),
            Expanded(
                child: Container(
              height: 45,
              child: TextFormField(
                controller: expiryController,
                cursorColor: Color.fromRGBO(103, 72, 5, 1.0),
                autocorrect: false,
                keyboardAppearance: MediaQuery.of(context).platformBrightness,
                decoration: InputDecoration(
                    labelText: 'MM/YY',
                    labelStyle: TextStyle(
                        color: Color.fromRGBO(103, 72, 5, 1.0),
                        fontWeight: FontWeight.w600),
                    filled: true,
                    fillColor: Color.fromRGBO(103, 72, 5, 0.22),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3, color: Color.fromRGBO(103, 72, 5, 0.0)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3, color: Color.fromRGBO(255, 158, 25, 0.0)),
                      borderRadius: BorderRadius.circular(15),
                    )),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  CreditCardExpirationDateFormatter(),
                 MaskedInputFormatter(
                    "##/##",
                    allowedCharMatcher: RegExp('[0-9]'),
                  ),
                ],

              ),
            )),
            Padding(padding: EdgeInsets.only(left: 10.0)),
            Expanded(
                child: Container(
              height: 45,
              child: TextFormField(
                inputFormatters: [
                  MaskedInputFormatter(
                    "###",
                    allowedCharMatcher: RegExp('[0-9]'),
                  ),
                ],
                controller: cvvController,
                cursorColor: Color.fromRGBO(103, 72, 5, 1.0),
                autocorrect: false,
                keyboardAppearance: MediaQuery.of(context).platformBrightness,
                decoration: InputDecoration(
                    labelText: 'CVV',
                    labelStyle: TextStyle(
                        color: Color.fromRGBO(103, 72, 5, 1.0),
                        fontWeight: FontWeight.w600),
                    filled: true,
                    fillColor: Color.fromRGBO(103, 72, 5, 0.22),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3, color: Color.fromRGBO(103, 72, 5, 0.0)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3, color: Color.fromRGBO(255, 158, 25, 0.0)),
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),
            )),
            Padding(padding: EdgeInsets.only(right: 22.0)),
          ],
        ),
        Padding(padding: EdgeInsets.only(top: 10.0)),
        Container(
            height: 55,
            padding: EdgeInsets.only(left: 20, right: 22, bottom: 10),
            child: TextFormField(
              controller: nameController,
              cursorColor: Color.fromRGBO(255, 158, 25, 1.0),
              autocorrect: false,
              keyboardAppearance: MediaQuery.of(context).platformBrightness,
              decoration: InputDecoration(
                  labelText: 'Card Holder',
                  labelStyle: TextStyle(
                      color: Color.fromRGBO(215, 109, 0, 1.0),
                      fontWeight: FontWeight.w600),
                  filled: true,
                  fillColor: Color.fromRGBO(215, 109, 0, 0.22),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 3, color: Color.fromRGBO(215, 109, 0, 0.0)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 3, color: Color.fromRGBO(215, 109, 0, 0.0)),
                    borderRadius: BorderRadius.circular(15),
                  )),
            )),
        Container(
            height: 55,
            padding: EdgeInsets.only(left: 20, right: 22, bottom: 10),
            child: TextFormField(
              inputFormatters: [
                MaskedInputFormatter(
                  "#### #### #### ####",
                  allowedCharMatcher: RegExp('[0-9]'),
                ),
              ],
              controller: numberController,
              cursorColor: Color.fromRGBO(255, 193, 25, 1.0),
              autocorrect: false,
              keyboardAppearance: MediaQuery.of(context).platformBrightness,
              decoration: InputDecoration(
                  labelText: 'Card Number',
                  labelStyle: TextStyle(
                      color: Color.fromRGBO(149, 46, 0, 1.0),
                      fontWeight: FontWeight.w600),
                  filled: true,
                  fillColor: Color.fromRGBO(149, 46, 0, 0.22),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 3, color: Color.fromRGBO(149, 46, 0, 0.0)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 3, color: Color.fromRGBO(149, 46, 0, 0.0)),
                    borderRadius: BorderRadius.circular(15),
                  )),
            )),
        Padding(padding: EdgeInsets.only(top: 20.0)),
        Container(
          width: MediaQuery.of(context).size.width - 58,
          height: 45,
          child: CupertinoButton(
            padding: EdgeInsets.all(0.0),
            child: Text(
              'Add',
              style: GoogleFonts.karla(
                  fontSize: 17.0, fontWeight: FontWeight.w600),
            ),
            onPressed: () => {
              month1 = int.parse(expiryController.text[0]),
              month2 = int.parse(expiryController.text[1]),
                if(month1 >1 || month1 == 1 && month2 >2 || month1 == 0 && month2 == 0){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        insetPadding: EdgeInsets.all(40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        title: Text('Card Expiring Date Error', style: GoogleFonts.karla(
                            fontSize: 20.0, fontWeight: FontWeight.w600)),
                        content: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget> [
                                Text('Please enter your correct credit card expiring date!', style: GoogleFonts.karla(
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
                  )
                } else if(cvvController.text == ''  || cvvController.text.isEmpty || expiryController.text == ''  || expiryController.text.isEmpty ||
                  numberController.text == ''  || numberController.text.isEmpty || nameController.text == ''  || nameController.text.isEmpty
              ){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      insetPadding: EdgeInsets.all(40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      title: Text('Credit Card Error', style: GoogleFonts.karla(
                          fontSize: 20.0, fontWeight: FontWeight.w600)),
                      content: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget> [
                              Text('Please enter all your credit card information!', style: GoogleFonts.karla(
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
                )
              } else
                {
                  cards.add(
                   Dismissible(
                     key: Key(cards.length.toString()),
                       direction: DismissDirection.endToStart,
                       onDismissed: (direction){
                         cards.removeAt(cards.length-1);
                       },
                       background: Container(
                           margin: EdgeInsets.symmetric(horizontal: 15),
                           alignment: Alignment.centerRight,
                           child: Icon(CupertinoIcons.trash, color: Color.fromRGBO(
                               149, 46, 0, 1.0))
                       ),
                       child:Center(
                      child: _cardTile(
                          '**** **** **** ${numberController.text[15]}${numberController.text[16]}${numberController.text[17]}${numberController.text[18]}',
                          LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [
                                color1,
                               color2
                              ]),
                         color2,
                    ),
                    ))
                  ),
                  Navigator.pop(context),
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                        top: Radius.circular(23),
                      )),
                      builder: (context) => showPayment(context))
                }
            },
            disabledColor: Color.fromRGBO(149, 46, 0, 1.0),
            color: Color.fromRGBO(149, 46, 0, 1.0),
            borderRadius: BorderRadius.all(Radius.circular(13.0)),
          ),
        ),
        Padding(padding: EdgeInsets.only(bottom: 30.0)),
      ],
    ));

Widget showCardStyle(BuildContext context) =>
    StatefulBuilder(builder: (BuildContext context, StateSetter setState){
    return Container(
    height: 285,
    decoration: BoxDecoration(
      color: Theme.of(context).dialogBackgroundColor,
      borderRadius: BorderRadius.all(Radius.circular(23)),
    ),
    child: Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 10.0)),
        Row(
          children: <Widget>[
            Container(
              width: 200,
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                "Card Style",
                textAlign: TextAlign.left,
                style: GoogleFonts.karla(
                    fontSize: 20.0, fontWeight: FontWeight.w600),
              ),
            ),
            Spacer(),
            Container(
              width: 50,
              padding: EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: const Icon(CupertinoIcons.xmark, size: 23),
                onPressed: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                        top: Radius.circular(23),
                      )),
                      builder: (context) => showAddCard(context));
                },
                disabledColor: Colors.grey,
                color: Colors.grey,
              ),
            )
          ],
        ),
        Padding(padding: EdgeInsets.only(top: 10.0)),
        Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  left: (MediaQuery.of(context).size.width - 303) / 2),
            ),
            InkWell(
              child: Container(
                width: 85,
                height: 47,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(255, 193, 25, 1.0),
                        Color.fromRGBO(103, 72, 5, 1.0)
                      ]),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              onTap: () {
                setState((){
                  color1 =  Color.fromRGBO(255, 193, 25, 1.0);
                  color2 =   Color.fromRGBO(103, 72, 5, 1.0);
                });
                Navigator.pop(context);
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                      top: Radius.circular(23),
                    )),
                    builder: (context) => showAddCard(context));
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 24.0),
            ),
            InkWell(
              child: Container(
                width: 85,
                height: 47,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Color.fromRGBO(255, 158, 25, 1.0),
                        Color.fromRGBO(57, 49, 30, 1.0)
                      ]),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              onTap: () {
                setState((){
                  color1 =  Color.fromRGBO(255, 158, 25, 1.0);
                  color2 =  Color.fromRGBO(57, 49, 30, 1.0);
                });
                Navigator.pop(context);
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                      top: Radius.circular(23),
                    )),
                    builder: (context) => showAddCard(context));
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 24.0),
            ),
            InkWell(
              child: Container(
                width: 85,
                height: 47,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color.fromRGBO(214, 109, 0, 1.0),
                        Color.fromRGBO(66, 109, 121, 1.0)
                      ]),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              onTap: () {
                setState((){
                  color1 =   Color.fromRGBO(214, 109, 0, 1.0);
                  color2 =   Color.fromRGBO(66, 109, 121, 1.0);
                });
                Navigator.pop(context);
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                      top: Radius.circular(23),
                    )),
                    builder: (context) => showAddCard(context));
              },
            ),
          ],
        ),
        Padding(padding: EdgeInsets.only(top: 20.0)),
        Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  left: (MediaQuery.of(context).size.width - 303) / 2),
            ),
            InkWell(
              child: Container(
                width: 85,
                height: 47,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(149, 46, 0, 1.0),
                        Color.fromRGBO(245, 204, 108, 1.0)
                      ]),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              onTap: () {
                setState((){
                  color1 =   Color.fromRGBO(149, 46, 0, 1.0);
                  color2 =   Color.fromRGBO(245, 204, 108, 1.0);
                });
                Navigator.pop(context);
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                      top: Radius.circular(23),
                    )),
                    builder: (context) => showAddCard(context));
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 24.0),
            ),
            InkWell(
              child: Container(
                width: 85,
                height: 47,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(149, 46, 0, 1.0),
                        Color.fromRGBO(11, 7, 0, 1.0)
                      ]),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              onTap: () {
                setState((){
                  color1 =   Color.fromRGBO(149, 46, 0, 1.0);
                  color2 =   Color.fromRGBO(11, 7, 0, 1.0);
                });
                Navigator.pop(context);
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                      top: Radius.circular(23),
                    )),
                    builder: (context) => showAddCard(context));
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 24.0),
            ),
            InkWell(
              child: Container(
                width: 85,
                height: 47,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(143, 102, 13, 1.0),
                        Color.fromRGBO(245, 232, 204, 1.0)
                      ]),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              onTap: () {
                setState((){
                  color1 =   Color.fromRGBO(143, 102, 13, 1.0);
                  color2 =    Color.fromRGBO(245, 232, 204, 1.0);
                });
                Navigator.pop(context);
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                      top: Radius.circular(23),
                    )),
                    builder: (context) => showAddCard(context));
              },
            ),
          ],
        ),
        Padding(padding: EdgeInsets.only(top: 20.0)),
        Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  left: (MediaQuery.of(context).size.width - 303) / 2),
            ),
            InkWell(
              child: Container(
                width: 85,
                height: 47,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color.fromRGBO(255, 193, 25, 1.0),
                        Color.fromRGBO(111, 2, 95, 1.0)
                      ]),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              onTap: () {
                setState((){
                  color1 =   Color.fromRGBO(255, 193, 25, 1.0);
                  color2 =    Color.fromRGBO(111, 2, 95, 1.0);
                });
                Navigator.pop(context);
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                      top: Radius.circular(23),
                    )),
                    builder: (context) => showAddCard(context));
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 24.0),
            ),
            InkWell(
              child: Container(
                width: 85,
                height: 47,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(214, 109, 0, 1.0),
                        Color.fromRGBO(70, 92, 205, 1.0)
                      ]),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              onTap: () {
                setState((){
                  color1 = Color.fromRGBO(214, 109, 0, 1.0);
                  color2 =   Color.fromRGBO(70, 92, 205, 1.0);
                });
                Navigator.pop(context);
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                      top: Radius.circular(23),
                    )),
                    builder: (context) => showAddCard(context));
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 24.0),
            ),
            InkWell(
              child: Container(
                width: 85,
                height: 47,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color.fromRGBO(143, 102, 13, 1.0),
                        Color.fromRGBO(219, 0, 70, 1.0)
                      ]),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              onTap: () {
                setState((){
                  color1 =  Color.fromRGBO(143, 102, 13, 1.0);
                  color2 =   Color.fromRGBO(219, 0, 70, 1.0);
                });
                Navigator.pop(context);
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                      top: Radius.circular(23),
                    )),
                    builder: (context) => showAddCard(context));
              },
            ),
          ],
        ),
      ],
    ));});

Widget showPrizes(BuildContext context, String themeName) {
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return Container(
        height: 420,
        decoration: BoxDecoration(
          color: Theme.of(context).dialogBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(23)),
        ),
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Row(
              children: <Widget>[
                Container(
                  width: 200,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Prizes",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.karla(
                        fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                ),
                Spacer(),
                Container(
                  width: 50,
                  padding: EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    icon: const Icon(CupertinoIcons.xmark, size: 23),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    disabledColor: Colors.grey,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(
                        left: (MediaQuery.of(context).size.width - 280) / 2)),
                Container(
                  width: 50,
                  padding: EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    icon: const Icon(CupertinoIcons.chevron_left_2, size: 30),
                    onPressed: () {
                      if (currentPrize > 0) {
                        currentPrize -= 1;
                        setState(() {});
                      }
                    },
                    disabledColor: Colors.grey,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  width: 180,
                  height: 180,
                  child: Image.asset('assets/prizes/' +
                      prizes[currentPrize] +
                      '-' +
                      themeName +
                      '.png'),
                ),
                Container(
                  width: 50,
                  padding: EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    icon: const Icon(CupertinoIcons.chevron_right_2, size: 30),
                    onPressed: () {
                      if (currentPrize < 4) {
                        currentPrize += 1;
                        setState(() {});
                      }
                    },
                    disabledColor: Colors.grey,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Row(children: <Widget>[
              Padding(padding: EdgeInsets.only(left: 25)),
              Container(
                  alignment: Alignment.center,
                  height: 30,
                  width: MediaQuery.of(context).size.width - 50,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(130, 130, 130, 0.18),
                    borderRadius: BorderRadius.all(Radius.circular(9)),
                  ),
                  child: Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top: 10.0, left: 15.0)),
                      Text(
                        'For every prize you get one free reservation',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.karla(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: prizeTextColors[currentPrize]),
                      )
                    ],
                  )),
            ]),
            Padding(padding: EdgeInsets.only(top: 7)),
            Row(children: <Widget>[
              Padding(padding: EdgeInsets.only(left: 25)),
              Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: MediaQuery.of(context).size.width - 50,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(130, 130, 130, 0.18),
                    borderRadius: BorderRadius.all(Radius.circular(9)),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Icon(
                          CupertinoIcons.checkmark,
                          color: prizeButtonColors[currentPrize],
                        ),
                        padding: EdgeInsets.only(left: 10.0),
                      ),
                      Padding(padding: EdgeInsets.only(left: 10.0)),
                      Container(
                          width: MediaQuery.of(context).size.width - 100,
                          child: Text(
                            prizeChallenges[currentPrize],
                            textAlign: TextAlign.left,
                            style: GoogleFonts.karla(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).accentColor),
                          ))
                    ],
                  )),
            ]),
            Padding(padding: EdgeInsets.only(top: 10)),
            Container(
              width: MediaQuery.of(context).size.width - 58,
              height: 45,
              child: CupertinoButton(
                padding: EdgeInsets.all(0.0),
                child: Text(
                  'Share',
                  style: GoogleFonts.karla(
                      fontSize: 17.0, fontWeight: FontWeight.w600),
                ),
                onPressed: () => {},
                disabledColor: prizeButtonColors[currentPrize],
                color: prizeButtonColors[currentPrize],
                borderRadius: BorderRadius.all(Radius.circular(13.0)),
              ),
            ),
          ],
        ));
  });
}

Widget showPermissions(BuildContext context, String themeName) {
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    late Position currentPosition;
    LatLng latlngPos = LatLng(46.7712, 23.6236);
    LocationPermission permission;
    return Container(
        height: 470,
        decoration: BoxDecoration(
          color: Theme.of(context).dialogBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(23)),
        ),
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 23.0)),
            Row(
              children: <Widget>[
                Container(
                  width: 200,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Permissions",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.karla(
                        fontSize: 22.0, fontWeight: FontWeight.w600),
                  ),
                ),
                Spacer(),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 2 - 90),
                ),
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                      spreadRadius: -17,
                      blurRadius: 40,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ]),
                  child: Image.asset('assets/permissions/' +
                      permissions[currentPermission] +
                      themeName +
                      '.png'),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Container(
              width: MediaQuery.of(context).size.width - 40,
              child: Text(
                permissionTexts[currentPermission],
                textAlign: TextAlign.center,
                style: GoogleFonts.karla(
                    fontSize: 15.0, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 15.0)),
            Container(
              width: MediaQuery.of(context).size.width - 58,
              height: 45,
              child: CupertinoButton(
                padding: EdgeInsets.all(0.0),
                child: Text(
                  'Allow',
                  style: GoogleFonts.karla(
                      fontSize: 17.0, fontWeight: FontWeight.w600),
                ),
                onPressed: () async => {
                  if (currentPermission == 0)
                    {
                      requestNotificationPermission(),
                      currentPermission += 1,
                      setState(() {})
                    }
                  else
                    {
                      permission = await Geolocator.checkPermission(),
                      if (permission == LocationPermission.denied ||
                          permission == LocationPermission.deniedForever)
                        {
                          AppSettings.openLocationSettings(),
                          _saveNeverLaunched(),
                          Navigator.pop(context)
                        }
                      else
                        {
                          currentPosition = await Geolocator.getCurrentPosition(
                              desiredAccuracy:
                                  LocationAccuracy.bestForNavigation),
                          latlngPos = LatLng(currentPosition.latitude,
                              currentPosition.longitude),
                          print(latlngPos),
                          _saveNeverLaunched(),
                          Navigator.pop(context),
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                insetPadding: EdgeInsets.all(40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                title: Text('Tutorial', style: GoogleFonts.karla(
                                    fontSize: 20.0, fontWeight: FontWeight.w600)),
                                content: Container(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget> [
                                      Text('Would you like a quick tutorial of the app?', style: GoogleFonts.karla(
                                          fontSize: 17.0, fontWeight: FontWeight.w500)),
                                      Container(
                                          padding: EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
                                          width: MediaQuery.of(context).size.width-100,
                                          height: 60,
                                          child: CupertinoButton(
                                            padding: EdgeInsets.all(0.0),
                                            child: Text('Yes', style: GoogleFonts.karla(fontSize: 18.0, fontWeight: FontWeight.w600),),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.vertical(
                                                        top: Radius.circular(23),
                                                      )),
                                                  // BorderRadius. vertical// RoundedRectangleBorder
                                                  builder: (context) => showTutorial(context)
                                              );
                                            },
                                            disabledColor: Color.fromRGBO(255, 193, 25, 1.0),
                                            color: Color.fromRGBO(255, 193, 25, 1.0),
                                            borderRadius: BorderRadius.all(Radius.circular(13.0)),
                                          )
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
                                          width: 250,
                                          height: 40,
                                          child: CupertinoButton(
                                            padding: EdgeInsets.all(0.0),
                                            child: Text('No Thanks', style: GoogleFonts.karla(fontSize: 18.0, fontWeight: FontWeight.w600, color: Color.fromRGBO(255, 193, 25, 1.0)),),
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
                          )
                        },
                    }
                },
                disabledColor: permissionColors[currentPermission],
                color: permissionColors[currentPermission],
                borderRadius: BorderRadius.all(Radius.circular(13.0)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.0),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 58,
              height: 33,
              child: CupertinoButton(
                padding: EdgeInsets.all(0.0),
                child: Text(
                  'Maybe Later',
                  style: GoogleFonts.karla(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600,
                      color: permissionColors[currentPermission]),
                ),
                onPressed: () => {
                  if (currentPermission == 0)
                    {currentPermission += 1, setState(() {})}
                  else {
                      _saveNeverLaunched(),
                      Navigator.pop(context),
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          insetPadding: EdgeInsets.all(40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          title: Text('Tutorial', style: GoogleFonts.karla(
                              fontSize: 20.0, fontWeight: FontWeight.w600)),
                          content: Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget> [
                                  Text('Would you like a quick tutorial of the app?', style: GoogleFonts.karla(
                                      fontSize: 17.0, fontWeight: FontWeight.w500)),
                                  Container(
                                      padding: EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
                                      width: MediaQuery.of(context).size.width-100,
                                      height: 60,
                                      child: CupertinoButton(
                                        padding: EdgeInsets.all(0.0),
                                        child: Text('Yes', style: GoogleFonts.karla(fontSize: 18.0, fontWeight: FontWeight.w600),),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.vertical(
                                                    top: Radius.circular(23),
                                                  )),
                                              // BorderRadius. vertical// RoundedRectangleBorder
                                              builder: (context) => showTutorial(context)
                                          );
                                        },
                                        disabledColor: Color.fromRGBO(255, 193, 25, 1.0),
                                        color: Color.fromRGBO(255, 193, 25, 1.0),
                                        borderRadius: BorderRadius.all(Radius.circular(13.0)),
                                      )
                                  ),
                                  Container(
                                      padding: EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
                                      width: 250,
                                      height: 40,
                                      child: CupertinoButton(
                                        padding: EdgeInsets.all(0.0),
                                        child: Text('No Thanks', style: GoogleFonts.karla(fontSize: 18.0, fontWeight: FontWeight.w600, color: Color.fromRGBO(255, 193, 25, 1.0)),),
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
                    )
                  }
                },
                borderRadius: BorderRadius.all(Radius.circular(13.0)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
            )
          ],
        ));
  });
}

Widget showTutorial(BuildContext context) {
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    late Position currentPosition;
    LatLng latlngPos = LatLng(46.7712, 23.6236);
    LocationPermission permission;
    return Container(
        height: 430,
        decoration: BoxDecoration(
          color: Theme.of(context).dialogBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(23)),
        ),
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 23.0)),
            Row(
              children: <Widget>[
                Container(
                  width: 200,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Tutorial",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.karla(
                        fontSize: 22.0, fontWeight: FontWeight.w600),
                  ),
                ),
                Spacer(),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: tutorialPaddings[currentTutorial])),
            Center(
              child: Container(
                  height: tutorialHeights[currentTutorial],
                  child: Image.asset('assets/tutorial/' +
                      tutorialImages[currentTutorial] + '.png'),
                ),

            ),
            Padding(padding: EdgeInsets.only(top: tutorialPaddings[currentTutorial])),
            Text(
              tutorials[currentTutorial],
              textAlign: TextAlign.center,
              style: GoogleFonts.karla(
                  fontSize: 17.0, fontWeight: FontWeight.w600, color: tutorialColors[currentTutorial]),
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Container(
              width: MediaQuery.of(context).size.width - 40,
              child: Text(
                tutorialTexts[currentTutorial],
                textAlign: TextAlign.center,
                style: GoogleFonts.karla(
                    fontSize: 15.0, fontWeight: FontWeight.w600),
              ),
            ),
            Spacer(),
            Container(
              width: MediaQuery.of(context).size.width - 58,
              height: 45,
              child: CupertinoButton(
                padding: EdgeInsets.all(0.0),
                child: Text(
                  tutorialTopBtns[currentTutorial],
                  style: GoogleFonts.karla(
                      fontSize: 17.0, fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  if (currentTutorial == 2)
                    Navigator.pop(context);
                  else
                    currentTutorial += 1;
                    setState(() {});
                },
                disabledColor: tutorialColors[currentTutorial],
                color: tutorialColors[currentTutorial],
                borderRadius: BorderRadius.all(Radius.circular(13.0)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.0),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 58,
              height: 45,
              child: CupertinoButton(
                padding: EdgeInsets.all(0.0),
                child: Text(
                  tutorialBottomBtns[currentTutorial],
                  style: GoogleFonts.karla(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600,
                      color: tutorialColors[currentTutorial]),
                ),
                onPressed: () => {
                if (currentTutorial == 0)
                  Navigator.pop(context)
                else
                  currentTutorial -= 1, setState(() {})
                },
                borderRadius: BorderRadius.all(Radius.circular(13.0)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
            )
          ],
        ));
  });
}

Widget showEditAccount(BuildContext context, SharedPreferences preferences) {
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
   return Container(
      //height: editHeight,
      width: 390,
       decoration: BoxDecoration(
         color: Theme.of(context).dialogBackgroundColor,
         borderRadius: BorderRadius.all(Radius.circular(23)),
       ),
      padding: MediaQuery.of(context).viewInsets,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 10)),
          Row(
            children: <Widget>[
              Container(
                width: 200,
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  "Edit Account",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.karla(
                      fontSize: 20.0, fontWeight: FontWeight.w600),
                ),
              ),
              Spacer(),
              Container(
                width: 50,
                padding: EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: const Icon(CupertinoIcons.xmark, size: 23),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  disabledColor: Color.fromRGBO(220, 170, 57, 1.0),
                  color: Color.fromRGBO(220, 170, 57, 1.0),
                ),
              )
            ],
          ),
          decideEditStuff(context, setState)
        ],
      ),
    );
  });
}
Widget decideEditStuff(BuildContext context, StateSetter setState) {
  if (editHeight == 384) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            Container(width: (MediaQuery.of(context).size.width-313)/2),
            Container(
                height: 40,
                width: 149,
                child: CupertinoButton(
                  padding: EdgeInsets.all(0.0),
                  child: Text(
                      'Change Name',
                      style: GoogleFonts.karla(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(220, 170, 57, 1.0),
                      )),
                  onPressed: () => {
                    editHeight = 320,
                    setState(() {})
                  },
                )
            ),
            Container(width: 15.0),
            Container(
                height: 40,
                width: 149,
                child: CupertinoButton(
                  padding: EdgeInsets.all(0.0),
                  child: Text(
                      'Change Password',
                      style: GoogleFonts.karla(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      )),
                  onPressed: () => {

                  },
                  borderRadius: BorderRadius.all(Radius.circular(13.0)),
                  color: Color.fromRGBO(220, 170, 57, 1.0),
                  disabledColor: Color.fromRGBO(220, 170, 57, 1.0),

                )
            )
          ],
        ),
        Column(children: <Widget>[
          Container(
              height: 60,
              padding:
              EdgeInsets.only(left: 24, right: 24, bottom: 10, top: 10),
              child: TextFormField(
                controller: oldPsw,
                cursorColor: Color.fromRGBO(214, 109, 0, 1.0),
                obscureText: true,
                autocorrect: false,
                keyboardAppearance: MediaQuery.of(context).platformBrightness,
                decoration: InputDecoration(
                    labelText: 'Old Password',
                    labelStyle: TextStyle(
                        color: Color.fromRGBO(214, 109, 0, 1.0),
                        fontWeight: FontWeight.w600),
                    filled: true,
                    fillColor: Color.fromRGBO(214, 109, 0, 0.44),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3, color: Color.fromRGBO(214, 109, 0, 0.0)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3, color: Color.fromRGBO(214, 109, 0, 0.0)),
                      borderRadius: BorderRadius.circular(12),
                    )),
              )),
          Container(
              height: 50,
              padding: EdgeInsets.only(left: 24, right: 24, bottom: 10),
              child: TextFormField(
                controller: newPsw,
                cursorColor: Color.fromRGBO(143, 102, 13, 1.0),
                obscureText: true,
                autocorrect: false,
                keyboardAppearance: MediaQuery.of(context).platformBrightness,
                decoration: InputDecoration(
                    labelText: 'New Password',
                    labelStyle: TextStyle(
                        color: Color.fromRGBO(143, 102, 13, 1.0),
                        fontWeight: FontWeight.w600),
                    filled: true,
                    fillColor: Color.fromRGBO(143, 102, 13, 0.44),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3, color: Color.fromRGBO(143, 102, 13, 0.0)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3, color: Color.fromRGBO(143, 102, 13, 0.0)),
                      borderRadius: BorderRadius.circular(12),
                    )),
              )),
          Container(
              height: 50,
              padding: EdgeInsets.only(left: 24, right: 24, bottom: 10),
              child: TextFormField(
                controller: confPsw,
                cursorColor: Color.fromRGBO(220, 170, 57, 1.0),
                obscureText: true,
                autocorrect: false,
                keyboardAppearance: MediaQuery.of(context).platformBrightness,
                decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    labelStyle: TextStyle(
                        color: Color.fromRGBO(220, 170, 57, 1.0),
                        fontWeight: FontWeight.w600),
                    filled: true,
                    fillColor: Color.fromRGBO(220, 170, 57, 0.44),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3, color: Color.fromRGBO(220, 170, 57, 0.0)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3, color: Color.fromRGBO(220, 170, 57, 0.0)),
                      borderRadius: BorderRadius.circular(12),
                    )),
              )),
          Container(
            height: 60,
            width: MediaQuery.of(context).size.width-58,
            padding: EdgeInsets.only(top: 15),
            child: CupertinoButton(
              onPressed: () {
                const patternPassword =
                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
                final regExpPassword = RegExp(patternPassword);
                if (!regExpPassword.hasMatch(newPsw.text)) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        insetPadding: EdgeInsets.all(40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        title: Text('Failure', style: GoogleFonts.karla(
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
                } else if (newPsw.text != confPsw.text) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        insetPadding: EdgeInsets.all(40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        title: Text('Failure', style: GoogleFonts.karla(
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
                } else {
                  DatabaseService().updateUserPsw(newPsw.text,oldPsw.text,context);
                  print("bine");
                  oldPsw.text = "";
                  newPsw.text = "";
                  confPsw.text = "";
                }
              },
              child: Text(
                "Done",
                style: GoogleFonts.karla(
                    fontSize: 17.0, fontWeight: FontWeight.w600),
              ),
              padding: EdgeInsets.all(0.0),
              disabledColor: Color.fromRGBO(220, 170, 57, 1.0),
              borderRadius: BorderRadius.all(Radius.circular(13.0)),
              color: Color.fromRGBO(220, 170, 57, 1.0),
            ),
          ),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width - 58,
            child: CupertinoButton(
              onPressed: ()  {
                showDialog(
                    context: context,
                    builder:
                        (BuildContext context) {
                      return AlertDialog(
                        insetPadding:
                        EdgeInsets.all(40),
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(
                              20.0),
                        ),
                        title: Text('Delete Account',
                            style:
                            GoogleFonts.karla(
                                fontSize: 20.0,
                                fontWeight:
                                FontWeight
                                    .w600)),
                        content: Container(
                            child: Column(
                              mainAxisSize:
                              MainAxisSize.min,
                              children: <Widget>[
                                Text('This is NOT reversible! Are you sure you want to delete you account? You will lose all the data saved on this account',
                                    style: GoogleFonts.karla(
                                        fontSize: 17.0,
                                        fontWeight:
                                        FontWeight
                                            .w500)),
                                Container(
                                    padding:
                                    EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
                                    width: MediaQuery.of(context).size.width - 100,
                                    height: 60,
                                    child:
                                    CupertinoButton(
                                      padding: EdgeInsets.all(0.0),
                                      child: Text('Yes', style: GoogleFonts.karla(fontSize: 18.0, fontWeight: FontWeight.w600),),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        showDialog(
                                            context: context,
                                            builder:
                                                (BuildContext context) {
                                              return AlertDialog(
                                                insetPadding:
                                                EdgeInsets.all(40),
                                                shape:
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      20.0),
                                                ),
                                                title: Text('Are you sure?',
                                                    style:
                                                    GoogleFonts.karla(
                                                        fontSize: 20.0,
                                                        fontWeight:
                                                        FontWeight
                                                            .w600)),
                                                content: Container(
                                                    child: Column(
                                                      mainAxisSize:
                                                      MainAxisSize.min,
                                                      children: <Widget>[
                                                        Text('Please enter your email and password',
                                                            style: GoogleFonts.karla(fontSize: 17.0, fontWeight: FontWeight.w500)),
                                                        Padding(padding: EdgeInsets.only(top: 10.0),),
                                                        Column(
                                                          children: <Widget>[
                                                            Container(
                                                                height: 45,
                                                                width: 280,
                                                                padding: EdgeInsets.only(bottom: 10),
                                                                child: TextFormField(
                                                                  controller: deleteEmailController,
                                                                  cursorColor: Color.fromRGBO(149, 46, 0, 1.0),
                                                                  autocorrect: false,
                                                                  keyboardAppearance: MediaQuery.of(context).platformBrightness,
                                                                  decoration: InputDecoration(
                                                                      labelText: 'Email',
                                                                      labelStyle: TextStyle(
                                                                          color: Color.fromRGBO(149, 46, 0, 1.0),
                                                                          fontWeight: FontWeight.w600),
                                                                      filled: true,
                                                                      fillColor: Color.fromRGBO(149, 46, 0, 0.22),
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
                                                                        borderRadius: BorderRadius.circular(12),
                                                                      )),
                                                                )),
                                                            Container(
                                                                height: 40,
                                                                width: 280,
                                                                padding: EdgeInsets.only(bottom: 5),
                                                                child: TextFormField(
                                                                  controller: deletePasswordController,
                                                                  cursorColor: Color.fromRGBO(149, 46, 0, 1.0),
                                                                  obscureText: true,
                                                                  autocorrect: false,
                                                                  keyboardAppearance: MediaQuery.of(context).platformBrightness,
                                                                  decoration: InputDecoration(
                                                                      labelText: 'Password',
                                                                      labelStyle: TextStyle(
                                                                          color: Color.fromRGBO(149, 46, 0, 1.0),
                                                                          fontWeight: FontWeight.w600),
                                                                      filled: true,
                                                                      fillColor: Color.fromRGBO(149, 46, 0, 0.22),
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
                                                                        borderRadius: BorderRadius.circular(12),
                                                                      )),
                                                                ))
                                                          ],
                                                        ),
                                                        Container(
                                                            padding:
                                                            EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
                                                            width: MediaQuery.of(context).size.width - 100,
                                                            height: 50,
                                                            child:
                                                            CupertinoButton(
                                                              padding: EdgeInsets.all(0.0),
                                                              child: Text('Delete Account', style: GoogleFonts.karla(fontSize: 18.0, fontWeight: FontWeight.w600),),
                                                              onPressed: () async {
                                                                Navigator.pop(context);
                                                                Navigator.of(context).push(_createRouteAfterSignOut(context));
                                                                userDeleted = await deleteUser(deleteEmailController.text, deletePasswordController.text, context);
                                                              },
                                                              disabledColor:
                                                              Color.fromRGBO(149, 46, 0, 1.0),
                                                              color: Color.fromRGBO(149, 46, 0, 1.0),
                                                              borderRadius: BorderRadius.all(Radius.circular(13.0)),
                                                            )),
                                                        Container(
                                                            padding:
                                                            EdgeInsets.only(
                                                                top: 15.0,
                                                                left: 5.0,
                                                                right: 5.0),
                                                            width: 250,
                                                            height: 40,
                                                            child: CupertinoButton(
                                                              padding: EdgeInsets.all(0.0),
                                                              child: Text('Cancel', style: GoogleFonts.karla(fontSize: 18.0, fontWeight: FontWeight.w600,
                                                                  color: Color.fromRGBO(149, 46, 0, 1.0)),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.pop(context);
                                                              },
                                                              borderRadius: BorderRadius.all(Radius.circular(13.0)),
                                                            ))
                                                      ],
                                                    )),
                                              );
                                            });
                                      },
                                      disabledColor:
                                      Color.fromRGBO(149, 46, 0, 1.0),
                                      color: Color.fromRGBO(149, 46, 0, 1.0),
                                      borderRadius: BorderRadius.all(Radius.circular(13.0)),
                                    )),
                                Container(
                                    padding:
                                    EdgeInsets.only(
                                        top: 15.0,
                                        left: 5.0,
                                        right: 5.0),
                                    width: 250,
                                    height: 40,
                                    child: CupertinoButton(
                                      padding: EdgeInsets.all(0.0),
                                      child: Text('Cancel', style: GoogleFonts.karla(fontSize: 18.0, fontWeight: FontWeight.w600,
                                            color: Color.fromRGBO(149, 46, 0, 1.0)),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      borderRadius: BorderRadius.all(Radius.circular(13.0)),
                                    ))
                              ],
                            )),
                      );
                    });
              },
              child: Text(
                "Delete Account",
                style: GoogleFonts.karla(
                  fontSize: 17.0, fontWeight: FontWeight.w600, color: Color.fromRGBO(149, 46, 0, 1.0),),
              ),
              padding: EdgeInsets.all(0.0),
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 15.0))
        ])
      ],
    );
  }
  return Column(
    children: [
      Row(
        children: <Widget>[
          Container(width: (MediaQuery.of(context).size.width-313)/2),
          Container(
              height: 40,
              width: 149,
              child: CupertinoButton(
                padding: EdgeInsets.all(0.0),
                child: Text(
                    'Change Name',
                    style: GoogleFonts.karla(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    )),
                onPressed: () => {
                  print('yeee')
                },
                borderRadius: BorderRadius.all(Radius.circular(13.0)),
                color: Color.fromRGBO(220, 170, 57, 1.0),
                disabledColor: Color.fromRGBO(220, 170, 57, 1.0),
              )
          ),
          Container(width: 15.0),
          Container(
              height: 40,
              width: 149,
              child: CupertinoButton(
                padding: EdgeInsets.all(0.0),
                child: Text(
                    'Change Password',
                    style: GoogleFonts.karla(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(220, 170, 57, 1.0)
                    )),
                onPressed: () => {
                  editHeight = 384,
                  setState(() {})
                },

              )
          )
        ],
      ),
      Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(left: 27, top: 15),
                  child: Text(
                    "Current Name: ",
                    style: GoogleFonts.karla(
                        fontSize: 18.0, fontWeight: FontWeight.w600),
                  )),
              Container(
                  padding: EdgeInsets.only(top: 15),
                  child: Text(
                    username,
                    style: GoogleFonts.karla(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(220, 170, 57, 1.0)),
                  ))
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          Container(
              height: 40,
              padding: EdgeInsets.only(
                left: 25,
                right: 26,
              ),
              child: TextFormField(
                controller: changeName,
                cursorColor: Color.fromRGBO(220, 170, 57, 1.0),
                //obscureText: true,
                autocorrect: false,
                keyboardAppearance: MediaQuery
                    .of(context)
                    .platformBrightness,
                decoration: InputDecoration(
                    labelText: 'New Name',
                    labelStyle: TextStyle(
                        color: Color.fromRGBO(220, 170, 57, 1.0),
                        fontWeight: FontWeight.w600),
                    filled: true,
                    fillColor: Color.fromRGBO(220, 170, 57, 0.44),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3,
                          color: Color.fromRGBO(220, 170, 57, 0.0)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3,
                          color: Color.fromRGBO(220, 170, 57, 0.0)),
                      borderRadius: BorderRadius.circular(12),
                    )),
              )),
          Padding(padding: EdgeInsets.only(top: 15),),
          Container(
            height: 45,
            width: MediaQuery.of(context).size.width - 58,
            child: CupertinoButton(
              onPressed: () async {
                if (changeName.text == null || changeName.text.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        insetPadding: EdgeInsets.all(40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        title: Text('Failure', style: GoogleFonts.karla(
                            fontSize: 20.0, fontWeight: FontWeight.w600)),
                        content: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget> [
                                Text('Please enter your new name!', style: GoogleFonts.karla(
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
                                      disabledColor: Color.fromRGBO(255, 158, 25, 1.0),
                                      color: Color.fromRGBO(255, 158, 25, 1.0),
                                      borderRadius: BorderRadius.all(Radius.circular(13.0)),
                                    )
                                ),
                              ],
                            )
                        ),
                      );
                    },
                  );
                } else {
                  DatabaseService().updateUserData(changeName.text);
                  username = await DatabaseService().getUserData();
                  setState(() {});
                  changeName.text = " ";
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        insetPadding: EdgeInsets.all(40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        title: Text('Success', style: GoogleFonts.karla(
                            fontSize: 20.0, fontWeight: FontWeight.w600)),
                        content: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget> [
                                Text('Your name was successfully changed!', style: GoogleFonts.karla(
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
                                      disabledColor: Color.fromRGBO(255, 158, 25, 1.0),
                                      color: Color.fromRGBO(255, 158, 25, 1.0),
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
              child: Text(
                "Done",
                style: GoogleFonts.karla(
                    fontSize: 17.0, fontWeight: FontWeight.w600),
              ),
              padding: EdgeInsets.all(0.0),
              disabledColor: Color.fromRGBO(220, 170, 57, 1.0),
              borderRadius: BorderRadius.all(Radius.circular(13.0)),
              color: Color.fromRGBO(220, 170, 57, 1.0),
            ),
          ),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width - 58,
            child: CupertinoButton(
              onPressed: ()  {
                showDialog(
                    context: context,
                    builder:
                        (BuildContext context) {
                      return AlertDialog(
                        insetPadding:
                        EdgeInsets.all(40),
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(
                              20.0),
                        ),
                        title: Text('Delete Account',
                            style:
                            GoogleFonts.karla(
                                fontSize: 20.0,
                                fontWeight:
                                FontWeight
                                    .w600)),
                        content: Container(
                            child: Column(
                              mainAxisSize:
                              MainAxisSize.min,
                              children: <Widget>[
                                Text('This is NOT reversible! Are you sure you want to delete you account? You will lose all the data saved on this account',
                                    style: GoogleFonts.karla(
                                        fontSize: 17.0,
                                        fontWeight:
                                        FontWeight
                                            .w500)),
                                Container(
                                    padding:
                                    EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
                                    width: MediaQuery.of(context).size.width - 100,
                                    height: 60,
                                    child:
                                    CupertinoButton(
                                      padding: EdgeInsets.all(0.0),
                                      child: Text('Yes', style: GoogleFonts.karla(fontSize: 18.0, fontWeight: FontWeight.w600),),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                insetPadding:
                                                EdgeInsets.all(40),
                                                shape:
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      20.0),
                                                ),
                                                title: Text('Are you sure?',
                                                    style:
                                                    GoogleFonts.karla(
                                                        fontSize: 20.0,
                                                        fontWeight:
                                                        FontWeight
                                                            .w600)),
                                                content: Container(
                                                    child: Column(
                                                      mainAxisSize:
                                                      MainAxisSize.min,
                                                      children: <Widget>[
                                                        Text('Please enter your email and password',
                                                            style: GoogleFonts.karla(fontSize: 17.0, fontWeight: FontWeight.w500)),
                                                        Padding(padding: EdgeInsets.only(top: 10.0),),
                                                        Column(
                                                          children: <Widget>[
                                                            Container(
                                                                height: 45,
                                                                width: 280,
                                                                padding: EdgeInsets.only(bottom: 10),
                                                                child: TextFormField(
                                                                  controller: deleteEmailController,
                                                                  cursorColor: Color.fromRGBO(149, 46, 0, 1.0),
                                                                  autocorrect: false,
                                                                  keyboardAppearance: MediaQuery.of(context).platformBrightness,
                                                                  decoration: InputDecoration(
                                                                      labelText: 'Email',
                                                                      labelStyle: TextStyle(
                                                                          color: Color.fromRGBO(149, 46, 0, 1.0),
                                                                          fontWeight: FontWeight.w600),
                                                                      filled: true,
                                                                      fillColor: Color.fromRGBO(149, 46, 0, 0.22),
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
                                                                        borderRadius: BorderRadius.circular(12),
                                                                      )),
                                                                )),
                                                            Container(
                                                                height: 40,
                                                                width: 280,
                                                                padding: EdgeInsets.only(bottom: 5),
                                                                child: TextFormField(
                                                                  controller: deletePasswordController,
                                                                  cursorColor: Color.fromRGBO(149, 46, 0, 1.0),
                                                                  obscureText: true,
                                                                  autocorrect: false,
                                                                  keyboardAppearance: MediaQuery.of(context).platformBrightness,
                                                                  decoration: InputDecoration(
                                                                      labelText: 'Password',
                                                                      labelStyle: TextStyle(
                                                                          color: Color.fromRGBO(149, 46, 0, 1.0),
                                                                          fontWeight: FontWeight.w600),
                                                                      filled: true,
                                                                      fillColor: Color.fromRGBO(149, 46, 0, 0.22),
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
                                                                        borderRadius: BorderRadius.circular(12),
                                                                      )),
                                                                ))
                                                          ],
                                                        ),
                                                        Container(
                                                            padding:
                                                            EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
                                                            width: MediaQuery.of(context).size.width - 100,
                                                            height: 50,
                                                            child:
                                                            CupertinoButton(
                                                              padding: EdgeInsets.all(0.0),
                                                              child: Text('Delete Account', style: GoogleFonts.karla(fontSize: 18.0, fontWeight: FontWeight.w600),),
                                                              onPressed: () async {
                                                                Navigator.pop(context);
                                                                Navigator.of(context).push(_createRouteAfterSignOut(context));
                                                                userDeleted = await deleteUser(deleteEmailController.text, deletePasswordController.text, context);
                                                              },
                                                              disabledColor:
                                                              Color.fromRGBO(149, 46, 0, 1.0),
                                                              color: Color.fromRGBO(149, 46, 0, 1.0),
                                                              borderRadius: BorderRadius.all(Radius.circular(13.0)),
                                                            )),
                                                        Container(
                                                            padding:
                                                            EdgeInsets.only(
                                                                top: 15.0,
                                                                left: 5.0,
                                                                right: 5.0),
                                                            width: 250,
                                                            height: 40,
                                                            child: CupertinoButton(
                                                              padding: EdgeInsets.all(0.0),
                                                              child: Text('Cancel', style: GoogleFonts.karla(fontSize: 18.0, fontWeight: FontWeight.w600,
                                                                  color: Color.fromRGBO(149, 46, 0, 1.0)),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.pop(context);
                                                              },
                                                              borderRadius: BorderRadius.all(Radius.circular(13.0)),
                                                            ))
                                                      ],
                                                    )),
                                              );
                                            });
                                        //Navigator.of(context).push(_createRouteAfterSignOut());
                                        //await deleteUser(email, password);
                                      },
                                      disabledColor:
                                      Color.fromRGBO(149, 46, 0, 1.0),
                                      color: Color.fromRGBO(149, 46, 0, 1.0),
                                      borderRadius: BorderRadius.all(Radius.circular(13.0)),
                                    )),
                                Container(
                                    padding:
                                    EdgeInsets.only(
                                        top: 15.0,
                                        left: 5.0,
                                        right: 5.0),
                                    width: 250,
                                    height: 40,
                                    child: CupertinoButton(
                                      padding: EdgeInsets.all(0.0),
                                      child: Text('Cancel', style: GoogleFonts.karla(fontSize: 18.0, fontWeight: FontWeight.w600,
                                          color: Color.fromRGBO(149, 46, 0, 1.0)),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      borderRadius: BorderRadius.all(Radius.circular(13.0)),
                                    ))
                              ],
                            )),
                      );
                    });
              },
              child: Text(
                "Delete Account",
                style: GoogleFonts.karla(
                    fontSize: 17.0, fontWeight: FontWeight.w600, color: Color.fromRGBO(149, 46, 0, 1.0),),
              ),
              padding: EdgeInsets.all(0.0),
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 15.0))
        ],
      )
    ],
  );
}

Widget showReminders(BuildContext context) {
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return Container(
        //height: 284,
        decoration: BoxDecoration(
          color: Theme.of(context).dialogBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(23)),
        ),
        padding: MediaQuery.of(context).viewInsets,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Row(
              children: <Widget>[
                Container(
                  width: 200,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Reminders",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.karla(
                        fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                ),
                Spacer(),
                Container(
                  width: 50,
                  padding: EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    icon: const Icon(CupertinoIcons.xmark, size: 23),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    disabledColor: Color.fromRGBO(255, 193, 25, 1.0),
                    color: Color.fromRGBO(255, 193, 25, 1.0),
                  ),
                )
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width-50,
              height: 50,
              alignment: Alignment.center,
              child: Text(
                "You can set notifications here if you want to be reminded to make a reservation at a certain hour on a certain day",
                style: GoogleFonts.karla(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(
                        161, 161, 161, 1.0)),
              ),
            ),
            PopupMenuButton(
                color: Color.fromRGBO(
                    220, 170, 57, 1.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(23.0))),
                child: Container(
                  padding: EdgeInsets.only(
                      right: 15.0, top: 3.0),
                  width: 143.0,
                  height: 37.0,
                  child: CupertinoButton(
                    padding: EdgeInsets.all(0.0),
                    child: Text(
                      formattedDate,
                      style: GoogleFonts.karla(
                          fontSize: 16.0,
                          fontWeight:
                          FontWeight.w600,
                          color: Color.fromRGBO(
                              220, 170, 57, 1.0)),
                    ),
                    onPressed: null,
                    disabledColor: Color.fromRGBO(
                        128, 128, 129, 0.3),
                    color: Color.fromRGBO(
                        128, 128, 129, 0.3),
                    borderRadius: BorderRadius.all(
                        Radius.circular(8.0)),
                  ),
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Container(
                        width: 300.0,
                        height: 120.0,
                        child: CupertinoTheme(
                            data: CupertinoThemeData(
                              textTheme: CupertinoTextThemeData(
                                dateTimePickerTextStyle: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            child:
                            CupertinoDatePicker(
                              minimumDate: DateTime.now().add(Duration(minutes: 15 - DateTime.now().minute % 15)),
                              minuteInterval: 15,
                              initialDateTime: DateTime.now().add(Duration(minutes: 15 - DateTime.now().minute % 15)),
                              onDateTimeChanged: (DateTime value) {
                              reminderDate = value;
                              formattedDate = DateFormat('MMM dd, hh:mm').format(reminderDate);
                              setState(() {});
                            },))),
                  ),
                ]),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
            ),
            Container(
                height: 50,
                padding: EdgeInsets.only(left: 24, right: 24, bottom: 10),
                child: TextFormField(
                  controller: notificationLabelController,
                  cursorColor: Color.fromRGBO(136, 126, 115, 1.0),
                  obscureText: false,
                  autocorrect: false,
                  keyboardAppearance: MediaQuery.of(context).platformBrightness,
                  decoration: InputDecoration(
                      labelText: 'Notification Label',
                      labelStyle: TextStyle(
                          color: Color.fromRGBO(136, 126, 115, 1.0),
                          fontWeight: FontWeight.w600),
                      filled: true,
                      fillColor: Color.fromRGBO(136, 126, 115, 0.44),
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
              width: MediaQuery.of(context).size.width - 58,
              height: 45,
              child: CupertinoButton(
                padding: EdgeInsets.all(0.0),
                child: Text(
                  "Set Reminder",
                  style: GoogleFonts.karla(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600,)
                ),
                onPressed: () => {
                  createReminderNotification(notificationLabelController.text, reminderDate),
                  Navigator.pop(context)
                },
                borderRadius: BorderRadius.all(Radius.circular(13.0)),
                disabledColor: Color.fromRGBO(255, 193, 25, 1.0),
                color: Color.fromRGBO(255, 193, 25, 1.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
            )
          ],
        ));
  });
}


_savePrefferedMapsApp(String app) async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'directions_app_pref';
  final value = app;
  prefs.setString(key, app);
  print('Saved $value');
}

_saveNeverLaunched() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'never_launched';
  prefs.setBool(key, false);
}


Route _createRouteAfterSignOut(BuildContext currentContext) {
  return PageRouteBuilder(
    pageBuilder: (currentContext, animation, secondaryAnimation) => WelcomeScreen(),
    transitionsBuilder: (currentContext, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}