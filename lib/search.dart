import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roadout/homescreen.dart';
import 'package:roadout/spots_&_locations.dart';

Widget showSearchBar(BuildContext context, StateSetter setState) => Container(
    width: 390,
    decoration: BoxDecoration(
      color: Theme.of(context).dialogBackgroundColor,
      borderRadius: BorderRadius.all(Radius.circular(23)),),
    padding: MediaQuery.of(context).viewInsets,
    child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width - 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(23)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 67,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ]),
              child: Row(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(left: 15),
                      width: 295,
                      child: TextField(
                        autofocus: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardAppearance: MediaQuery.of(context).platformBrightness,
                        cursorColor: Color.fromRGBO(255, 193, 25, 1.0),
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: 'Search for a place...'),
                      )),
                  Spacer(),
                  IconButton(
                    icon: const Icon(CupertinoIcons.xmark, size: 27),
                    onPressed: () {
                      currentCard = Cards.searchBar;
                      setState(() {});
                      Navigator.pop(context);
                    },
                    disabledColor: Color.fromRGBO(255, 193, 25, 1.0),
                    color: Color.fromRGBO(255, 193, 25, 1.0),
                  ),
                ],
              ),
            ),
            padding: EdgeInsets.only(top: 17),
          ),
          ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height/2-80,
              ),
              child: ListView(
                primary: false,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  _tile2(5, "Location Name 1", "10 km", 255, 193, 25, context, setState),
                  _tile2(3, "Location Name 2", "11 km", 255, 158, 25, context, setState),
                  _tile2(5, "Location Name 1", "10 km", 255, 193, 25, context, setState),
                  _tile2(3, "Location Name 2", "11 km", 255, 158, 25, context, setState),
                  _tile2(5, "Location Name 1", "10 km", 255, 193, 25, context, setState),
                  _tile2(3, "Location Name 2", "11 km", 255, 158, 25, context, setState),
                  _tile2(5, "Location Name 1", "10 km", 255, 193, 25, context, setState),
                  _tile2(3, "Location Name 2", "11 km", 255, 158, 25, context, setState),
                  _tile2(5, "Location Name 1", "10 km", 255, 193, 25, context, setState),
                  _tile2(3, "Location Name 2", "11 km", 255, 158, 25, context, setState),
                  _tile2(5, "Location Name 1", "10 km", 255, 193, 25, context, setState),
                  _tile2(3, "Location Name 2", "11 km", 255, 158, 25, context, setState),
                ],
              )
          )
        ]));

ListTile _tile2(int spots, String location, String km, int colorR, int colorG,
    int colorB, BuildContext context, StateSetter setState) =>
    ListTile(
        title: Text(location,
            style: GoogleFonts.karla(
                fontSize: 17.0, fontWeight: FontWeight.bold)),
        subtitle: Text(km,
            style: GoogleFonts.karla(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor)),
        leading: Container(
            padding: EdgeInsets.only(left: 15),
            alignment: Alignment.topLeft,
            width: MediaQuery.of(context).size.width - 200,
            child: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                        spots.toString(),
                        textAlign: TextAlign.left,
                        style: GoogleFonts.karla(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color:
                            Color.fromRGBO(colorR, colorG, colorB, 1.0)),
                      ),
                      Spacer()
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "Free Spots",
                      style: GoogleFonts.karla(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(colorR, colorG, colorB, 1.0)),
                    ),
                    Spacer()
                  ],
                )
              ],
            )),
        onTap: () {
          if (spots == 5) {
            currentLocationName = parkingLocations[0].name;
          } else if (spots == 3) {
            currentLocationName = parkingLocations[1].name;
          } else if (spots == 11) {
            currentLocationName = parkingLocations[2].name;
          } else {
            currentLocationName = parkingLocations[3].name;
          }
          currentCard = Cards.resultBar;
          setState(() {});
          Navigator.pop(context);
        },
    );

