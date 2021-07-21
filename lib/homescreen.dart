import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roadout/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreen createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  void _onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(MapStyling.mapStyle);
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
                  CameraPosition(target: LatLng(46.7712, 23.6236), zoom: 11.5),
              myLocationButtonEnabled: false,
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
                              onPressed: null,
                            )),
                        Container(
                          width: 48.0,
                          height: 43.0,
                          child: CupertinoButton(child: Image.asset('assets/Logo.jpeg'), padding: EdgeInsets.all(0.0), onPressed: () => {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(23),
                                    )), // BorderRadius. vertical// RoundedRectangleBorder
                                builder: (context) => showSettings())
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
                      Icon(CupertinoIcons.hourglass,color:Color.fromRGBO(229, 167, 0, 1.0),size: 23,),
                      Text(' Active Reservation', style:GoogleFonts.karla(
                          fontSize:14.0 ,fontWeight : FontWeight.w600,color:Color.fromRGBO(229, 167, 0, 1.0)
                      )),
                    ],),
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
                  child: Row(
                      children: <Widget>[
                        Container(width: 3.0),
                        Icon(CupertinoIcons.lightbulb,color:Color.fromRGBO(229, 167, 0, 1.0),size: 23,),
                        Text(' 1 Free Spot', style:GoogleFonts.karla(
                            fontSize:14.0 ,fontWeight : FontWeight.w600,color:Color.fromRGBO(229, 167, 0, 1.0)
                        )),
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
                child: IconButton(icon: const Icon(CupertinoIcons.xmark,size: 27),
                  onPressed:(){
                    Navigator.pop(context);
                  },
                  disabledColor: Color.fromRGBO(229, 167, 0, 1.0) ,
                  color:Color.fromRGBO(229, 167, 0, 1.0) ,
                ),
                padding: EdgeInsets.only(right: 5.0),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 10),
                width: 54,
                height: 64,
                child: CupertinoButton(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                    onPressed: null,
                    child: Text("V",style:GoogleFonts.karla(
                        fontSize:18.0 ,fontWeight : FontWeight.w600,color:Color.fromRGBO(229, 167, 0, 1.0)
                    )),
                    disabledColor: Color.fromRGBO(255, 193, 25, 0.4),
                    color: Color.fromRGBO(255, 193, 25, 0.4),
                    borderRadius: BorderRadius.all(Radius.circular(19.0))
                ),
              ),

              Container(
                height: 52,
                padding: EdgeInsets.only(top: 10, left: 15.0),
                child: Center(
                  child: Text("Veronica Vacaras",style:GoogleFonts.karla(
                      fontSize: 20.0 ,fontWeight : FontWeight.w600,color:Colors.black
                  )),
                ),
              ),
              Spacer(),
              Container(
                  width: 40,
                  padding: EdgeInsets.only(top: 10.0, right: 7.0),
                  child: IconButton(icon: const Icon(CupertinoIcons.hammer,size: 27,),
                    onPressed: null,
                    disabledColor: Color.fromRGBO(229, 167, 0, 1.0) ,
                    color: Color.fromRGBO(229, 167, 0, 1.0) ,)
              )
            ],
          ),
          Row(
              children:<Widget>[
                Container(
                  width: 70,
                  height: 30,
                  padding: EdgeInsets.only(top: 10),
                  child: Text("Settings",style:GoogleFonts.karla(
                      fontSize:16.0 ,fontWeight : FontWeight.w600,color:Colors.black
                  )),
                )]),
          ListView(
              primary: false,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                _tile("Notifications", CupertinoIcons.bell),
                _tile("Payment Methods", CupertinoIcons.creditcard),
                _tile("Default Directions App",CupertinoIcons.arrow_branch),
                _tile("Invite Friends", CupertinoIcons.envelope_open),
                _tile("About Roadout", CupertinoIcons.app),
                _tile("Privacy Policy & Terms of Use", CupertinoIcons.doc_plaintext),
                _tile("Sign Out", CupertinoIcons.lock_open)
              ]
          )
        ],
      ));

  ListTile _tile (String title, IconData icon) =>
      ListTile(
        title: Text(title,
            style: GoogleFonts.karla(fontSize: 17.0, fontWeight: FontWeight.bold)),
        leading: Icon(
          icon,
          color: Color.fromRGBO(229, 167, 0, 1.0),
          size: 25,
        ),
        onTap: (){
          if(title == "Sign Out"){

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
                          onPressed: () async{
                            await AuthenticationService(FirebaseAuth.instance).signOut(context: context);
                          },
                          child: Text("Sign Out")
                      ),
                      CupertinoDialogAction(
                          textStyle: TextStyle(
                              color: Color.fromRGBO(146, 82, 24, 1.0)),
                          isDefaultAction: true,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancel")
                      ),
                    ]
                );
              },
            );
          }else print(FirebaseAuth.instance.currentUser?.uid);
        },
      );
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

