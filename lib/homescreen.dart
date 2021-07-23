import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:roadout/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:roadout/database_service.dart';
import 'package:roadout/settings.dart';
import 'package:geolocator/geolocator.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreen createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> with WidgetsBindingObserver {

  late Position currentPosition;
  var geolocator = Geolocator();
  LatLng latlngPos = LatLng(46.7712, 23.6236);

  void locatePosition(GoogleMapController controller) async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    latlngPos = LatLng(position.latitude, position.longitude);
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: latlngPos, zoom: 14)));
  }


  void _onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(MapStyling.mapStyle);
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
  Future <String?> getCheckNotificationPermStatus() {
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
                  height: 101,
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width - 22,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(26)),
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
                          width: 37.0,
                          height: 45.0,
                          child: Image.asset('assets/mapIcon.png'),
                          padding: EdgeInsets.only(left: 15.0),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width - 107,
                            child: CupertinoButton(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Search for a place...',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.karla(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromRGBO(174, 174, 174, 1.0)),
                              ),
                              onPressed: () => {
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(23),
                                    )), // BorderRadius. vertical// RoundedRectangleBorder
                                    builder: (context) => showSearchBar())
                              },
                            )),
                        Container(
                          width: 48.0,
                          height: 43.0,
                          child: CupertinoButton(
                              child: Image.asset('assets/Logo.jpeg'),
                              padding: EdgeInsets.all(0.0),
                              onPressed: () => {
                                    showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(23),
                                        )), // BorderRadius. vertical// RoundedRectangleBorder
                                        builder: (context) => showSettings()),

                                NotificationPermissions.requestNotificationPermissions(iosSettings:
                                const NotificationSettingsIos(sound: true, badge: true, alert: true)).then((_) {
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
                  ),
                  padding: EdgeInsets.only(bottom: 41.0),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget showSettings() => Container(
      width: 390,
      height: 600,
      //padding: MediaQuery.of(context).viewInsets,
      padding: EdgeInsets.all(15.0),
      child: Column(
        //mainAxisSize: MainAxisSize.min,
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
                  onPressed: null,
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
                width: 114,
                height: 44,
                child: CupertinoButton(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                  child: Row(children: <Widget>[
                    Container(width: 3.0),
                    Icon(
                      CupertinoIcons.lightbulb,
                      color: Color.fromRGBO(229, 167, 0, 1.0),
                      size: 23,
                    ),
                    Text(' 1 Free Spot',
                        style: GoogleFonts.karla(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(229, 167, 0, 1.0))),
                  ]),
                  onPressed: null,
                  disabledColor: Color.fromRGBO(255, 193, 25, 0.4),
                  color: Color.fromRGBO(255, 193, 25, 0.4),
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
              ),
              Spacer(),
              Container(
                width: 37,
                height: 27,
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
              FutureBuilder(
                future: DatabaseService().getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                      padding: EdgeInsets.only(top: 10),
                      width: 54,
                      height: 64,
                      child: CupertinoButton(
                          padding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                          onPressed: null,
                          child: Text(username[0],
                              style: GoogleFonts.karla(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(229, 167, 0, 1.0))),
                          disabledColor: Color.fromRGBO(255, 193, 25, 0.4),
                          color: Color.fromRGBO(255, 193, 25, 0.4),
                          borderRadius:
                              BorderRadius.all(Radius.circular(19.0))),
                    );
                  } else {
                    return CupertinoActivityIndicator();
                  }
                },
              ),
              FutureBuilder(
                future: DatabaseService().getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                      height: 52,
                      padding: EdgeInsets.only(top: 10, left: 15.0),
                      child: Center(
                        child: Text(username,
                            style: GoogleFonts.karla(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.black)),
                      ),
                    );
                  } else {
                    return Spacer();
                  }
                },
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
                    onPressed: null,
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
                      color: Colors.black)),
            )
          ]),
          ListView(
              primary: false,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                _tile("Notifications", CupertinoIcons.bell),
                _tile("Payment Methods", CupertinoIcons.creditcard),
                _tile("Default Directions App", CupertinoIcons.arrow_branch),
                _tile("Invite Friends", CupertinoIcons.envelope_open),
                _tile("About Roadout", CupertinoIcons.app),
                _tile("Privacy Policy & Terms of Use",
                    CupertinoIcons.doc_plaintext),
                _tile("Sign Out", CupertinoIcons.lock_open)
              ])
        ],
      ));

  ListTile _tile(String title, IconData icon) => ListTile(
        title: Transform(
            transform: Matrix4.translationValues(-15, 0.0, 0.0),
            child: Text(title,
            style:
                GoogleFonts.karla(fontSize: 17.0, fontWeight: FontWeight.bold))),
        leading: Icon(
          icon,
          color: Color.fromRGBO(229, 167, 0, 1.0),
          size: 25,
        ),
        onTap: () {
          if (title == "Sign Out") {
            showDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                    title: Text("Sign Out"),
                    content: Text("Do you really want to sign out?"),
                    actions: <Widget>[
                      CupertinoDialogAction(
                          textStyle: TextStyle(
                              color: Color.fromRGBO(255, 158, 25, 1.0)),
                          isDefaultAction: true,
                          onPressed: () async {
                            await AuthenticationService(FirebaseAuth.instance)
                                .signOut(context: context);
                          },
                          child: Text("Sign Out")),
                      CupertinoDialogAction(
                          textStyle: TextStyle(
                              color: Color.fromRGBO(146, 82, 24, 1.0)),
                          isDefaultAction: true,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancel")),
                    ]);
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
                builder: (context) => showNotifications(context));
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
                    )), // BorderRadius. vertical// RoundedRectangleBorder
                builder: (context) => showDirectionsApp(context));
          } else
            print(FirebaseAuth.instance.currentUser?.uid);
        },
      );

  Widget showSearchBar() => Container(
      width: 390,
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
                color: Colors.white,
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
                    width: 300,
                    child: TextField(
                      autofocus: true,
                      cursorColor: Color.fromRGBO(255, 193, 25, 1.0),
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'Search for a place...'),
                    )),
                Spacer(),
                IconButton(
                  icon: const Icon(CupertinoIcons.xmark, size: 27),
                  onPressed: () {
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
        ListView(
          primary: false,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            _tile2(5, "Location Name 1", "10 km", 255, 193, 25, context),
            _tile2(3, "Location Name 2", "11 km", 255, 158, 25, context),
            _tile2(11, "Location Name 3", " 14 km", 143, 102, 13, context),
            _tile2(7, "Location Name 4", "18 km", 103, 72, 5, context)
          ],
        )
      ]));

  ListTile _tile2(int spots, String location, String km, int colorR, int colorG,
          int colorB, BuildContext context) =>
      ListTile(
          title: Text(location,
              style: GoogleFonts.karla(
                  fontSize: 17.0, fontWeight: FontWeight.bold)),
          subtitle: Text(km,
              style: GoogleFonts.karla(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black)),
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
              )));
}

class MapStyling {
  static String mapStyle = '''
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
                "visibility": "off"
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
}
