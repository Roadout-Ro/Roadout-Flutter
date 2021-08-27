import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'database_service.dart';

class Spot {
  int spotNr = 0;
  int spotState = 0;

  Spot(int spotNr, int spotState) {
    this.spotNr = spotNr;
    this.spotState = spotState;
  }
}

class ParkingLocation {
  List<Spot> spots = [];
  LatLng coords = LatLng(46.768728, 23.592564);
  int nrSpots = 0;
  int nrFreeSpots = 0;
  String name = "";

  ParkingLocation(List<Spot> spots, LatLng coords, String name) {
    this.spots = spots;
    this.coords = coords;
    this.nrSpots = spots.length;
    this.nrFreeSpots = 0;
    for (Spot spot in spots) {
      if (spot.spotState == 0)
        this.nrFreeSpots += 1;
    }
    print(this.nrFreeSpots);
    this.name = name;
  }

}

List<ParkingLocation> parkingLocations = [
  ParkingLocation(spots, LatLng(46.770439, 23.591423), 'Old Town'),
  ParkingLocation(spots, LatLng(46.770825, 23.627749), 'Iulius Mall'),
  ParkingLocation(spots, LatLng(46.782393, 23.683243), 'Avram Iancu Airport'),
  ParkingLocation(spots, LatLng(46.773384, 23.578821), 'Cetatuia'),
  ParkingLocation(spots, LatLng(46.757431, 23.592311), 'Zorilor')
];

List<Widget> generateSections(List<String> sections) {
  List<Widget> children = [];
  String sec;
  for (sec in sections) {
    children.add(Text(sec));
  }
  return children;
}