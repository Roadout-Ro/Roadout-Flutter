import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  Future updateUserPsw(String newPsw, String oldPsw, BuildContext context) async{
    try{
      AuthCredential credential = EmailAuthProvider.credential(email:currentUser!.email.toString(), password: oldPsw);
      await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential);
      await currentUser!.updatePassword(newPsw);
      showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
              title: Text("Your password was successfully changed!"),
              actions: <Widget>[
                CupertinoDialogAction(
                    textStyle: TextStyle(
                        color: Color.fromRGBO(146, 82, 24, 1.0)),
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Ok")),
              ]);
        },
      );
    } catch (e){
      print(e);
      showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
              title: Text("Old Password Error"),
              content: Text(
                  "You entered the wrong old password"),
              actions: <Widget>[
                CupertinoDialogAction(
                    textStyle: TextStyle(
                        color: Color.fromRGBO(146, 82, 24, 1.0)),
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Try Again")),
              ]);
        },
      );
    }
  }

}


_saveUserName(String name) async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'user_name';
  final value = name;
  prefs.setString(key, name);
  print('Saved $value');
}

List<Spot> spots = [
  Spot(1, 0),
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
  Spot(16, 0)
];
