import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:roadout/auth_service.dart';
import 'package:roadout/spots_&_locations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  String uid = FirebaseAuth.instance.currentUser!.uid;

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

String layout = '''
{

}
''';