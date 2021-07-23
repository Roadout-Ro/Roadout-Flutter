import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:geolocator/geolocator.dart';
import 'package:roadout/search.dart';
import 'package:roadout/settings.dart';

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
                                    builder: (context) => showSearchBar(context))
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
                                        builder: (context) => showSettings(context)),

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
