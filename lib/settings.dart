import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

String selectedMapsApp = 'Apple Maps';

Widget showNotifications(BuildContext context) => Container(
    height: 253,
    child: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 200,
              height: 90,
              padding: EdgeInsets.only(left: 20.0, top: 30.0),
              child: Text(
                "Notifications",
                textAlign: TextAlign.left,
                style: GoogleFonts.karla(
                    fontSize: 21.5,
                    fontWeight: FontWeight.w600,
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
        Row()
      ],
    ));

Widget showPayment(BuildContext context) => Container(
    height: 300,
    child: Column(
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
                    fontSize: 21.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
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
            child: Text(
              'Add Card',
              style: GoogleFonts.karla(
                  fontSize: 17.0, fontWeight: FontWeight.w600, color: Color.fromRGBO(103, 72, 5, 1.0)),
            ),
            onPressed: () => {
              print("Nice")
            },
            disabledColor: Color.fromRGBO(103, 72, 5, 0.43),
            color: Color.fromRGBO(103, 72, 5, 0.43),
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
                    fontSize: 21.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
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
      opacity = 1.0;
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
                              color: Color.fromRGBO(233, 233, 233, opacity),
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
                                color: Colors.black),
                          )
                        ],
                      )
                    ],
                  )
                ],
              )),
          leading: null);
}