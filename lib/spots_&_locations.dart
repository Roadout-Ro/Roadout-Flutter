import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'database_service.dart';

class ParkingSpot {
  int spotNr = 0;
  int spotState = 0;
  String spotId = 'Cluj.OldTown.A.5'; //example

  ParkingSpot(int spotNr, int spotState) {
    this.spotNr = spotNr;
    this.spotState = spotState;
  }
}

class ParkingSection {
  List<int> sectionRows = []; //count is how many rows, nr of value is spots in row
  List<ParkingSpot> sectionSpots = [];
  int sectionFreeSpots = 0;
  int sectionNrSpots = 0;
  String sectionLetter = 'A';
  String sectionId = 'Cluj.OldTown.A'; //example

  ParkingSection(List<int> sectionRows, List<ParkingSpot> sectionSpots, String sectionLetter) {
    this.sectionRows = sectionRows;
    this.sectionSpots = sectionSpots;
    this.sectionLetter = sectionLetter;
    for (ParkingSpot spot in sectionSpots) {
      this.sectionNrSpots += 1;
      if (spot.spotState == 0)
        this.sectionFreeSpots += 1;
    }
  }
}

class ParkingLocation {
  List<ParkingSection> sections = [];
  LatLng coords = LatLng(46.768728, 23.592564);
  int nrSpots = 0;
  int nrFreeSpots = 0;
  String name = "";
  String id = 'Cluj.OldTown'; //example
  List<String> keywords = []; //for search

  ParkingLocation(LatLng coords, String name, List<ParkingSection> sections) {
    this.coords = coords;
    for (ParkingSection section in sections) {
        this.nrSpots += section.sectionNrSpots;
        this.nrFreeSpots += section.sectionFreeSpots;
    }
    print(this.nrFreeSpots);
    this.name = name;
    this.sections = sections;
  }

}

List<ParkingLocation> parkingLocations = [
  ParkingLocation(LatLng(46.782075, 23.613858), 'Marasti', locationSections1),
  ParkingLocation(LatLng(46.77425, 23.59108), 'Mihai Viteazu', locationSections2),
  ParkingLocation(LatLng(46.774547, 23.603745), '21 Decembrie', locationSections3)
];

List<Widget> generateSections(List<ParkingSection> sections) {
  List<Widget> children = [];
  ParkingSection sec;
  for (sec in sections) {
    children.add(Text(sec.sectionLetter));
  }
  return children;
}