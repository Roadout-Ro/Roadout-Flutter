import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roadout/auth_service.dart';
import 'package:roadout/spots_&_locations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final currentUser = FirebaseAuth.instance.currentUser;

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');

  Future<String> getUserData() async {
    String firestoreName = "Name";
    await usersCollection.doc(uid).get().then((value) {
      //print(value['name'].toString());
      firestoreName = value['name'].toString();
    });
    username = firestoreName;
    _saveUserName(username);
    return firestoreName;
    ;
  }

  Future updateUserData(String newName) async{
    return await usersCollection.doc(uid).set({
      'name':newName,
      'uid': uid,
    });
  }

  Future updateUserPsw(String newPsw, String oldPsw, BuildContext context) async {
    try{
      AuthCredential credential = EmailAuthProvider.credential(email:currentUser!.email.toString(), password: oldPsw);
      await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential);
      await currentUser!.updatePassword(newPsw);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.all(40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: Text('Success', style: GoogleFonts.karla(
                fontSize: 20.0, fontWeight: FontWeight.w600)),
            content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget> [
                    Text('Your password was successfully changed!', style: GoogleFonts.karla(
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
                          disabledColor: Color.fromRGBO(220, 170, 57, 1.0),
                          color: Color.fromRGBO(220, 170, 57, 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(13.0)),
                        )
                    ),
                  ],
                )
            ),
          );
        },
      );
    } catch (e){
      print(e);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.all(40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: Text('Failure', style: GoogleFonts.karla(
                fontSize: 20.0, fontWeight: FontWeight.w600)),
            content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget> [
                    Text('You entered the wrong old password', style: GoogleFonts.karla(
                        fontSize: 17.0, fontWeight: FontWeight.w500)),
                    Container(
                        padding: EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
                        width: MediaQuery.of(context).size.width-100,
                        height: 60,
                        child: CupertinoButton(
                          padding: EdgeInsets.all(0.0),
                          child: Text('Try Again', style: GoogleFonts.karla(fontSize: 18.0, fontWeight: FontWeight.w600),),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          disabledColor: Color.fromRGBO(220, 170, 57, 1.0),
                          color: Color.fromRGBO(220, 170, 57, 1.0),
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
  }

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('Users');

  Future deleteUser() {
    return userCollection.doc(uid).delete();
  }

}


_saveUserName(String name) async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'user_name';
  final value = name;
  prefs.setString(key, name);
  print('Saved $value');
}

List<ParkingSpot> sectionASpots = [
  ParkingSpot(1, 0),
  ParkingSpot(2, 2),
  ParkingSpot(3, 0),
  ParkingSpot(4, 1),
  ParkingSpot(5, 0),
  ParkingSpot(6, 0),
  ParkingSpot(7, 1),
  ParkingSpot(8, 0),
  ParkingSpot(9, 2),
];

List<ParkingSpot> sectionBSpots = [
  ParkingSpot(1, 0),
  ParkingSpot(2, 2),
  ParkingSpot(3, 0),
  ParkingSpot(4, 1),
  ParkingSpot(5, 0),
  ParkingSpot(6, 0),
  ParkingSpot(7, 1),
  ParkingSpot(8, 0),
  ParkingSpot(9, 2),
  ParkingSpot(10, 0),
  ParkingSpot(11, 0),
  ParkingSpot(12, 1),
  ParkingSpot(13, 0),
  ParkingSpot(14, 0),
  ParkingSpot(15, 1),
  ParkingSpot(16, 0)
];

List<ParkingSpot> sectionCSpots = [
  ParkingSpot(1, 0),
  ParkingSpot(2, 2),
  ParkingSpot(3, 0),
  ParkingSpot(4, 1),
  ParkingSpot(5, 0),
  ParkingSpot(6, 0),
  ParkingSpot(7, 1),
  ParkingSpot(8, 0),
  ParkingSpot(9, 2),
  ParkingSpot(10, 0),
  ParkingSpot(11, 0),
  ParkingSpot(12, 1),
  ParkingSpot(13, 0),
  ParkingSpot(14, 0),
  ParkingSpot(15, 1),
  ParkingSpot(16, 0),
  ParkingSpot(17, 1),
  ParkingSpot(18, 0)
];

List<ParkingSpot> sectionDSpots = [
  ParkingSpot(1, 0),
  ParkingSpot(2, 2),
  ParkingSpot(3, 0),
  ParkingSpot(4, 1),
  ParkingSpot(5, 0),
  ParkingSpot(6, 0),
  ParkingSpot(7, 1),
  ParkingSpot(8, 0),
  ParkingSpot(9, 2),
  ParkingSpot(10, 0),
  ParkingSpot(11, 0),
  ParkingSpot(12, 1),
  ParkingSpot(13, 0),
  ParkingSpot(14, 0)
];

List<ParkingSpot> sectionESpots = [
  ParkingSpot(1, 0),
  ParkingSpot(2, 2),
  ParkingSpot(3, 0),
  ParkingSpot(4, 1),
  ParkingSpot(5, 0),
  ParkingSpot(6, 0),
  ParkingSpot(7, 1),
  ParkingSpot(8, 0),
  ParkingSpot(9, 2),
  ParkingSpot(10, 0),
  ParkingSpot(11, 0),
  ParkingSpot(12, 1),
  ParkingSpot(13, 0),
  ParkingSpot(14, 0),
  ParkingSpot(15, 1),
  ParkingSpot(16, 0),
  ParkingSpot(17, 0),
  ParkingSpot(18, 0),
  ParkingSpot(19, 1),
  ParkingSpot(20, 0)
];

List<ParkingSpot> sectionFSpots = [
  ParkingSpot(1, 0),
  ParkingSpot(2, 2),
  ParkingSpot(3, 0),
  ParkingSpot(4, 1),
  ParkingSpot(5, 0),
  ParkingSpot(6, 0),
  ParkingSpot(7, 1),
  ParkingSpot(8, 0),
  ParkingSpot(9, 2),
  ParkingSpot(10, 0)
];

List<ParkingSpot> sectionGSpots = [
  ParkingSpot(1, 0),
  ParkingSpot(2, 2),
  ParkingSpot(3, 0),
  ParkingSpot(4, 1),
  ParkingSpot(5, 0),
  ParkingSpot(6, 0),
  ParkingSpot(7, 1),
  ParkingSpot(8, 0),
  ParkingSpot(9, 2),
  ParkingSpot(10, 0),
  ParkingSpot(11, 0),
  ParkingSpot(12, 1)
];

List<ParkingSection> locationSections = [
  ParkingSection([4, 5], sectionASpots, 'A'),
  ParkingSection([8, 8], sectionBSpots, 'B'),
  ParkingSection([6, 6, 6], sectionCSpots, 'C'),
  ParkingSection([7, 7], sectionDSpots, 'D'),
  ParkingSection([10, 10], sectionESpots, 'E'),
  ParkingSection([5, 5], sectionFSpots, 'F'),
  ParkingSection([6, 6], sectionGSpots, 'G')
];