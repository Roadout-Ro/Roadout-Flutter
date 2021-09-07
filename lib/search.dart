import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roadout/homescreen.dart';
import 'package:roadout/spots_&_locations.dart';

List<Widget> tiles = [];
List<ParkingLocation> results = [];

List<Color> searchColors = [Color.fromRGBO(255, 193, 25, 1.0),
                            Color.fromRGBO(143, 102, 13, 1.0),
                            Color.fromRGBO(103, 72, 5, 1.0),
                            Color.fromRGBO(255, 158, 25, 1.0),
                            Color.fromRGBO(214, 109, 0, 1.0),
                            Color.fromRGBO(220, 170, 57, 1.0),
                            Color.fromRGBO(149, 46, 0, 1.0)];

Widget showSearchBar(BuildContext context, StateSetter setHomeState) {
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return Container(
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
                            onChanged: (value) => _runFilter(value, context, setState),
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
                          setHomeState(() {});
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
              Padding(
                  padding: EdgeInsets.only(top: 20)
              ),
              ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height/2-80,
                  ),
                  child: ListView(
                    primary: false,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: tiles,
                  )
              )
            ]));
  });
}

ListTile _tile(int spots, String location, String km, BuildContext context, StateSetter setState, Color color, int index) =>
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
                            color: color,
                      )),
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
                          color: color),
                    ),
                    Spacer()
                  ],
                )
              ],
            )),
        onTap: () {
          currentParkLocation = parkingLocations[index];
          if (currentParkLocation.name == 'Marasti') {
            sectionAsset = 'assets/SectionMap1.png';
          } else if (currentParkLocation.name == 'Mihai Viteazu') {
            sectionAsset = 'assets/SectionMap2.png';
          } else {
            sectionAsset = 'assets/SectionMap3.png';
          }
          sectionLetters = [];
          for (ParkingSection sec in currentParkLocation.sections) {
            sectionLetters.add(sec.sectionLetter);
          }
          currentLocationName = parkingLocations[index].name;
          currentLocationColor = color;
          currentCard = Cards.resultBar;
          setState(() {});
          Navigator.pop(context);
        },
    );

void _runFilter(String enteredKeyword, BuildContext context, StateSetter setState) {
  String disKm = '0';
  if (enteredKeyword.isEmpty) {
    results = parkingLocations;
  } else {
    results = parkingLocations.where((parkLocation) => parkLocation.name.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
  }
  print('REZ');
  tiles = [];
  for (ParkingLocation res in results) {
    print(res.name);
    disKm = calculateDistance(res.coords.latitude, res.coords.longitude, latlngPos.latitude, latlngPos.longitude).toStringAsFixed(1);
    if (res.name == 'Marasti') {
      tiles.add(_tile(res.nrFreeSpots, res.name, "$disKm km", context, setState, (searchColors..shuffle()).first, 0));
    } else if (res.name == 'Mihai Viteazu') {
      tiles.add(_tile(res.nrFreeSpots, res.name, "$disKm km", context, setState, (searchColors..shuffle()).first, 1));
    } else {
      tiles.add(_tile(res.nrFreeSpots, res.name, "$disKm km", context, setState, (searchColors..shuffle()).first, 2));
    }
  }
  print(' ');
  setState(() {});
}

double calculateDistance(lat1, lon1, lat2, lon2){
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 - c((lat2 - lat1) * p)/2 +
      c(lat1 * p) * c(lat2 * p) *
          (1 - c((lon2 - lon1) * p))/2;
  return 12742 * asin(sqrt(a));
}