import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roadout/spots_&_locations.dart';
import 'homescreen.dart';

bool isScrollable = false;

Widget SmartLayout(BuildContext context, StateSetter setState, ParkingSection currentSection) {
  return Container(
      alignment: Alignment.center,
      child: Row(
        children: <Widget> [
          MakePadding(currentSection.sectionRows, context),
          Column(
            children: MakeRows(currentSection.sectionRows, currentSection.sectionSpots, setState, context),
          )
        ]
      ));
}

InkWell _spotTile(ParkingSpot parkSpot, StateSetter setState, BuildContext context) {
  Color spotColor = Color.fromRGBO(255, 193, 25, 1.0);
  IconData icon = CupertinoIcons.checkmark;
  int state = parkSpot.spotState;
  if (state == 0) {
    spotColor = Color.fromRGBO(255, 193, 25, 1.0);
    icon = CupertinoIcons.checkmark;
  } else if (state == 1) {
    spotColor = Color.fromRGBO(149, 46, 0, 1.0);
    icon = CupertinoIcons.xmark;
  } else {
    spotColor = Color.fromRGBO(143, 102, 13, 1.0);
    icon = CupertinoIcons.hammer;
  }
  Color bgColor = Theme.of(context).scaffoldBackgroundColor;
  Color iconColor = spotColor;

  if (selectedNumber == parkSpot.spotNr) {
    iconColor = Theme.of(context).scaffoldBackgroundColor;
    bgColor = spotColor;
  }

  InkWell spot = InkWell(
    child: Container(
      height: 48,
      width: 34,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.all(Radius.circular(6)),
        border: Border.all(
          color: spotColor, //
          width: 2.0,
        ),
      ),
      child: Icon(
        icon,
        color: iconColor,
      ),
    ),
    onTap: () {
      if (state == 0) {
        infoText = " Selected spot is free, you can continue";
        infoIcon = CupertinoIcons.checkmark;
        infoColor = Color.fromRGBO(255, 193, 25, 1.0);
      } else if (state == 1) {
        infoText = " Selected spot is taken by a vehicle";
        infoIcon = CupertinoIcons.xmark;
        infoColor = Color.fromRGBO(149, 46, 0, 1.0);
      } else {
        infoText = " Selected spot is under maintenance";
        infoIcon = CupertinoIcons.hammer;
        infoColor = Color.fromRGBO(143, 102, 13, 1.0);
      }
      selectedNumber = parkSpot.spotNr;
      print(selectedNumber);
      setState(() {});
    },
  );

  return spot;
}

List<Widget> MakeRows(List<int> rowsCnt, List<ParkingSpot> sectionSpots, StateSetter setState, BuildContext context) {
  List<Widget> rows = [];
  List<ParkingSpot> dividingSpots = sectionSpots;
  int spotBookmark = 0;

  for (int row in rowsCnt) {
    List<ParkingSpot> rowSpots = [];
    for (var i = 1; i <= row; i += 1) {
      rowSpots.add(dividingSpots[spotBookmark]);
      spotBookmark += 1;
    }
    if (isScrollable == true) {
      rows.add(Container(
        width: MediaQuery.of(context).size.width-50,
        height: 48,
        child: ListView(
            scrollDirection: Axis.horizontal,
            children: MakeSpots(row, rowSpots, setState, context),
            shrinkWrap: true
        )
      ));
    } else {
      rows.add(Row(children: MakeSpots(row, rowSpots, setState, context)));
    }
    rows.add(Padding(padding: EdgeInsets.only(bottom: 10.0)));
  }


  return rows;
}

List<Widget> MakeSpots(int rowLength, List<ParkingSpot> rowSpots, StateSetter setState, BuildContext context) {
  List<Widget> children = [];
  for (var i = 0; i < rowLength; i += 1) {
    children.add(_spotTile(rowSpots[i], setState, context));
    children.add(Padding(padding: EdgeInsets.only(left: 2.0)));
  }
  return children;
}

Widget MakePadding(List<int> rowsCnt, BuildContext context) {
  int maxNr = rowsCnt.reduce(max);
  int maxWidth = maxNr*36 - 2;

  if ((MediaQuery.of(context).size.width-maxWidth-22)/2 < 11) {
    isScrollable = true;
    return Padding(padding: EdgeInsets.only(left: 15.0));
  } else {
    isScrollable = false;
  }

  return Padding(padding: EdgeInsets.only(left: (MediaQuery.of(context).size.width-maxWidth-22)/2));
}

double getHeightFromSection(ParkingSection sec) {
  double h = 175.0;
  h += sec.sectionRows.length*58;
  return h;
}