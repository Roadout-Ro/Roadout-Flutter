import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'homescreen.dart';


Widget SmartLayout(BuildContext context, StateSetter setState, String parkName) {

  if (parkName == 'Old Town') {
    return Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Padding(
                    padding: EdgeInsets.only(
                        left: (MediaQuery.of(
                            context)
                            .size
                            .width -
                            308) /
                            2)),
                _spotTile(1, setState, context),
                Padding(
                    padding: EdgeInsets.only(
                        left: 2.0)),
                _spotTile(2, setState, context),
                Padding(
                    padding: EdgeInsets.only(
                        left: 2.0)),
                _spotTile(3, setState, context),
                Padding(
                    padding: EdgeInsets.only(
                        left: 2.0)),
                _spotTile(4, setState, context),
                Padding(
                    padding: EdgeInsets.only(
                        left: 2.0)),
                _spotTile(5, setState, context),
                Padding(
                    padding: EdgeInsets.only(
                        left: 2.0)),
                _spotTile(6, setState, context),
                Padding(
                    padding: EdgeInsets.only(
                        left: 2.0)),
                _spotTile(7, setState, context),
                Padding(
                    padding: EdgeInsets.only(
                        left: 2.0)),
                _spotTile(8, setState, context),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 41),
            ),
            Row(
              children: [
                Padding(
                    padding: EdgeInsets.only(
                        left: (MediaQuery.of(
                            context)
                            .size
                            .width -
                            308) /
                            2)),
                _spotTile(9, setState, context),
                Padding(
                    padding: EdgeInsets.only(
                        left: 2.0)),
                _spotTile(10, setState, context),
                Padding(
                    padding: EdgeInsets.only(
                        left: 2.0)),
                _spotTile(11, setState, context),
                Padding(
                    padding: EdgeInsets.only(
                        left: 2.0)),
                _spotTile(12, setState, context),
                Padding(
                    padding: EdgeInsets.only(
                        left: 2.0)),
                _spotTile(13, setState, context),
                Padding(
                    padding: EdgeInsets.only(
                        left: 2.0)),
                _spotTile(14, setState, context),
                Padding(
                    padding: EdgeInsets.only(
                        left: 2.0)),
                _spotTile(15, setState, context),
                Padding(
                    padding: EdgeInsets.only(
                        left: 2.0)),
                _spotTile(16, setState, context),
              ],
            ),
          ],
        ));
  }

  return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Padding(
                  padding: EdgeInsets.only(
                      left: (MediaQuery.of(
                          context)
                          .size
                          .width -
                          308) /
                          2)),
              _spotTile(1, setState, context),
              Padding(
                  padding: EdgeInsets.only(
                      left: 2.0)),
              _spotTile(2, setState, context),
              Padding(
                  padding: EdgeInsets.only(
                      left: 2.0)),
              _spotTile(3, setState, context),
              Padding(
                  padding: EdgeInsets.only(
                      left: 2.0)),
              _spotTile(4, setState, context),
              Padding(
                  padding: EdgeInsets.only(
                      left: 2.0)),
              _spotTile(5, setState, context),
              Padding(
                  padding: EdgeInsets.only(
                      left: 2.0)),
              _spotTile(6, setState, context),
              Padding(
                  padding: EdgeInsets.only(
                      left: 2.0)),
              _spotTile(7, setState, context),
              Padding(
                  padding: EdgeInsets.only(
                      left: 2.0)),
              _spotTile(8, setState, context),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 41),
          ),
          Row(
            children: [
              Padding(
                  padding: EdgeInsets.only(
                      left: (MediaQuery.of(
                          context)
                          .size
                          .width -
                          308) /
                          2)),
              _spotTile(9, setState, context),
              Padding(
                  padding: EdgeInsets.only(
                      left: 2.0)),
              _spotTile(10, setState, context),
              Padding(
                  padding: EdgeInsets.only(
                      left: 2.0)),
              _spotTile(11, setState, context),
              Padding(
                  padding: EdgeInsets.only(
                      left: 2.0)),
              _spotTile(12, setState, context),
              Padding(
                  padding: EdgeInsets.only(
                      left: 2.0)),
              _spotTile(13, setState, context),
              Padding(
                  padding: EdgeInsets.only(
                      left: 2.0)),
              _spotTile(14, setState, context),
              Padding(
                  padding: EdgeInsets.only(
                      left: 2.0)),
              _spotTile(15, setState, context),
              Padding(
                  padding: EdgeInsets.only(
                      left: 2.0)),
              _spotTile(16, setState, context),
            ],
          ),
        ],
      ));
}

InkWell _spotTile(int nr, StateSetter setState, BuildContext context) {
  Color spotColor = Color.fromRGBO(255, 193, 25, 1.0);
  IconData icon = CupertinoIcons.checkmark;
  int state = spotStates[nr-1];
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

  if (selectedNumber == nr) {
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
      selectedNumber = nr;
      setState(() {});
    },
  );

  return spot;
}