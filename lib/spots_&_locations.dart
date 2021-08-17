import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  String layoutCode = '''''';
  String name = "";

  ParkingLocation(List<Spot> spots, LatLng coords, String layoutCode, String name) {
    this.spots = spots;
    this.coords = coords;
    this.nrSpots = spots.length;
    this.nrFreeSpots = 0;
    for (Spot spot in spots) {
      if (spot.spotState == 0)
        this.nrFreeSpots += 1;
    }
    print(this.nrFreeSpots);
    this.layoutCode = layoutCode;
    this.name = name;
  }

}

/*Spot(1, 0),
    Spot(2, 2),
    Spot(3, 0),
    Spot(4, 1),
    Spot(5, 0),
    Spot(6, 0),
    Spot(7, 1),
    Spot(8, 0),
    Spot(9, 2),
    Spot(10, 0),
    Spot(11, 0),
    Spot(12, 1),
    Spot(13, 0),
    Spot(14, 0),
    Spot(15, 1),
    Spot(16, 0),*/