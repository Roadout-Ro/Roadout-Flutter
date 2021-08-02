import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roadout/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

var reservationStatusNot = true;
var promoUpdatesNote = true;

Widget showNotifications(BuildContext context, StateSetter setState) => Container(
    width: 390,
    height: 280,
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
                    fontSize: 21.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
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
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
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
                value: reservationStatusNot,
                onChanged: (bool value) {
                  setState(() {
                    reservationStatusNot = value;
                  });
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
              width: 250,
              height: 50,
              //padding: EdgeInsets.only(left: 10),
              child: Column(
                children: <Widget>[
                  Container(
                    //padding: EdgeInsets.only(left: 21),
                      padding: EdgeInsets.only(right: 104),
                      child: Text(
                        "Promo Updates",
                        style: GoogleFonts.karla(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      )),
                  Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        "Get notifications when free spots or discounts are available",
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
                value: promoUpdatesNote,
                onChanged: (bool value) {
                  setState(() {
                    promoUpdatesNote = value;
                  });
                },
                activeColor: Color.fromRGBO(255, 193, 25, 1.0),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 10, left: 80),
                alignment: Alignment.center,
                height: 30,
                child: Row(children: <Widget>[
                  Text(
                    "Notifications are enabled.",
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
        )
      ],
    ));

Widget showPayment(BuildContext context) => Container(
    height: 300,
    decoration: BoxDecoration(
      color: Theme.of(context).dialogBackgroundColor,
      borderRadius: BorderRadius.all(Radius.circular(23)),),
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
        ListView(
            primary: false,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              _cardTile(
                  '**** **** **** 9000',
                  LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(255, 193, 25, 1.0),
                        Color.fromRGBO(103, 72, 5, 1.0)
                      ]),
                  Color.fromRGBO(103, 72, 5, 1.0)),
              _cardTile(
                  '**** **** **** 9900',
                  LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Color.fromRGBO(255, 158, 25, 1.0),
                        Color.fromRGBO(143, 102, 13, 1.0)
                      ]),
                  Color.fromRGBO(165, 104, 21, 1.0))
            ]),
        Container(
          width: MediaQuery.of(context).size.width - 58,
          height: 45,
          child: CupertinoButton(
            padding: EdgeInsets.all(0.0),
            child: Text(
              'Add Card',
              style: GoogleFonts.karla(
                  fontSize: 17.0, fontWeight: FontWeight.w600, color: Color.fromRGBO(241, 179, 11, 1.0)),
            ),
            onPressed: () => {
              print("Nice")
            },
            disabledColor: Color.fromRGBO(255, 193, 25, 0.44),
            color: Color.fromRGBO(255, 193, 25, 0.44),
            borderRadius: BorderRadius.all(Radius.circular(13.0)),
          ),
        )
      ],
    ));

ListTile _cardTile(String number, Gradient gradient, Color numberColor) =>
    ListTile(
        title: Transform(
            transform: Matrix4.translationValues(-10, 0.0, 0.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 220,
                  child: Text(number,
                      style: GoogleFonts.karla(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: numberColor)),
                  padding: EdgeInsets.only(left: 8.0),
                ),
                Spacer(),
                Container(
                  width: 50,
                  child: CupertinoButton(
                      child: Icon(
                        CupertinoIcons.minus_circle,
                        color: Color.fromRGBO(126, 75, 25, 1.0),
                      ),
                      onPressed: null),
                  padding: EdgeInsets.only(right: 5.0, left: 20),
                )
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


Widget showDirectionsApp(BuildContext context) => Container(
    height: 300,
    decoration: BoxDecoration(
      color: Theme.of(context).dialogBackgroundColor,
      borderRadius: BorderRadius.all(Radius.circular(23)),),
    child: Column(
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
            children: [
              _appTile("Apple Maps", 'assets/apple-maps.png', 0.0, context),
              _appTile("Google Maps", 'assets/google-maps.png', 0.0, context),
              _appTile("Waze", 'assets/waze.png', 0.0, context)
            ])
      ],
    ));

ListTile _appTile(String name, String imageName, double opacity, BuildContext context) {
  if (selectedMapsApp == name)
      opacity = 0.3;
  return ListTile(
          title: Transform(
              transform: Matrix4.translationValues(-20, 0.0, 0.0),
              child: Stack(
                children: <Widget> [
                  Row(
                    children: <Widget> [
                      Container(width: 20,),
                          Container(
                            height: 48,
                            width: MediaQuery.of(context).size.width - 52,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(180, 180, 180, opacity),
                              borderRadius: BorderRadius.all(Radius.circular(16)),
                            )
                        ),
                    ],
                  ),
                  Column(
                    children: <Widget> [
                      Container(height: 3.5,),
                      Row(
                        children: <Widget>[
                          Container(
                              width: 77.0,
                              height: 40.0,
                              child: Image.asset(imageName),
                              padding: EdgeInsets.only(left: 25.0, right: 12.0)
                          ),
                          Text(name, textAlign: TextAlign.left,
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
          onTap: () => {
              selectedMapsApp = name,
              _savePrefferedMapsApp(name),
              Navigator.pop(context)
          },);
}

Widget showAbout(BuildContext context) => Container(
    width: 390,
    height: 250,
    child: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 200,
              height: 90,
              padding: EdgeInsets.only(left: 20.0, top: 30.0),
              child: Text(
                "About",
                textAlign: TextAlign.left,
                style: GoogleFonts.karla(
                    fontSize: 21.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ),
            Spacer(),
            Container(
              height: 90,
              width: 50,
              padding: EdgeInsets.only(right: 8.0),
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
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  Container(
                      padding: EdgeInsets.only(right: 42),
                      child: Text(
                        "v0.1",
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
        Spacer(),
        Container(
            padding: EdgeInsets.only(bottom: 30),
            alignment: Alignment.center,
            child: Text(
              "Copyright © 2021 Codebranch",
              style: GoogleFonts.karla(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ))
      ],
    ));

Widget showLegal(BuildContext context) => Container(
    width: 390,
    height: 536,
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
                    fontSize: 21.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ),
            Spacer(),
            Container(
              height: 90,
              width: 50,
              padding: EdgeInsets.only(right: 8.0),
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


_savePrefferedMapsApp(String app) async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'directions_app_pref';
  final value = app;
  prefs.setString(key, app);
  print('Saved $value');
}