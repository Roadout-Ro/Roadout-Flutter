import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:app_settings/app_settings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:roadout/direction_utils.dart';
import 'package:roadout/notification_service.dart';
import 'package:roadout/search.dart';
import 'package:roadout/settings.dart';
import 'package:roadout/spots_&_locations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';
import 'connectivity_helper.dart';
import 'database_service.dart';
import 'layouts.dart';
import 'menus.dart';

enum Cards {
  searchBar,
  resultBar,
  spotCard,
  paySpotCard,
  unlockCard,
  unlockedCard,
  delayCard,
  payDelayCard,
  sectionCard,
  pickCard,
  paidCard
}

Cards currentCard = Cards.searchBar;
double progress = 0.0;
int selectedMinutes = 0;
bool delayActive = false;
IconData infoIcon = CupertinoIcons.info_circle;
Color infoColor = Color.fromRGBO(255, 193, 25, 1.0);
String infoText = "Select a spot to get info about it.";
late ParkingLocation currentParkLocation;
String currentLocationName = '---';
String currentLocationLayout = '''''';
Color currentLocationColor = Color.fromRGBO(0, 0, 0, 1.0);

String selectedSection = 'A';
int selectedSectionNr = 0;
int selectedNumber = -1;

List<String> sectionLetters = [];

Duration duration = Duration();
Timer? timer;

DateTime activeReservationExpiry = DateTime.now();

String sectionAsset = 'assets/SectionMap1.png';

LatLng latlngPos = LatLng(46.774547, 23.603745);


class MainScreen extends StatefulWidget {
  @override
  _MainScreen createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> with WidgetsBindingObserver {
  late Position currentPosition;
  late LatLng searchedPosition;
  var geolocator = Geolocator();
  
  Color payBtnColor = Colors.orange;
  String payAsset = '';
  Color payBorderColor = Colors.orange;
  Color payTextColor = Colors.orange;

  bool showedDelayAlert = false;

  Set<Marker> _markers = {};
  late BitmapDescriptor mapMarker;

  iconFile() {
    if (Platform.isAndroid) {
      return 'assets/Marker@2x.png';
    }
    return 'assets/Marker.png';
  }

  Map _source = {ConnectivityResult.none: false};
  final ConnectivityHelper _connectivity = ConnectivityHelper.instance;

  @override
  void initState() {
    super.initState();
    setCustomMarker();
    _decidePaymentPlatform();
    currentParkLocation = parkingLocations[0];
    sectionLetters = [];
    for (ParkingSection sec in currentParkLocation.sections) {
      sectionLetters.add(sec.sectionLetter);
    }
    WidgetsBinding.instance!.addObserver(this);
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });
  }

  void reset() {
    setState(() {
      duration = Duration(minutes: selectedMinutes);
    });
  }

  void resetDelay(int minutes) {
    setState(() {
      duration = duration + Duration(minutes: minutes);
    });
  }

  void changeTime() {
    final getSeconds = 1;
    setState(() {
      final seconds = duration.inSeconds - getSeconds;
      if (seconds < 0) {
        timer?.cancel();
        currentCard = Cards.unlockedCard;
        print('finish');
        setState(() {
          delayActive =false;
        });
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => changeTime());
  }

  void setCustomMarker() async {
   mapMarker = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), iconFile());
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _readUserName();
    _readPrefferedDirectionsApp();
    showedDelayAlert = await _showedDelayAlert();

    setState(() {
      for (ParkingLocation parkLocation in parkingLocations) {
        _markers.add(Marker(
            markerId: MarkerId(parkLocation.name),
            icon: mapMarker,
            onTap: () {
              if (_source.keys.toList()[0] == ConnectivityResult.none) {
                print('no internet');
              } else {
                print(' internet');
                currentParkLocation = parkLocation;
                if (currentParkLocation.name == 'Marasti') {
                  sectionAsset = 'assets/SectionMap1.png';
                } else if (currentParkLocation.name == '21 Decembrie') {
                  sectionAsset = 'assets/SectionMap2.png';
                } else {
                  sectionAsset = 'assets/SectionMap3.png';
                }
                sectionLetters = [];
                for (ParkingSection sec in currentParkLocation.sections) {
                  sectionLetters.add(sec.sectionLetter);
                }
                currentLocationName = parkLocation.name;
                currentLocationColor = (searchColors..shuffle()).first;
                currentCard = Cards.resultBar;
                setState(() {});
              }
            },
            position: parkLocation.coords));
      }
    });
    username = await DatabaseService().getUserData();

    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;

    var themeName = 'Light';
    if (darkModeOn) themeName = 'Dark';
    bool neverLaunched = await _readNeverLaunched();
    if (neverLaunched == true) {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
            top: Radius.circular(23),
          )),
          // BorderRadius. vertical// RoundedRectangleBorder
          builder: (context) => showPermissions(context, themeName));
    }

    if (darkModeOn)
      controller.setMapStyle(MapStyling.darkMapStyle);
    else
      controller.setMapStyle(MapStyling.lightMapStyle);
    locatePosition(controller);
  }

  void locatePosition(GoogleMapController controller) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    latlngPos = LatLng(position.latitude, position.longitude);
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latlngPos, zoom: 14)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              markers: _markers,
              mapToolbarEnabled: false,
              initialCameraPosition:
              CameraPosition(target: latlngPos, zoom: 14),
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
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
                  child: FutureBuilder<Widget>(
                      future: null,
                      builder: (BuildContext context,
                          AsyncSnapshot<Widget> snapshot) {
                        SharedPreferences prefs;
                        if (_source.keys.toList()[0] == ConnectivityResult.none) {
                          print('no internet');
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
                                  child: Icon(CupertinoIcons.wifi, color: Color.fromRGBO(
                                      174, 174, 174, 1.0)),
                                  padding: EdgeInsets.only(left: 15.0),
                                ),
                                Container(
                                    width:
                                    MediaQuery.of(context).size.width - 107,
                                    child: CupertinoButton(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Please connect to the internet',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.karla(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromRGBO(
                                                174, 174, 174, 1.0)),
                                      ),
                                      onPressed: () {
                                        print('no internet');
                                        AppSettings.openWIFISettings();
                                      },
                                    )),
                                Container(
                                  width: 48.0,
                                  height: 43.0,
                                  child: CupertinoButton(
                                      child: Image.asset('assets/Logo.png'),
                                      padding: EdgeInsets.all(0.0),
                                      onPressed: () async => {
                                        prefs = await SharedPreferences
                                            .getInstance(),
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
                                                showSettings(context,
                                                    setState, prefs)),
                                      }),
                                  padding: EdgeInsets.only(right: 15.0),
                                )
                              ],
                            ),
                          );
                        } else {
                          print(' internet');
                        }
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
                                        tiles = [],
                                        results = [],
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
                                      onPressed: () async => {
                                        prefs = await SharedPreferences
                                            .getInstance(),
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
                                                showSettings(context,
                                                    setState, prefs)),
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
                                  width: 35.0,
                                  height: 61.0,
                                  child: CupertinoButton(
                                    child: Icon(
                                      CupertinoIcons.chevron_back,
                                      color: currentLocationColor,
                                    ),
                                    padding: EdgeInsets.all(0.0),
                                    onPressed: () {
                                      currentCard = Cards.searchBar;
                                      setState(() {});
                                    },
                                  ),
                                  padding: EdgeInsets.only(left: 5.0),
                                ),
                                Text(currentLocationName,
                                    style: GoogleFonts.karla(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                        color:
                                        currentLocationColor)),
                                Padding(
                                  padding: EdgeInsets.only(left: 15.0),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: 30,
                                      child: Text(currentParkLocation.nrFreeSpots.toString(),
                                          style: GoogleFonts.karla(
                                              fontSize: 25.0,
                                              fontWeight: FontWeight.w500)),
                                      padding: EdgeInsets.only(top: 5.0),
                                    ),
                                    Container(
                                      height: 30,
                                      child: Text('Free Spots',
                                          style: GoogleFonts.karla(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500,
                                          )),
                                      padding: EdgeInsets.only(top: 3.0),
                                    )
                                  ],
                                ),
                                Spacer(),
                                Container(
                                  width: 80,
                                  height: 35,
                                  padding: EdgeInsets.only(right: 15.0),
                                  child: CupertinoButton(
                                      padding: EdgeInsets.all(0.0),
                                      onPressed: () {
                                        selectedSection = 'A';
                                        if(activeReservationExpiry.isBefore(DateTime.now()) || activeReservationExpiry == DateTime.now())
                                        {
                                          currentCard = Cards.sectionCard;
                                          setState(() {});
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                insetPadding: EdgeInsets.all(40),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20.0),
                                                ),
                                                title: Text('Reservation Error', style: GoogleFonts.karla(
                                                    fontSize: 20.0, fontWeight: FontWeight.w600)),
                                                content: Container(
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: <Widget> [
                                                        Text("You have to wait 20-30 minutes after ending a reservation before you can make another one", style: GoogleFonts.karla(
                                                            fontSize: 17.0, fontWeight: FontWeight.w500)),
                                                        Container(
                                                            padding: EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
                                                            width: MediaQuery.of(context).size.width-100,
                                                            height: 60,
                                                            child: CupertinoButton(
                                                              padding: EdgeInsets.all(0.0),
                                                              child: Text('Ok', style: GoogleFonts.karla(fontSize: 18.0, fontWeight: FontWeight.w600),),
                                                              onPressed: () {
                                                                Navigator.pop(context);
                                                              },
                                                              disabledColor: Color.fromRGBO(214, 109, 0, 1.0),
                                                              color: Color.fromRGBO(214, 109, 07, 1.0),
                                                              borderRadius: BorderRadius.all(Radius.circular(13.0)),
                                                            )
                                                        ),
                                                      ],
                                                    )
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      },
                                      child: Text("Pick",
                                          style: GoogleFonts.karla(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w600)),
                                      color: currentLocationColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(13.0))),
                                ),
                              ],
                            ),
                          );
                        } else if (currentCard == Cards.spotCard) {
                          return Container(
                            height: 247,
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
                                    InkWell(
                                      child: Row(children: <Widget>[
                                        Padding(
                                            padding:
                                            EdgeInsets.only(left: 8.0)),
                                        Container(
                                          height: 50,
                                          width: 8,
                                          padding: EdgeInsets.only(right: 8.0),
                                          child: IconButton(
                                            icon: const Icon(
                                                CupertinoIcons.chevron_back,
                                                size: 23),
                                            onPressed: () {},
                                          ),
                                        ),
                                        Container(
                                          width: 130,
                                          height: 62,
                                          padding: EdgeInsets.only(
                                              left: 17.0, top: 20.0),
                                          child: Text(
                                            "Reserve Spot",
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.karla(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ]),
                                      onTap: () {
                                        currentCard = Cards.pickCard;
                                        setState(() {});
                                      },
                                    ),
                                    Spacer(),
                                    Column(children: <Widget>[
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
                                          Color.fromRGBO(220, 170, 57, 1.0),
                                          color:
                                          Color.fromRGBO(220, 170, 57, 1.0),
                                        ),
                                      ),
                                      Padding(
                                          padding:
                                          EdgeInsets.only(bottom: 8.0)),
                                    ])
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                            padding:
                                            EdgeInsets.only(left: 20.0)),
                                        Text('Coordonates: ',
                                            style: GoogleFonts.karla(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w500,
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                        Text(
                                            currentParkLocation.coords.latitude
                                                .toStringAsFixed(3) +
                                                ', ' +
                                                currentParkLocation
                                                    .coords.longitude
                                                    .toStringAsFixed(3),
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
                                              searchedPosition = currentParkLocation.coords,
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
                                                  '$selectedMinutes min',
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
                                                          selectedMinutes =
                                                              value + 1;
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
                                                        Text('10 min'),
                                                        Text('11 min'),
                                                        Text('12 min'),
                                                        Text('13 min'),
                                                        Text('14 min'),
                                                        Text('15 min')
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
                                              fontWeight: FontWeight.w600),
                                        ),
                                        onPressed: selectedMinutes >= 1 ? () => {
                                          currentCard = Cards.paySpotCard,
                                          setState(() {})
                                        } : null,
                                        disabledColor:
                                        Color.fromRGBO(220, 170, 57, 0.5),
                                        color:
                                        Color.fromRGBO(220, 170, 57, 1.0),
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
                                    InkWell(
                                      child: Row(children: <Widget>[
                                        Padding(
                                            padding:
                                            EdgeInsets.only(left: 8.0)),
                                        Container(
                                          height: 50,
                                          width: 8,
                                          padding: EdgeInsets.only(right: 8.0),
                                          child: IconButton(
                                            icon: const Icon(
                                                CupertinoIcons.chevron_back,
                                                size: 23),
                                            onPressed: () {},
                                          ),
                                        ),
                                        Container(
                                          width: 130,
                                          height: 62,
                                          padding: EdgeInsets.only(
                                              left: 17.0, top: 20.0),
                                          child: Text(
                                            "Pay Spot",
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.karla(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ]),
                                      onTap: () {
                                        currentCard = Cards.spotCard;
                                        setState(() {});
                                      },
                                    ),
                                    Spacer(),
                                    Column(children: <Widget>[
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
                                          Color.fromRGBO(214, 109, 0, 1.0),
                                          color:
                                          Color.fromRGBO(214, 109, 0, 1.0),
                                        ),
                                      ),
                                      Padding(
                                          padding:
                                          EdgeInsets.only(bottom: 8.0)),
                                    ])
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.only(left: 20.0)),
                                    Text('Coordonates: ',
                                        style: GoogleFonts.karla(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context)
                                                .primaryColor)),
                                    Text(
                                        currentParkLocation.coords.latitude
                                            .toStringAsFixed(3) +
                                            ', ' +
                                            currentParkLocation.coords.longitude
                                                .toStringAsFixed(3),
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
                                          searchedPosition = currentParkLocation.coords,
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
                                    Text('$selectedMinutes min',
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
                                Container(
                                  width: MediaQuery.of(context).size.width - 58,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(14.0)),
                                    border: Border.all(color: payBorderColor, width: 1),
                                  ),
                                  child: CupertinoButton(
                                    padding: EdgeInsets.all(0.0),
                                    child: Center(
                                      child: Row(
                                          children: <Widget> [
                                            Padding(padding: EdgeInsets.only(left: (MediaQuery.of(context).size.width - 168)/2)),
                                            Text(
                                              'Pay with ',
                                              style: GoogleFonts.karla(
                                                  fontSize: 17.0, fontWeight: FontWeight.w600, color: payTextColor),
                                            ),
                                            Image.asset(payAsset, height: 23.0,)
                                          ]
                                      ),
                                    ),
                                    onPressed: () => {
                                      currentCard = Cards.paidCard,
                                      setState(() {
                                        activeReservationExpiry = DateTime.now().add(Duration(minutes: selectedMinutes+30));
                                        print(activeReservationExpiry);
                                      }),
                                      startTimer(),
                                      if (selectedMinutes > 5) {
                                        create5MinNotification(selectedMinutes-5, 0)
                                      },
                                      create1MinNotification(selectedMinutes-1, 0),
                                      createReservationNotification(selectedMinutes, 0),
                                      reset()
                                    },
                                    disabledColor: payBtnColor,
                                    color: payBtnColor,
                                    borderRadius: BorderRadius.all(Radius.circular(13.0)),

                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(top: 8.0),),
                                Container(
                                  width: MediaQuery.of(context).size.width - 58,
                                  height: 45,
                                  child: CupertinoButton(
                                    padding: EdgeInsets.all(0.0),
                                    child: Text(
                                      'Pay with **** **** **** 9000',
                                      style: GoogleFonts.karla(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    onPressed: () => {
                                      currentCard = Cards.paidCard,
                                      setState(() {
                                        activeReservationExpiry = DateTime.now().add(Duration(minutes: selectedMinutes+30));
                                        print(activeReservationExpiry);
                                      }),
                                      startTimer(),
                                      if (selectedMinutes > 5) {
                                        create5MinNotification(selectedMinutes-5, 0)
                                      },
                                      create1MinNotification(selectedMinutes-1, 0),
                                      createReservationNotification(selectedMinutes, 0),
                                      reset()
                                    },
                                    disabledColor:
                                    Color.fromRGBO(214, 109, 0, 1.0),
                                    color: Color.fromRGBO(214, 109, 0, 1.0),
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
                                          fontWeight: FontWeight.w600),
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
                                    Color.fromRGBO(255, 158, 25, 1.0),
                                    color: Color.fromRGBO(255, 158, 25, 1.0),
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

                          String twoDigits(int n) =>
                              n.toString().padLeft(2, '0');
                          final minutes =
                          twoDigits(duration.inMinutes.remainder(60));
                          final seconds =
                          twoDigits(duration.inSeconds.remainder(60));

                          return Container(
                            height: 270,
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
                                      color: Theme.of(context).indicatorColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  padding:
                                  EdgeInsets.only(left: 10.0, right: 10.0),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 15.0),
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      'Time left',
                                      style: GoogleFonts.karla(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w600,
                                          color:
                                          Theme.of(context).primaryColor),
                                    ),
                                    Text(
                                      '$minutes:$seconds',
                                      style: GoogleFonts.karla(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w600,
                                          color: Color.fromRGBO(
                                              149, 46, 0, 1.0)),
                                    )
                                  ],
                                ),
                                Padding(padding: EdgeInsets.only(top: 15.0)),
                                Row(
                                    children: <Widget> [
                                      Padding(padding: EdgeInsets.only(left: (MediaQuery.of(context).size.width-312)/2)),
                                      Container(
                                        width: 65,
                                        height: 65,
                                        child: CupertinoButton(
                                          padding: EdgeInsets.all(0.0),
                                          child: Icon(
                                            CupertinoIcons.xmark,
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            size: 33,
                                          ),
                                          onPressed: () => {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    insetPadding:
                                                    EdgeInsets.all(40),
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                    ),
                                                    title: Text('Cancel Reservation',
                                                        style:
                                                        GoogleFonts.karla(
                                                            fontSize: 20.0,
                                                            fontWeight:
                                                            FontWeight
                                                                .w600)),
                                                    content: Container(
                                                        child: Column(
                                                          mainAxisSize:
                                                          MainAxisSize.min,
                                                          children: <Widget>[
                                                            Text('Are you sure you want to cancel? You will only be refunded the remaining time',
                                                                style: GoogleFonts.karla(
                                                                    fontSize: 17.0,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                            Container(
                                                                padding:
                                                                EdgeInsets.only(
                                                                    top: 15.0,
                                                                    left: 5.0,
                                                                    right: 5.0),
                                                                width: MediaQuery.of(
                                                                    context)
                                                                    .size
                                                                    .width -
                                                                    100,
                                                                height: 60,
                                                                child:
                                                                CupertinoButton(
                                                                  padding:
                                                                  EdgeInsets
                                                                      .all(0.0),
                                                                  child: Text(
                                                                    'Yes',
                                                                    style: GoogleFonts.karla(
                                                                        fontSize:
                                                                        18.0,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                                  ),
                                                                  onPressed: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                    currentCard = Cards.searchBar;
                                                                    setState(() {

                                                                      activeReservationExpiry = DateTime.now();//.add(Duration(minutes: 20));
                                                                      timer!.cancel();
                                                                    });
                                                                    cancelReservationNotification();
                                                                  },
                                                                  disabledColor:
                                                                  Color
                                                                      .fromRGBO(
                                                                      149,
                                                                      46,
                                                                      0,
                                                                      1.0),
                                                                  color: Color
                                                                      .fromRGBO(
                                                                      149,
                                                                      46,
                                                                      0,
                                                                      1.0),
                                                                  borderRadius: BorderRadius
                                                                      .all(Radius
                                                                      .circular(
                                                                      13.0)),
                                                                )),
                                                            Container(
                                                                padding:
                                                                EdgeInsets.only(
                                                                    top: 15.0,
                                                                    left: 5.0,
                                                                    right: 5.0),
                                                                width: 250,
                                                                height: 40,
                                                                child:
                                                                CupertinoButton(
                                                                  padding:
                                                                  EdgeInsets
                                                                      .all(0.0),
                                                                  child: Text(
                                                                    'Cancel',
                                                                    style: GoogleFonts.karla(
                                                                        fontSize:
                                                                        18.0,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                        color: Color
                                                                            .fromRGBO(
                                                                            149,
                                                                            46,
                                                                            0,
                                                                            1.0)),
                                                                  ),
                                                                  onPressed: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  borderRadius: BorderRadius
                                                                      .all(Radius
                                                                      .circular(
                                                                      13.0)),
                                                                ))
                                                          ],
                                                        )),
                                                  );
                                                })
                                          },
                                          disabledColor:
                                          Color.fromRGBO(149, 46, 0, 1.0),
                                          color:
                                          Color.fromRGBO(149, 46, 0, 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(40.0)),
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.only(left: 10.0)),
                                      Container(
                                        width: 65,
                                        height: 65,
                                        child: CupertinoButton(
                                          padding: EdgeInsets.all(0.0),
                                          child: Icon(
                                            CupertinoIcons.arrow_branch,
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            size: 33,
                                          ),
                                          onPressed: () async => {
                                            searchedPosition = currentParkLocation.coords,
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
                                          disabledColor:
                                          Color.fromRGBO(220, 170, 57, 1.0),
                                          color: Color.fromRGBO(220, 170, 57, 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(40.0)),
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.only(left: 10.0)),
                                      Container(
                                        width: 65,
                                        height: 65,
                                        child: CupertinoButton(
                                          padding: EdgeInsets.all(0.0),
                                          child: Icon(
                                            CupertinoIcons.clock,
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            size: 35,
                                          ),
                                          onPressed: ()  {
                                            if (delayActive == false) {
                                              if (showedDelayAlert == false) {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      insetPadding: EdgeInsets.all(40),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20.0),
                                                      ),
                                                      title: Text('Delay Reservation', style: GoogleFonts.karla(
                                                          fontSize: 20.0, fontWeight: FontWeight.w600)),
                                                      content: Container(
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: <Widget> [
                                                              Text("You are able to delay your reservation for up to 15 minutes, but you can only delay once. Press ok to continue.", style: GoogleFonts.karla(
                                                                  fontSize: 17.0, fontWeight: FontWeight.w500)),
                                                              Container(
                                                                  padding: EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
                                                                  width: MediaQuery.of(context).size.width-100,
                                                                  height: 60,
                                                                  child: CupertinoButton(
                                                                    padding: EdgeInsets.all(0.0),
                                                                    child: Text('Ok', style: GoogleFonts.karla(fontSize: 18.0, fontWeight: FontWeight.w600),),
                                                                    onPressed: () async {
                                                                      _saveShowedDelayAlert();
                                                                      showedDelayAlert = await _showedDelayAlert();
                                                                      Navigator.pop(context);
                                                                      currentCard = Cards.delayCard;
                                                                      setState(() {});
                                                                    },
                                                                    disabledColor: Color.fromRGBO(103, 72, 5, 1.0),
                                                                    color: Color.fromRGBO(103, 72, 5, 1.0),
                                                                    borderRadius: BorderRadius.all(Radius.circular(13.0)),
                                                                  )
                                                              ),
                                                              Container(
                                                                  padding: EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
                                                                  width: MediaQuery.of(context).size.width-100,
                                                                  height: 60,
                                                                  child: CupertinoButton(
                                                                    padding: EdgeInsets.all(0.0),
                                                                    child: Text('Cancel', style: GoogleFonts.karla(fontSize: 18.0, fontWeight: FontWeight.w600, color: Color.fromRGBO(103, 72, 5, 1.0)),),
                                                                    onPressed: () {
                                                                      Navigator.pop(context);
                                                                    },
                                                                    borderRadius: BorderRadius.all(Radius.circular(13.0)),
                                                                  )
                                                              ),
                                                            ],
                                                          )
                                                      ),
                                                    );
                                                  },
                                                );
                                              } else {
                                                currentCard = Cards.delayCard;
                                                setState(() {});
                                              }
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    insetPadding: EdgeInsets.all(40),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(20.0),
                                                    ),
                                                    title: Text('Delay Error', style: GoogleFonts.karla(
                                                        fontSize: 20.0, fontWeight: FontWeight.w600)),
                                                    content: Container(
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: <Widget> [
                                                            Text("We are sorry, but you can only delay once, if you hurry you may still find your spot free", style: GoogleFonts.karla(
                                                                fontSize: 17.0, fontWeight: FontWeight.w500)),
                                                            Container(
                                                                padding: EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
                                                                width: MediaQuery.of(context).size.width-100,
                                                                height: 60,
                                                                child: CupertinoButton(
                                                                  padding: EdgeInsets.all(0.0),
                                                                  child: Text('Ok', style: GoogleFonts.karla(fontSize: 18.0, fontWeight: FontWeight.w600),),
                                                                  onPressed: () {
                                                                    Navigator.pop(context);
                                                                  },
                                                                  disabledColor: Color.fromRGBO(214, 109, 0, 1.0),
                                                                  color: Color.fromRGBO(214, 109, 07, 1.0),
                                                                  borderRadius: BorderRadius.all(Radius.circular(13.0)),
                                                                )
                                                            ),
                                                          ],
                                                        )
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          disabledColor:
                                          Color.fromRGBO(103, 72, 5, 1.0),
                                          color:
                                          Color.fromRGBO(103, 72, 5, 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(40.0)),
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.only(left: 10.0)),
                                      Container(
                                        width: 65,
                                        height: 65,
                                        child: CupertinoButton(
                                          padding: EdgeInsets.all(0.0),
                                          child: Icon(
                                            CupertinoIcons.lock,
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            size: 38,
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  insetPadding: EdgeInsets.all(40),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20.0),
                                                  ),
                                                  title: Text('Unlock', style: GoogleFonts.karla(
                                                      fontSize: 20.0, fontWeight: FontWeight.w600)),
                                                  content: Container(
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: <Widget> [
                                                          Text("You are about to unlock your spot, once you proceed your reservation is complete and the spot becomes free to park on. Do you want to proceed?", style: GoogleFonts.karla(
                                                              fontSize: 17.0, fontWeight: FontWeight.w500)),
                                                          Container(
                                                              padding: EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
                                                              width: MediaQuery.of(context).size.width-100,
                                                              height: 60,
                                                              child: CupertinoButton(
                                                                padding: EdgeInsets.all(0.0),
                                                                child: Text('Unlock', style: GoogleFonts.karla(fontSize: 18.0, fontWeight: FontWeight.w600),),
                                                                onPressed: () {
                                                                  Navigator.pop(context);
                                                                  currentCard = Cards.unlockedCard;
                                                                  cancelReservationNotification();
                                                                  setState(() {});
                                                                },
                                                                disabledColor: Color.fromRGBO(214, 109, 0, 1.0),
                                                                color: Color.fromRGBO(214, 109, 07, 1.0),
                                                                borderRadius: BorderRadius.all(Radius.circular(13.0)),
                                                              )
                                                          ),
                                                          Container(
                                                              padding: EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
                                                              width: MediaQuery.of(context).size.width-100,
                                                              height: 60,
                                                              child: CupertinoButton(
                                                                padding: EdgeInsets.all(0.0),
                                                                child: Text('Ok', style: GoogleFonts.karla(fontSize: 18.0, fontWeight: FontWeight.w600, color: Color.fromRGBO(214, 109, 0, 1.0),),),
                                                                onPressed: () {
                                                                  Navigator.pop(context);
                                                                },
                                                                 borderRadius: BorderRadius.all(Radius.circular(13.0)),
                                                              )
                                                          ),
                                                        ],
                                                      )
                                                  ),
                                                );
                                              },
                                            );

                                          },
                                          disabledColor:
                                          Color.fromRGBO(214, 109, 0, 1.0),
                                          color: Color.fromRGBO(214, 109, 0, 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(40.0)),
                                        ),
                                      ),
                                    ]
                                )
                              ],
                            ),
                          );
                        } else if (currentCard == Cards.unlockedCard) {
                          return Container(
                            height: 220,
                            width: MediaQuery.of(context).size.width - 22,
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
                                      padding: EdgeInsets.only(
                                          left: 17.0, top: 20.0),
                                      child: Text(
                                        "Unlock Spot",
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.karla(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      height: 60,
                                      width: 50,
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: IconButton(
                                        icon: const Icon(CupertinoIcons.xmark,
                                            size: 23),
                                        onPressed: () {
                                          currentCard = Cards.searchBar;
                                          setState(() {});
                                        },
                                        disabledColor:
                                        Color.fromRGBO(143, 102, 13, 1.0),
                                        color:
                                        Color.fromRGBO(143, 102, 13, 1.0),
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                    padding:
                                    EdgeInsets.only(left: 20, right: 20),
                                    alignment: Alignment.center,
                                    child: Container(
                                      child: Text(
                                        "Your spot is unlocked now, after parking you can come back here to find your car",
                                        style: GoogleFonts.karla(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromRGBO(
                                                161, 161, 161, 1.0)),
                                        textAlign: TextAlign.center,
                                      ),
                                    )),
                                Container(
                                    padding: EdgeInsets.only(top: 20),
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width -
                                          58,
                                      height: 45,
                                      child: CupertinoButton(
                                        child: Text(
                                          'Unlocked',
                                          style: GoogleFonts.karla(
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        onPressed: null,
                                        disabledColor:
                                        Color.fromRGBO(142, 102, 13, 1.0),
                                        color:
                                        Color.fromRGBO(143, 102, 13, 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14.0)),
                                      ),
                                    )),
                                Container(
                                    padding:
                                    EdgeInsets.only(top: 5, bottom: 15),
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 330,
                                      height: 45,
                                      child: CupertinoButton(
                                        padding: EdgeInsets.all(0.0),
                                        child: Text(
                                          'Get Directions to Spot',
                                          style: GoogleFonts.karla(
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromRGBO(
                                                  143, 102, 13, 1.0)),
                                        ),
                                        onPressed: () async => {
                                          searchedPosition = currentParkLocation.coords,
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
                                        Color.fromRGBO(142, 102, 13, 0.0),
                                        color:
                                        Color.fromRGBO(143, 102, 13, 0.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14.0)),
                                      ),
                                    ))
                              ],
                            ),
                          );
                        } else if (currentCard == Cards.delayCard) {
                          return Container(
                              width: MediaQuery.of(context).size.width - 22,
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
                                      InkWell(
                                        child: Row(children: <Widget>[
                                          Padding(
                                              padding:
                                              EdgeInsets.only(left: 8.0)),
                                          Container(
                                            height: 50,
                                            width: 8,
                                            padding:
                                            EdgeInsets.only(right: 8.0),
                                            child: IconButton(
                                              icon: const Icon(
                                                  CupertinoIcons.chevron_back,
                                                  size: 23),
                                              onPressed: () {},
                                            ),
                                          ),
                                          Container(
                                            width: 130,
                                            height: 62,
                                            padding: EdgeInsets.only(
                                                left: 17.0, top: 20.0),
                                            child: Text(
                                              "Delay",
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.karla(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ]),
                                        onTap: () {
                                          currentCard = Cards.unlockCard;
                                          setState(() {});
                                        },
                                      ),
                                      Spacer(),
                                      Container(
                                        height: 60,
                                        width: 50,
                                        padding: EdgeInsets.only(right: 8.0),
                                        child: IconButton(
                                          icon: const Icon(CupertinoIcons.xmark,
                                              size: 23),
                                          onPressed: () {
                                            currentCard = Cards.searchBar;
                                            setState(() {});
                                          },
                                          disabledColor:
                                          Color.fromRGBO(143, 102, 13, 1.0),
                                          color:
                                          Color.fromRGBO(143, 102, 13, 1.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 327,
                                    height: 45,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "You can delay your reservation by up to 15 minutes if caught in traffic, you can set here an estimate of your delay and you will be extra charged for keeping the spot reserved for more minutes.",
                                      style: GoogleFonts.karla(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromRGBO(
                                              161, 161, 161, 1.0)),
                                    ),
                                  ),
                                  Container(
                                      padding:
                                      EdgeInsets.only(top: 10, left: 25),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            child: Column(
                                              children: <Widget>[
                                                Text("0",
                                                    style: GoogleFonts.karla(
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        color: Color.fromRGBO(
                                                            143,
                                                            102,
                                                            13,
                                                            1.0))),
                                                Text("min",
                                                    style: GoogleFonts.karla(
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        color: Color.fromRGBO(
                                                            143,
                                                            102,
                                                            13,
                                                            1.0))),
                                              ],
                                            ),
                                          ),
                                          Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                                  127,
                                              child: CupertinoSlider(
                                                value: progress,
                                                min: 0.0,
                                                max: 15.0,
                                                activeColor: Color.fromRGBO(
                                                    143, 102, 13, 1.0),
                                                divisions: 15,
                                                onChanged: (value) {
                                                  setState(() {
                                                    progress =
                                                        value.roundToDouble();
                                                  });
                                                },
                                              )),
                                          Container(
                                            child: Column(
                                              children: <Widget>[
                                                Text("15",
                                                    style: GoogleFonts.karla(
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        color: Color.fromRGBO(
                                                            143,
                                                            102,
                                                            13,
                                                            1.0))),
                                                Text("min",
                                                    style: GoogleFonts.karla(
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        color: Color.fromRGBO(
                                                            143,
                                                            102,
                                                            13,
                                                            1.0))),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(
                                            top: 5,
                                            left: (MediaQuery.of(context)
                                                .size
                                                .width -
                                                130) /
                                                2),
                                        child: Text("Charge",
                                            style: GoogleFonts.karla(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Text(
                                            "  " +
                                                progress.toInt().toString() +
                                                " RON",
                                            style: GoogleFonts.karla(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Color.fromRGBO(
                                                    143, 102, 13, 1.0))),
                                      )
                                    ],
                                  ),
                                  Spacer(),
                                  Container(
                                      alignment: Alignment.center,
                                      child: Container(
                                        width:
                                        MediaQuery.of(context).size.width -
                                            58,
                                        height: 60,
                                        child: CupertinoButton(
                                          child: Text(
                                            "Delay for " +
                                                progress.toInt().toString() +
                                                " minutes",
                                            style: GoogleFonts.karla(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          onPressed: () => {
                                            currentCard = Cards.payDelayCard,
                                            setState(() {})
                                          },
                                          disabledColor:
                                          Color.fromRGBO(142, 102, 13, 1.0),
                                          color:
                                          Color.fromRGBO(142, 102, 13, 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0)),
                                        ),
                                        padding: EdgeInsets.only(bottom: 15),
                                      )),
                                ],
                              ));
                        } else if (currentCard == Cards.payDelayCard) {
                          return Container(
                              width: MediaQuery.of(context).size.width - 22,
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
                                      InkWell(
                                        child: Row(children: <Widget>[
                                          Padding(
                                              padding:
                                              EdgeInsets.only(left: 8.0)),
                                          Container(
                                            height: 50,
                                            width: 8,
                                            padding:
                                            EdgeInsets.only(right: 8.0),
                                            child: IconButton(
                                              icon: const Icon(
                                                  CupertinoIcons.chevron_back,
                                                  size: 23),
                                              onPressed: () {},
                                            ),
                                          ),
                                          Container(
                                            width: 130,
                                            height: 62,
                                            padding: EdgeInsets.only(
                                                left: 17.0, top: 20.0),
                                            child: Text(
                                              "Pay Delay",
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.karla(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ]),
                                        onTap: () {
                                          currentCard = Cards.delayCard;
                                          setState(() {});
                                        },
                                      ),
                                      Spacer(),
                                      Container(
                                        height: 60,
                                        width: 50,
                                        padding: EdgeInsets.only(right: 8.0),
                                        child: IconButton(
                                          icon: const Icon(CupertinoIcons.xmark,
                                              size: 23),
                                          onPressed: () {
                                            currentCard = Cards.searchBar;
                                            setState(() {});
                                          },
                                          disabledColor:
                                          Color.fromRGBO(214, 109, 0, 1.0),
                                          color:
                                          Color.fromRGBO(214, 109, 0, 1.0),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                          padding: EdgeInsets.only(
                                              left: (MediaQuery.of(context)
                                                  .size
                                                  .width -
                                                  160) /
                                                  2),
                                          child: Text("Charge",
                                              style: GoogleFonts.karla(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                              ))),
                                      Container(
                                        child: Text(
                                            "  " +
                                                progress.toInt().toString() +
                                                " RON",
                                            style: GoogleFonts.karla(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                color: Color.fromRGBO(
                                                    214, 109, 0, 1.0))),
                                      )
                                    ],
                                  ),
                                  Spacer(),
                                  Container(
                                    width: MediaQuery.of(context).size.width - 58,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(14.0)),
                                      border: Border.all(color: payBorderColor, width: 1),
                                    ),
                                    child: CupertinoButton(
                                      padding: EdgeInsets.all(0.0),
                                      child: Center(
                                        child: Row(
                                            children: <Widget> [
                                              Padding(padding: EdgeInsets.only(left: (MediaQuery.of(context).size.width - 168)/2)),
                                              Text(
                                                'Pay with ',
                                                style: GoogleFonts.karla(
                                                    fontSize: 17.0, fontWeight: FontWeight.w600, color: payTextColor),
                                              ),
                                              Image.asset(payAsset, height: 23.0,)
                                            ]
                                        ),
                                      ),
                                      onPressed: () => {
                                        currentCard = Cards.paidCard,
                                        setState(() {
                                          activeReservationExpiry = DateTime.now().add(Duration(minutes: selectedMinutes+30));
                                          print(activeReservationExpiry);
                                        }),
                                        startTimer(),
                                        if (selectedMinutes > 5) {
                                          create5MinNotification(selectedMinutes-5, 0)
                                        },
                                        create1MinNotification(selectedMinutes-1, 0),
                                        createReservationNotification(selectedMinutes, 0),
                                        reset()
                                      },
                                      disabledColor: payBtnColor,
                                      color: payBtnColor,
                                      borderRadius: BorderRadius.all(Radius.circular(13.0)),

                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 8.0),),
                                  Container(
                                    width:
                                    MediaQuery.of(context).size.width - 58,
                                    height: 45,
                                    child: CupertinoButton(
                                      padding: EdgeInsets.all(0.0),
                                      child: Text(
                                        'Pay with **** **** **** 9000',
                                        style: GoogleFonts.karla(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      onPressed: () => {
                                        activeReservationExpiry.add(Duration(minutes: duration.inMinutes)),
                                        currentCard = Cards.paidCard,
                                        setState(() {
                                          delayActive = true;
                                        }),
                                        resetDelay(progress.toInt()),
                                        if (duration.inMinutes > 5) {
                                          create5MinNotification(duration.inMinutes-5, duration.inSeconds-duration.inMinutes*60)
                                        },
                                        create1MinNotification(duration.inMinutes-1, duration.inSeconds-duration.inMinutes*60),
                                        createReservationNotification(duration.inMinutes, duration.inSeconds-duration.inMinutes*60),
                                      },
                                      disabledColor:
                                      Color.fromRGBO(214, 109, 0, 1.0),
                                      color: Color.fromRGBO(214, 109, 0, 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(13.0)),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                  ),
                                  Container(
                                    width:
                                    MediaQuery.of(context).size.width - 58,
                                    height: 45,
                                    child: CupertinoButton(
                                      padding: EdgeInsets.all(0.0),
                                      child: Text(
                                        'Different Payment Method',
                                        style: GoogleFonts.karla(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w600),
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
                                      Color.fromRGBO(255, 158, 25, 1.0),
                                      color: Color.fromRGBO(255, 158, 25, 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(13.0)),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 15.0),
                                  )
                                ],
                              ));
                        } else if (currentCard == Cards.pickCard) {
                          return Container(
                              width: MediaQuery.of(context).size.width - 22,
                              height: getHeightFromSection(currentParkLocation
                                  .sections[selectedSectionNr]),
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
                                      InkWell(
                                        child: Row(children: <Widget>[
                                          Padding(
                                              padding:
                                              EdgeInsets.only(left: 8.0)),
                                          Container(
                                            height: 50,
                                            width: 8,
                                            padding:
                                            EdgeInsets.only(right: 8.0),
                                            child: IconButton(
                                              icon: const Icon(
                                                  CupertinoIcons.chevron_back,
                                                  size: 23),
                                              onPressed: () {},
                                            ),
                                          ),
                                          Container(
                                            width: 130,
                                            height: 62,
                                            padding: EdgeInsets.only(
                                                left: 17.0, top: 20.0),
                                            child: Text(
                                              "Pick Spot",
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.karla(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ]),
                                        onTap: () {
                                          currentCard = Cards.sectionCard;
                                          setState(() {});
                                        },
                                      ),
                                      Spacer(),
                                      Container(
                                        height: 60,
                                        width: 50,
                                        padding: EdgeInsets.only(right: 8.0),
                                        child: IconButton(
                                          icon: const Icon(CupertinoIcons.xmark,
                                              size: 23),
                                          onPressed: () {
                                            currentCard = Cards.searchBar;
                                            setState(() {});
                                          },
                                          disabledColor:
                                          Color.fromRGBO(255, 193, 25, 1.0),
                                          color:
                                          Color.fromRGBO(255, 193, 25, 1.0),
                                        ),
                                      )
                                    ],
                                  ),
                                  SmartLayout(context,setState,currentParkLocation.sections[selectedSectionNr]),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                  ),
                                  Container(
                                      height: 36,
                                      width: MediaQuery.of(context).size.width -
                                          50,
                                      decoration: BoxDecoration(
                                        color:
                                        Color.fromRGBO(130, 130, 130, 0.18),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(9)),
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            child: Icon(
                                              infoIcon,
                                              color: infoColor,
                                            ),
                                            padding: EdgeInsets.only(left: 6.0),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 6.0),
                                          ),
                                          Text(
                                            infoText,
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.karla(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context)
                                                    .indicatorColor),
                                          )
                                        ],
                                      )),
                                  Spacer(),
                                  Container(
                                    width:
                                    MediaQuery.of(context).size.width - 58,
                                    height: 45,
                                    child: CupertinoButton(
                                      padding: EdgeInsets.all(0.0),
                                      child: Text(
                                        'Continue',
                                        style: GoogleFonts.karla(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      onPressed: infoIcon ==
                                          CupertinoIcons.checkmark
                                          ? () => {
                                        currentCard = Cards.spotCard,
                                        setState(() {})
                                      }
                                          : null,
                                      disabledColor:
                                      Color.fromRGBO(255, 193, 25, 0.5),
                                      color: Color.fromRGBO(255, 193, 25, 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(13.0)),
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(bottom: 15.0)),
                                ],
                              ));
                        } else if (currentCard == Cards.sectionCard) {
                          return Container(
                              width: MediaQuery.of(context).size.width - 22,
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
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      InkWell(
                                        child: Row(children: <Widget>[
                                          Padding(
                                              padding:
                                              EdgeInsets.only(left: 8.0)),
                                          Container(
                                            height: 50,
                                            width: 8,
                                            padding:
                                            EdgeInsets.only(right: 8.0),
                                            child: IconButton(
                                              icon: const Icon(
                                                  CupertinoIcons.chevron_back,
                                                  size: 23),
                                              onPressed: () {},
                                            ),
                                          ),
                                          Container(
                                            width: 130,
                                            height: 62,
                                            padding: EdgeInsets.only(
                                                left: 17.0, top: 20.0),
                                            child: Text(
                                              "Pick Section",
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.karla(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ]),
                                        onTap: () {
                                          currentCard = Cards.resultBar;
                                          setState(() {});
                                        },
                                      ),
                                      Spacer(),
                                      Container(
                                        height: 60,
                                        width: 50,
                                        padding: EdgeInsets.only(right: 8.0),
                                        child: IconButton(
                                          icon: const Icon(CupertinoIcons.xmark,
                                              size: 23),
                                          onPressed: () {
                                            currentCard = Cards.searchBar;
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
                                  Padding(padding: EdgeInsets.only(top: 10.0)),
                                  Container(
                                    width:
                                    MediaQuery.of(context).size.width - 36,
                                    child: Image.asset(sectionAsset),
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 8.0)),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 20.0, top: 25.0)),
                                      Text('Section',
                                          style: GoogleFonts.karla(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                      Spacer(),
                                      PopupMenuButton(
                                          color:
                                          Color.fromRGBO(220, 170, 57, 1.0),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(23.0))),
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                right: 15.0, top: 3.0),
                                            width: 102.0,
                                            height: 40.0,
                                            child: CupertinoButton(
                                              padding: EdgeInsets.all(0.0),
                                              child: Text(
                                                selectedSection,
                                                style: GoogleFonts.karla(
                                                    fontSize: 22.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color.fromRGBO(
                                                        220, 170, 57, 1.0)),
                                              ),
                                              onPressed: null,
                                              disabledColor: Color.fromRGBO(
                                                  128, 128, 129, 0.3),
                                              color: Color.fromRGBO(
                                                  128, 128, 129, 0.25),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(13.0)),
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
                                                        selectedSectionNr =
                                                            value;
                                                        selectedSection =
                                                            currentParkLocation
                                                                .sections[
                                                            value]
                                                                .sectionLetter;
                                                      });
                                                    },
                                                    itemExtent: 32.0,
                                                    children: generateSections(
                                                        currentParkLocation
                                                            .sections),
                                                  )),
                                            ),
                                          ]),
                                    ],
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 8.0)),
                                  Container(
                                    width:
                                    MediaQuery.of(context).size.width - 58,
                                    height: 45,
                                    child: CupertinoButton(
                                      padding: EdgeInsets.all(0.0),
                                      child: Text(
                                        'Pick from section $selectedSection',
                                        style: GoogleFonts.karla(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      onPressed: () => {
                                        selectedNumber = -1,
                                        infoIcon = CupertinoIcons.info_circle,
                                        infoColor =
                                            Color.fromRGBO(255, 193, 25, 1.0),
                                        infoText =
                                        "Select a spot to get info about it.",
                                        currentCard = Cards.pickCard,
                                        setState(() {})
                                      },
                                      disabledColor:
                                      Color.fromRGBO(220, 170, 57, 1.0),
                                      color: Color.fromRGBO(220, 170, 57, 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(13.0)),
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(bottom: 17.0)),
                                ],
                              ));
                        } else if (currentCard == Cards.paidCard) {
                          return Container(
                              width: MediaQuery.of(context).size.width - 22,
//height: 242,
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
                                        height: 60,
                                        padding: EdgeInsets.only(
                                            left: 17.0, top: 20.0),
                                        child: Text(
                                          "Payment Succeded",
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.karla(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        height: 60,
                                        width: 50,
                                        padding: EdgeInsets.only(right: 8.0),
                                        child: IconButton(
                                          icon: const Icon(CupertinoIcons.xmark,
                                              size: 23),
                                          onPressed: () {
                                            currentCard = Cards.searchBar;
                                            setState(() {});
                                          },
                                          disabledColor: Color.fromRGBO(
                                              138, 126, 114, 1.0),
                                          color: Color.fromRGBO(
                                              138, 126, 114, 1.0),
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                      child: Icon(CupertinoIcons.checkmark_seal,
                                          color: Color.fromRGBO(
                                              138, 126, 114, 1.0),
                                          size: 80)),
                                  Padding(
                                    padding: EdgeInsets.only(top: 13.0),
                                  ),
                                  Container(
                                    width:
                                    MediaQuery.of(context).size.width - 58,
                                    height: 45,
                                    child: CupertinoButton(
                                      padding: EdgeInsets.all(0.0),
                                      child: Text(
                                        'See Spot',
                                        style: GoogleFonts.karla(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      onPressed: () => {
                                        currentCard = Cards.unlockCard,
                                        setState(() {})
                                      },
                                      disabledColor:
                                      Color.fromRGBO(138, 126, 114, 1.0),
                                      color: Color.fromRGBO(138, 126, 114, 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(13.0)),
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(bottom: 15.0)),
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
                                      tiles = [],
                                      results = [],
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
                                    onPressed: () async => {
                                      prefs = await SharedPreferences
                                          .getInstance(),
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
                                              showSettings(context,
                                                  setState, prefs)),
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

  _readPrefferedDirectionsApp() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'directions_app_pref';
    var value = prefs.getString(key) ?? 'Google Maps';
    if (Platform.isIOS) {
      value = prefs.getString(key) ?? 'Apple Maps';
    }
    selectedMapsApp = value;
    print('Read: $value');
  }

  Future<bool> _readNeverLaunched() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'never_launched';
    final value = prefs.getBool(key) ?? true;
    print(value);
    return value;
  }

  Future<bool> _showedDelayAlert() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'delay_alert';
    final value = prefs.getBool(key) ?? false;
    print(value);
    return value;
  }

  _saveShowedDelayAlert() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'delay_alert';
    prefs.setBool(key, true);
    print('Saved showed');
  }
  
  _decidePaymentPlatform() {
    if (Platform.isIOS) {
      payBtnColor = Colors.black;
      payBorderColor = Colors.white;
      payTextColor = Colors.white;
      payAsset = 'assets/ApplePay.png';
    } else {
      payBtnColor = Colors.white;
      payBorderColor = Colors.black;
      payTextColor = Colors.black;
      payAsset = 'assets/GPay.png';
    }
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