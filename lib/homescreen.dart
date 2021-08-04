import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:geolocator/geolocator.dart';
import 'package:roadout/direction_utils.dart';
import 'package:roadout/search.dart';
import 'package:roadout/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';
import 'menus.dart';

enum Cards {
  searchBar,
  resultBar,
  spotCard,
  paySpotCard,
  unlockCard,
  unlockedCard,
  delayCard,
  payDelayCard
}

Cards currentCard = Cards.searchBar;
double progress = 0.0;

class MainScreen extends StatefulWidget {
  @override
  _MainScreen createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> with WidgetsBindingObserver {
  late Position currentPosition;
  late Position searchedPosition;
  var geolocator = Geolocator();
  LatLng latlngPos = LatLng(46.7712, 23.6236);

  void locatePosition(GoogleMapController controller) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    latlngPos = LatLng(position.latitude, position.longitude);
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latlngPos, zoom: 14)));
  }

  void _onMapCreated(GoogleMapController controller) {
    _readUserName();
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;
    if (darkModeOn)
      controller.setMapStyle(MapStyling.darkMapStyle);
    else
      controller.setMapStyle(MapStyling.lightMapStyle);
    locatePosition(controller);
  }

  late Future<String?> permissionStatusFuture;

  var nPermGranted = "granted";
  var nPermDenied = "denied";
  var nPermUnknown = "unknown";
  var nPermProvisional = "provisional";

  @override
  void initState() {
    super.initState();
    permissionStatusFuture = getCheckNotificationPermStatus();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        permissionStatusFuture = getCheckNotificationPermStatus();
      });
    }
  }

  /// Checks the notification permission status
  Future<String?> getCheckNotificationPermStatus() {
    return NotificationPermissions.getNotificationPermissionStatus()
        .then((status) {
      switch (status) {
        case PermissionStatus.denied:
          return nPermDenied;
        case PermissionStatus.granted:
          return nPermGranted;
        case PermissionStatus.unknown:
          return nPermUnknown;
        case PermissionStatus.provisional:
          return nPermProvisional;
        default:
          return null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition:
                  CameraPosition(target: latlngPos, zoom: 14),
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
            ),
            Column(
              children: <Widget>[
                Container(
                  child: Text(
                    'Roadout',
                    style: GoogleFonts.karla(
                        fontSize: 30.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                  padding: EdgeInsets.only(left: 25.0, top: 70.0),
                  width: MediaQuery.of(context).size.width,
                ),
                Spacer(),
                Container(
                  // height: 101,
                  child: FutureBuilder<Widget>(
                      future: null,
                      builder: (BuildContext context,
                          AsyncSnapshot<Widget> snapshot) {
                        if (currentCard == Cards.searchBar) {
                          return Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width - 22,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(26)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 5,
                                    blurRadius: 67,
                                    offset: Offset(
                                        0, 0), // changes position of shadow
                                  ),
                                ]),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 37.0,
                                  height: 45.0,
                                  child: Image.asset('assets/mapIcon.png'),
                                  padding: EdgeInsets.only(left: 15.0),
                                ),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width - 107,
                                    child: CupertinoButton(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Search for a place...',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.karla(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromRGBO(
                                                174, 174, 174, 1.0)),
                                      ),
                                      onPressed: () => {
                                        showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                              top: Radius.circular(23),
                                            )),
                                            // BorderRadius. vertical// RoundedRectangleBorder
                                            builder: (context) => showSearchBar(
                                                context, setState))
                                      },
                                    )),
                                Container(
                                  width: 48.0,
                                  height: 43.0,
                                  child: CupertinoButton(
                                      child: Image.asset('assets/Logo.png'),
                                      padding: EdgeInsets.all(0.0),
                                      onPressed: () => {
                                            showModalBottomSheet(
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
                                                        context, setState)),
                                            NotificationPermissions
                                                    .requestNotificationPermissions(
                                                        iosSettings:
                                                            const NotificationSettingsIos(
                                                                sound: true,
                                                                badge: true,
                                                                alert: true))
                                                .then((_) {
                                              setState(() {
                                                permissionStatusFuture =
                                                    getCheckNotificationPermStatus();
                                              });
                                            })
                                          }),
                                  padding: EdgeInsets.only(right: 15.0),
                                )
                              ],
                            ),
                          );
                        } else if (currentCard == Cards.resultBar) {
                          return Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width - 22,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(26)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 5,
                                    blurRadius: 67,
                                    offset: Offset(
                                        0, 0), // changes position of shadow
                                  ),
                                ]),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 45.0,
                                  height: 61.0,
                                  child: CupertinoButton(
                                    child: Icon(
                                      CupertinoIcons.chevron_back,
                                      color: Color.fromRGBO(255, 193, 25, 1.0),
                                    ),
                                    padding: EdgeInsets.all(0.0),
                                    onPressed: () {
                                      currentCard = Cards.searchBar;
                                      setState(() {});
                                    },
                                  ),
                                  padding: EdgeInsets.only(left: 5.0),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: 30,
                                      child: Text('5',
                                          style: GoogleFonts.karla(
                                              fontSize: 25.0,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromRGBO(
                                                  255, 193, 25, 1.0))),
                                      padding: EdgeInsets.only(top: 5.0),
                                    ),
                                    Container(
                                      height: 30,
                                      child: Text('Free Spots',
                                          style: GoogleFonts.karla(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromRGBO(
                                                  255, 193, 25, 1.0))),
                                      padding: EdgeInsets.only(top: 3.0),
                                    )
                                  ],
                                ),
                                Spacer(),
                                Container(
                                  width: 150,
                                  padding: EdgeInsets.only(right: 17.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        height: 30,
                                        child: Text('Location Name',
                                            style: GoogleFonts.karla(
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.w500,
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                        padding: EdgeInsets.only(top: 7.0),
                                      ),
                                      Container(
                                        height: 30,
                                        child: Text('10 km',
                                            style: GoogleFonts.karla(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w500,
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                        padding: EdgeInsets.only(top: 1.0),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        } else if (currentCard == Cards.spotCard) {
                          return Container(
                            height: 242,
                            width: MediaQuery.of(context).size.width - 22,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(26)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 5,
                                    blurRadius: 67,
                                    offset: Offset(
                                        0, 0), // changes position of shadow
                                  ),
                                ]),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: 200,
                                      height: 50,
                                      padding: EdgeInsets.only(
                                          left: 17.0, top: 20.0),
                                      child: Text(
                                        "Reserve Spot",
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.karla(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      height: 50,
                                      width: 50,
                                      padding: EdgeInsets.only(
                                          right: 8.0, top: 10.0),
                                      child: IconButton(
                                        icon: const Icon(CupertinoIcons.xmark,
                                            size: 23),
                                        onPressed: () {
                                          currentCard = Cards.resultBar;
                                          setState(() {});
                                        },
                                        disabledColor:
                                            Color.fromRGBO(220, 170, 57, 1.0),
                                        color:
                                            Color.fromRGBO(220, 170, 57, 1.0),
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                            padding:
                                                EdgeInsets.only(left: 20.0)),
                                        Text('Address: ',
                                            style: GoogleFonts.karla(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w500,
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                        Text('----------',
                                            style: GoogleFonts.karla(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromRGBO(
                                                    220, 170, 57, 1.0))),
                                        Spacer(),
                                        Container(
                                          padding: EdgeInsets.only(
                                              right: 15.0, top: 3.0),
                                          width: 102.0,
                                          height: 27.0,
                                          child: CupertinoButton(
                                            padding: EdgeInsets.all(0.0),
                                            child: Text(
                                              'Directions',
                                              style: GoogleFonts.karla(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color.fromRGBO(
                                                      227, 167, 27, 1.0)),
                                            ),
                                            onPressed: () async => {
                                              searchedPosition = await Geolocator
                                                  .getCurrentPosition(
                                                      desiredAccuracy:
                                                          LocationAccuracy
                                                              .bestForNavigation),
                                              if (selectedMapsApp ==
                                                  'Google Maps')
                                                {
                                                  MapUtils.openMapInGoogleMaps(
                                                      searchedPosition.latitude,
                                                      searchedPosition
                                                          .longitude)
                                                }
                                              else if (selectedMapsApp ==
                                                  'Waze')
                                                {
                                                  MapUtils.openMapInWaze(
                                                      searchedPosition.latitude,
                                                      searchedPosition
                                                          .longitude)
                                                }
                                              else
                                                {
                                                  MapUtils.openMapInAppleMaps(
                                                      searchedPosition.latitude,
                                                      searchedPosition
                                                          .longitude)
                                                }
                                            },
                                            disabledColor: Color.fromRGBO(
                                                220, 170, 57, 0.43),
                                            color: Color.fromRGBO(
                                                220, 170, 57, 0.43),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0)),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 20.0, top: 40.0)),
                                        Text('Price per reserved minute - ',
                                            style: GoogleFonts.karla(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w500,
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                        Text('0 RON',
                                            style: GoogleFonts.karla(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromRGBO(
                                                    220, 170, 57, 1.0))),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 20.0, top: 25.0)),
                                        Text('Reserve for',
                                            style: GoogleFonts.karla(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w500,
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                        Spacer(),
                                        PopupMenuButton(
                                            color: Color.fromRGBO(
                                                220, 170, 57, 1.0),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(23.0))),
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  right: 15.0, top: 3.0),
                                              width: 102.0,
                                              height: 27.0,
                                              child: CupertinoButton(
                                                padding: EdgeInsets.all(0.0),
                                                child: Text(
                                                  '0 min',
                                                  style: GoogleFonts.karla(
                                                      fontSize: 14.0,
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
                                                        width: 80.0,
                                                        height: 70.0,
                                                        child: CupertinoPicker(
                                                          onSelectedItemChanged:
                                                              (value) {
                                                            setState(() {
                                                              print(value);
                                                            });
                                                          },
                                                          itemExtent: 32.0,
                                                          children: const [
                                                            Text('1 min'),
                                                            Text('2 min'),
                                                            Text('3 min'),
                                                            Text('4 min'),
                                                            Text('5 min'),
                                                            Text('6 min'),
                                                            Text('7 min'),
                                                            Text('8 min'),
                                                            Text('9 min'),
                                                            Text('10 min')
                                                          ],
                                                        )),
                                                  ),
                                                ]),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 30.0),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          58,
                                      height: 45,
                                      child: CupertinoButton(
                                        padding: EdgeInsets.all(0.0),
                                        child: Text(
                                          'Pay Spot',
                                          style: GoogleFonts.karla(
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromRGBO(
                                                  227, 167, 27, 1.0)),
                                        ),
                                        onPressed: () => {
                                          currentCard = Cards.paySpotCard,
                                          setState(() {})
                                        },
                                        disabledColor:
                                            Color.fromRGBO(220, 170, 57, 0.43),
                                        color:
                                            Color.fromRGBO(220, 170, 57, 0.43),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(13.0)),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        } else if (currentCard == Cards.paySpotCard) {
                          return Container(
                            height: 300,
                            width: MediaQuery.of(context).size.width - 22,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(26)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 5,
                                    blurRadius: 67,
                                    offset: Offset(
                                        0, 0), // changes position of shadow
                                  ),
                                ]),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: 200,
                                      height: 50,
                                      padding: EdgeInsets.only(
                                          left: 17.0, top: 20.0),
                                      child: Text(
                                        "Pay Spot",
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.karla(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      height: 50,
                                      width: 50,
                                      padding: EdgeInsets.only(
                                          right: 8.0, top: 10.0),
                                      child: IconButton(
                                        icon: const Icon(CupertinoIcons.xmark,
                                            size: 23),
                                        onPressed: () {
                                          currentCard = Cards.spotCard;
                                          setState(() {});
                                        },
                                        disabledColor:
                                            Color.fromRGBO(214, 109, 0, 1.0),
                                        color: Color.fromRGBO(214, 109, 0, 1.0),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.only(left: 20.0)),
                                    Text('Address: ',
                                        style: GoogleFonts.karla(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context)
                                                .primaryColor)),
                                    Text('----------',
                                        style: GoogleFonts.karla(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromRGBO(
                                                214, 109, 0, 1.0))),
                                    Spacer(),
                                    Container(
                                      padding: EdgeInsets.only(
                                          right: 15.0, top: 3.0),
                                      width: 102.0,
                                      height: 27.0,
                                      child: CupertinoButton(
                                        padding: EdgeInsets.all(0.0),
                                        child: Text(
                                          'Directions',
                                          style: GoogleFonts.karla(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromRGBO(
                                                  214, 109, 0, 1.0)),
                                        ),
                                        onPressed: () async => {
                                          searchedPosition = await Geolocator
                                              .getCurrentPosition(
                                                  desiredAccuracy:
                                                      LocationAccuracy
                                                          .bestForNavigation),
                                          if (selectedMapsApp == 'Google Maps')
                                            {
                                              MapUtils.openMapInGoogleMaps(
                                                  searchedPosition.latitude,
                                                  searchedPosition.longitude)
                                            }
                                          else if (selectedMapsApp == 'Waze')
                                            {
                                              MapUtils.openMapInWaze(
                                                  searchedPosition.latitude,
                                                  searchedPosition.longitude)
                                            }
                                          else
                                            {
                                              MapUtils.openMapInAppleMaps(
                                                  searchedPosition.latitude,
                                                  searchedPosition.longitude)
                                            }
                                        },
                                        disabledColor:
                                            Color.fromRGBO(214, 109, 0, 0.43),
                                        color:
                                            Color.fromRGBO(214, 109, 0, 0.43),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 20.0, top: 40.0)),
                                    Text('Reserved for ',
                                        style: GoogleFonts.karla(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context)
                                                .primaryColor)),
                                    Text('10 min',
                                        style: GoogleFonts.karla(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromRGBO(
                                                214, 109, 0, 1.0))),
                                    Spacer(),
                                    Container(
                                      padding: EdgeInsets.only(
                                          right: 15.0, top: 3.0),
                                      width: 132.0,
                                      height: 27.0,
                                      alignment: Alignment.centerRight,
                                      child: Text('Price - 0 RON',
                                          style: GoogleFonts.karla(
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromRGBO(
                                                  214, 109, 0, 1.0))),
                                    )
                                  ],
                                ),
                                Spacer(),
                                /*Container(
                                  width: MediaQuery.of(context).size.width - 58,
                                  height: 45,
                                  child: CupertinoButton(
                                    padding: EdgeInsets.all(0.0),
                                    child: Text(
                                      'Pay 0 RON',
                                      style: GoogleFonts.karla(
                                          fontSize: 17.0, fontWeight: FontWeight.w600, color: Color.fromRGBO(227, 167, 27, 1.0)),
                                    ),
                                    onPressed: () => {
                                      currentCard = Cards.paySpotCard,
                                      setState(() {})
                                    },
                                    disabledColor: Color.fromRGBO(220, 170, 57, 0.43),
                                    color: Color.fromRGBO(220, 170, 57, 0.43),
                                    borderRadius: BorderRadius.all(Radius.circular(13.0)),
                                  ),
                                ), */ //APPLE PAY/GOOGLE PAY button
                                //Padding(padding: EdgeInsets.only(top: 8.0),),
                                Container(
                                  width: MediaQuery.of(context).size.width - 58,
                                  height: 45,
                                  child: CupertinoButton(
                                    padding: EdgeInsets.all(0.0),
                                    child: Text(
                                      'Pay with **** **** **** 9000',
                                      style: GoogleFonts.karla(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              Color.fromRGBO(214, 109, 0, 1.0)),
                                    ),
                                    onPressed: () => {
                                      //Paid
                                    },
                                    disabledColor:
                                        Color.fromRGBO(214, 109, 0, 0.43),
                                    color: Color.fromRGBO(214, 109, 0, 0.43),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(13.0)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width - 58,
                                  height: 45,
                                  child: CupertinoButton(
                                    padding: EdgeInsets.all(0.0),
                                    child: Text(
                                      'Different Payment Method',
                                      style: GoogleFonts.karla(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w600,
                                          color: Color.fromRGBO(
                                              255, 158, 25, 1.0)),
                                    ),
                                    onPressed: () => {
                                      showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                            top: Radius.circular(23),
                                          )), // BorderRadius. vertical// RoundedRectangleBorder
                                          builder: (context) =>
                                              showPayment(context))
                                    },
                                    disabledColor:
                                        Color.fromRGBO(255, 158, 25, 0.43),
                                    color: Color.fromRGBO(255, 158, 25, 0.43),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(13.0)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 15.0),
                                ),
                              ],
                            ),
                          );
                        } else if (currentCard == Cards.unlockCard) {
                          return Container(
                            height: 260,
                            width: MediaQuery.of(context).size.width - 22,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(26)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 5,
                                    blurRadius: 67,
                                    offset: Offset(
                                        0, 0), // changes position of shadow
                                  ),
                                ]),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: 200,
                                      height: 50,
                                      padding: EdgeInsets.only(
                                          left: 17.0, top: 20.0),
                                      child: Text(
                                        "Unlock Spot",
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.karla(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      height: 50,
                                      width: 50,
                                      padding: EdgeInsets.only(
                                          right: 8.0, top: 10.0),
                                      child: IconButton(
                                        icon: const Icon(CupertinoIcons.xmark,
                                            size: 23),
                                        onPressed: () {
                                          currentCard = Cards.searchBar;
                                          setState(() {});
                                        },
                                        disabledColor:
                                            Color.fromRGBO(149, 46, 0, 1.0),
                                        color: Color.fromRGBO(149, 46, 0, 1.0),
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  child: Text(
                                    'Your spot is locked now so it stays free for you, when you approach the spot unlock it from here, after the timer is over the spot will unlock by itself',
                                    style: GoogleFonts.karla(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).accentColor),
                                    textAlign: TextAlign.center,
                                  ),
                                  padding:
                                      EdgeInsets.only(left: 10.0, right: 10.0),
                                ),
                                Padding(padding: EdgeInsets.only(top: 20.0)),
                                Row(
                                children: <Widget>[
                                  Padding(padding: EdgeInsets.only(left: (MediaQuery.of(context).size.width-289)/2)),
                                  Container(
                                  width: 134,
                                  height: 84,
                                  child: CupertinoButton(
                                    padding: EdgeInsets.all(0.0),
                                    child: Icon(CupertinoIcons.lock, color: Color.fromRGBO(149, 46, 0, 1.0), size: 47,),
                                    onPressed: () => {
                                      currentCard = Cards.unlockedCard,
                                      setState(() {})
                                    },
                                    disabledColor:
                                    Color.fromRGBO(149, 46, 0, 0.44),
                                    color: Color.fromRGBO(149, 46, 0, 0.44),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(27.0)),
                                  ),
                                ),
                                  Padding(padding: EdgeInsets.only(right: 30.0)),
                                  Column(
                                  children: <Widget>[
                                    Text(
                                      'Time left',
                                      style: GoogleFonts.karla(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context)
                                              .primaryColor),
                                    ),
                                    Text(
                                      '6:23',
                                      style: GoogleFonts.karla(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w600,
                                          color: Color.fromRGBO(149, 46, 0, 1.0)),
                                    )
                                  ],
                                )
                              ],
                            ),
                                Padding(padding: EdgeInsets.only(top: 5.0)),
                                Container(
                                  child: CupertinoButton(
                                    child: Text(
                                      "Won't get there on time?",
                                      style: GoogleFonts.karla(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          color: Color.fromRGBO(149, 46, 0, 1.0)),
                                      textAlign: TextAlign.center,
                                    ),
                                    onPressed: () {
                                      currentCard = Cards.delayCard;
                                      setState(() {});
                                    },
                                  ),
                                )
                              ],
                            ),
                          );
                        } else if (currentCard == Cards.unlockedCard) {
                          return Container(
                            height: 220,
                            width: 365,
                            decoration: BoxDecoration(
                                color:
                                Theme.of(context).scaffoldBackgroundColor,
                                borderRadius:
                                BorderRadius.all(Radius.circular(26)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 5,
                                    blurRadius: 67,
                                    offset: Offset(
                                        0, 0), // changes position of shadow
                                  ),
                                ]),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: 130,
                                      height: 60,
                                      padding: EdgeInsets.only(left: 20.0, top: 20.0),
                                      child: Text(
                                        "Unlock Spot",
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.karla(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      height: 60,
                                      width: 50,
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: IconButton(
                                        icon: const Icon(CupertinoIcons.xmark, size: 23),
                                        onPressed: () {
                                              currentCard = Cards.searchBar;
                                              setState(() {});
                                        },
                                        disabledColor: Color.fromRGBO(143, 102, 13, 1.0),
                                        color: Color.fromRGBO(143, 102, 13, 1.0),
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                    padding: EdgeInsets.only(left: 52),
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      width: 327,
                                      height: 30,
                                      child: Text(
                                        "Your spot is unlocked now, after parking you can come back here to find your car",
                                        style: GoogleFonts.karla(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromRGBO(161, 161, 161, 1.0)),
                                      ),
                                    )),
                                Container(
                                    padding: EdgeInsets.only(top: 10),
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 330,
                                      height: 45,
                                      child: CupertinoButton(
                                        child: Text(
                                          'Unlocked',
                                          style: GoogleFonts.karla(
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromRGBO(143, 102, 13, 1.0)),
                                        ),
                                        onPressed: null,
                                        disabledColor: Color.fromRGBO(142, 102, 13, 0.44),
                                        color: Color.fromRGBO(143, 102, 13, 0.44),
                                        borderRadius: BorderRadius.all(Radius.circular(14.0)),
                                      ),
                                    )),
                                Spacer(),
                                Container(
                                    padding: EdgeInsets.only(bottom: 20),
                                    alignment: Alignment.center,
                                    child: CupertinoButton(
                                        onPressed: null,
                                        child: Text(
                                          "Get Directions to Spot",
                                          style: GoogleFonts.karla(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromRGBO(143, 102, 13, 1.0)),
                                        )))
                              ],
                            ),
                          );
                        } else if (currentCard == Cards.delayCard) {
                          return Container(
                              width: 365,
                              height: 275,
                              decoration: BoxDecoration(
                                  color:
                                  Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(26)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      spreadRadius: 5,
                                      blurRadius: 67,
                                      offset: Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ]),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        width: 130,
                                        height: 60,
                                        padding: EdgeInsets.only(left: 20.0, top: 20.0),
                                        child: Text(
                                          "Delay",
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.karla(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        height: 60,
                                        width: 50,
                                        padding: EdgeInsets.only(right: 8.0),
                                        child: IconButton(
                                          icon: const Icon(CupertinoIcons.xmark, size: 23),
                                          onPressed: () {
                                            currentCard = Cards.unlockCard;
                                            setState(() {});
                                          },
                                          disabledColor: Color.fromRGBO(143, 102, 13, 1.0),
                                          color: Color.fromRGBO(143, 102, 13, 1.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 327,
                                    height: 45,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "You can delay your reservation by up to 20 minutes if "
                                          "caught in traffic, first 5 minutes are free, then you are extra charged for every minute.",
                                      style: GoogleFonts.karla(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromRGBO(161, 161, 161, 1.0)),
                                    ),
                                  ),
                                  Container(
                                      padding: EdgeInsets.only( top: 10, left: 5),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            child: Column(
                                              children: <Widget>[
                                                Text("0",
                                                    style: GoogleFonts.karla(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                        color: Color.fromRGBO(143, 102, 13, 1.0))),
                                                Text("min",
                                                    style: GoogleFonts.karla(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                        color: Color.fromRGBO(143, 102, 13, 1.0))),
                                              ],
                                            ),
                                          ),
                                          Container(
                                              width: 295,
                                              child: CupertinoSlider(
                                                value: progress,
                                                min: 0.0,
                                                max: 20.0,
                                                activeColor: Color.fromRGBO(143, 102, 13, 1.0),
                                                divisions: 20,
                                                onChanged: (value) {
                                                  setState(() {
                                                    progress = value.roundToDouble();
                                                  });
                                                },
                                              )),
                                          Container(
                                            child: Column(
                                              children: <Widget>[
                                                Text("20",
                                                    style: GoogleFonts.karla(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                        color: Color.fromRGBO(143, 102, 13, 1.0))),
                                                Text("min",
                                                    style: GoogleFonts.karla(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                        color: Color.fromRGBO(143, 102, 13, 1.0))),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(top: 5, left: 125),
                                        child: Text("Charge",
                                            style: GoogleFonts.karla(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black)),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Text("-" + progress.toString() + " RON",
                                            style: GoogleFonts.karla(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromRGBO(143, 102, 13, 1.0))),
                                      )
                                    ],
                                  ),
                                  Container(
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: 330,
                                        height: 55,
                                        child: CupertinoButton(
                                          child: Text(
                                            "Delay for " + progress.toInt().toString() + " minutes",
                                            style: GoogleFonts.karla(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w600,
                                                color: Color.fromRGBO(143, 102, 13, 1.0)),
                                          ),
                                          onPressed:() => {
                                            currentCard = Cards.payDelayCard,
                                            setState(() {})
                                          },
                                          disabledColor: Color.fromRGBO(142, 102, 13, 0.44),
                                          color: Color.fromRGBO(142, 102, 13, 0.44),
                                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                        ),
                                        padding: EdgeInsets.only(top: 10),
                                      )),
                                ],
                              ));
                        }  else if (currentCard == Cards.payDelayCard) {
                          return Container(
                              width: 365,
                              height: 285,
                              decoration: BoxDecoration(
                                  color:
                                  Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(26)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      spreadRadius: 5,
                                      blurRadius: 67,
                                      offset: Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ]),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        width: 130,
                                        height: 60,
                                        padding: EdgeInsets.only(left: 20.0, top: 20.0),
                                        child: Text(
                                          "Pay Delay",
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.karla(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        height: 60,
                                        width: 50,
                                        padding: EdgeInsets.only(right: 8.0),
                                        child: IconButton(
                                          icon: const Icon(CupertinoIcons.xmark, size: 23),
                                          onPressed: () {
                                            currentCard = Cards.delayCard;
                                            setState(() {});
                                          },
                                          disabledColor: Color.fromRGBO(143, 102, 13, 1.0),
                                          color: Color.fromRGBO(143, 102, 13, 1.0),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(left: 110),
                                        child: Text("Charge",
                                            style: GoogleFonts.karla(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black)),
                                      ),
                                      Container(
                                        child: Text("  " + progress.toString() + " RON",
                                            style: GoogleFonts.karla(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromRGBO(143, 102, 13, 1.0))),
                                      )
                                    ],
                                  ),
                                  Container(
                                    width: 350,
                                    height: 57,
                                    padding: EdgeInsets.only(top: 10),
                                    child: CupertinoButton(
                                      onPressed: null,
                                      child: Text("Pay with Apple Pay",style: GoogleFonts.karla(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white)),
                                      disabledColor: Colors.black,
                                      color: Colors.black,
                                      borderRadius: BorderRadius.all(Radius.circular(13.0)),
                                    ),
                                  ),
                                  Container(
                                    width: 350,
                                    height: 57,
                                    padding: EdgeInsets.only(top: 10),
                                    child: CupertinoButton(
                                      onPressed: () {

                                      },
                                      child: Text("Pay with **** **** **** 9000",style: GoogleFonts.karla(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromRGBO(143, 102, 13, 1.0))),
                                      disabledColor: Color.fromRGBO(142, 102, 13, 0.44),
                                      color: Color.fromRGBO(142, 102, 13, 0.44),
                                      borderRadius: BorderRadius.all(Radius.circular(13.0)),
                                    ),
                                  ),
                                  Container(
                                    width: 350,
                                    height: 57,
                                    padding: EdgeInsets.only(top: 10),
                                    child: CupertinoButton(
                                      onPressed: null,
                                      child: Text("Add Payment Method",style: GoogleFonts.karla(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromRGBO(255, 158, 25, 1.0))),
                                      disabledColor: Color.fromRGBO(255, 158, 25, 0.43),
                                      color: Color.fromRGBO(255, 158, 25, 0.43),
                                      borderRadius: BorderRadius.all(Radius.circular(13.0)),
                                    ),
                                  ),
                                ],
                              ));
                        }
                        return Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width - 22,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(26)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: 5,
                                  blurRadius: 67,
                                  offset: Offset(
                                      0, 0), // changes position of shadow
                                ),
                              ]),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 37.0,
                                height: 45.0,
                                child: Image.asset('assets/mapIcon.png'),
                                padding: EdgeInsets.only(left: 15.0),
                              ),
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width - 107,
                                  child: CupertinoButton(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Search for a place...',
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.karla(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromRGBO(
                                              174, 174, 174, 1.0)),
                                    ),
                                    onPressed: () => {
                                      showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                            top: Radius.circular(23),
                                          )),
                                          // BorderRadius. vertical// RoundedRectangleBorder
                                          builder: (context) =>
                                              showSearchBar(context, setState))
                                    },
                                  )),
                              Container(
                                width: 48.0,
                                height: 43.0,
                                child: CupertinoButton(
                                    child: Image.asset('assets/Logo.png'),
                                    padding: EdgeInsets.all(0.0),
                                    onPressed: () => {
                                          showModalBottomSheet(
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
                                                      context, setState)),
                                          NotificationPermissions
                                                  .requestNotificationPermissions(
                                                      iosSettings:
                                                          const NotificationSettingsIos(
                                                              sound: true,
                                                              badge: true,
                                                              alert: true))
                                              .then((_) {
                                            setState(() {
                                              permissionStatusFuture =
                                                  getCheckNotificationPermStatus();
                                            });
                                          })
                                        }),
                                padding: EdgeInsets.only(right: 15.0),
                              )
                            ],
                          ),
                        );
                      }),
                  padding: EdgeInsets.only(bottom: 41.0),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  _readUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'user_name';
    final value = prefs.getString(key) ?? 'User Name';
    username = value;
    print('Read: $value');
  }
}

class MapStyling {
  static String lightMapStyle = '''
  [
    {
        "featureType": "administrative",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "color": "#444444"
            }
        ]
    },
    {
        "featureType": "landscape",
        "elementType": "all",
        "stylers": [
            {
                "color": "#f2f2f2"
            }
        ]
    },
    {
        "featureType": "landscape",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "visibility": "on"
            },
            {
                "hue": "#ff0000"
            }
        ]
    },
    {
        "featureType": "landscape.man_made",
        "elementType": "geometry",
        "stylers": [
            {
                "lightness": "100"
            }
        ]
    },
    {
        "featureType": "landscape.man_made",
        "elementType": "labels",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "landscape.natural",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "lightness": "100"
            }
        ]
    },
    {
        "featureType": "landscape.natural",
        "elementType": "labels",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "landscape.natural.landcover",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "visibility": "on"
            }
        ]
    },
    {
        "featureType": "landscape.natural.terrain",
        "elementType": "geometry",
        "stylers": [
            {
                "lightness": "100"
            }
        ]
    },
    {
        "featureType": "landscape.natural.terrain",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "visibility": "off"
            },
            {
                "lightness": "23"
            }
        ]
    },
    {
        "featureType": "poi",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "road",
        "elementType": "all",
        "stylers": [
            {
                "saturation": -100
            },
            {
                "lightness": 45
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "simplified"
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#ffd900"
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "labels.icon",
        "stylers": [
            {
                "visibility": "on"
            }
        ]
    },
    {
        "featureType": "transit",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "water",
        "elementType": "all",
        "stylers": [
            {
                "color": "#ffd900"
            },
            {
                "visibility": "on"
            }
        ]
    },
    {
        "featureType": "water",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "visibility": "on"
            },
            {
                "color": "#cccccc"
            }
        ]
    },
    {
        "featureType": "water",
        "elementType": "labels",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    }
]
  ''';

  static String darkMapStyle = ''' 
  [
    {
        "featureType": "all",
        "elementType": "labels",
        "stylers": [
            {
                "visibility": "on"
            }
        ]
    },
    {
        "featureType": "all",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "saturation": 36
            },
            {
                "color": "#000000"
            },
            {
                "lightness": 40
            }
        ]
    },
    {
        "featureType": "all",
        "elementType": "labels.text.stroke",
        "stylers": [
            {
                "visibility": "on"
            },
            {
                "color": "#000000"
            },
            {
                "lightness": 16
            }
        ]
    },
    {
        "featureType": "all",
        "elementType": "labels.icon",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "administrative",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 20
            }
        ]
    },
    {
        "featureType": "administrative",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 17
            },
            {
                "weight": 1.2
            }
        ]
    },
    {
        "featureType": "administrative.country",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "color": "#b5ac9a"
            }
        ]
    },
    {
        "featureType": "administrative.locality",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "color": "#c4c4c4"
            }
        ]
    },
    {
        "featureType": "administrative.neighborhood",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "color": "#ffcb05"
            }
        ]
    },
    {
        "featureType": "landscape",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 20
            }
        ]
    },
    {
        "featureType": "poi",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 21
            },
            {
                "visibility": "on"
            }
        ]
    },
    {
        "featureType": "poi.business",
        "elementType": "geometry",
        "stylers": [
            {
                "visibility": "on"
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#ffcb05"
            },
            {
                "lightness": "0"
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "color": "#000000"
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "labels.text.stroke",
        "stylers": [
            {
                "color": "#ed5929"
            },
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 18
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#ffcb05"
            },
            {
                "visibility":"off"
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "color": "#ffffff"
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "labels.text.stroke",
        "stylers": [
            {
                "color": "#ffffff"
            },
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "road.local",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 16
            }
        ]
    },
    {
        "featureType": "road.local",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#666666"
            }
        ]
    },
    {
        "featureType": "road.local",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "color": "#ffffff"
            }
        ]
    },
    {
        "featureType": "transit",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 19
            }
        ]
    },
    {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 17
            }
        ]
    }
]
  ''';
}
