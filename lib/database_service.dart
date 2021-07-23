import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:roadout/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {

  String uid = FirebaseAuth.instance.currentUser!.uid;

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users');

   Future<String> getUserData() async {
    String firestoreName = "Name";
    await usersCollection.doc(uid).get().then((value) {
      print(value['name'].toString());
      firestoreName = value['name'].toString();
    });
    username = firestoreName;
    _saveUserName(username);
    return firestoreName;;
  }

}

_saveUserName(String name) async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'user_name';
  final value = name;
  prefs.setString(key, name);
  print('Saved $value');
}