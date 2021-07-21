import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:roadout/auth_service.dart';

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
    return firestoreName;;
  }

}