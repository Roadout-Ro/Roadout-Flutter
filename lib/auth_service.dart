import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roadout/welcome.dart';
import 'package:roadout/homescreen.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.idTokenChanges();

  Future<void> resetPassword({required String email}) async {
    email = email.replaceAll(" ", "");
    print(email);
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> signIn({required String email, required String password, required BuildContext context}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      print("Signed in");
      if(FirebaseAuth.instance.currentUser?.uid != null) {
          Navigator.of(context).push(_createRoute());
      }
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      print(e.message);
      if (e.message == 'The password is invalid or the user does not have a password.' || e.message == 'Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later.') {
        showDialog(
            context: context,
            builder: (BuildContext context) =>
                CupertinoAlertDialog(
                  title: new Text("Sign In Error"),
                  content: new Text(e.message!),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      textStyle: TextStyle(
                          color: Color.fromRGBO(255, 158, 25, 1.0)),
                      isDefaultAction: true,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Try Again'),
                    ),
                    CupertinoDialogAction(
                      textStyle: TextStyle(
                          color: Color.fromRGBO(143, 102, 13, 1.0)),
                      isDefaultAction: true,
                      onPressed: () {
                        resetPassword(email: signInEmailController.text);
                        Navigator.pop(context);
                      },
                      child: Text('Reset password'),
                    )
                  ],
                )
        );
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) =>
                CupertinoAlertDialog(
                  title: new Text("Sign In Error"),
                  content: new Text(e.message!),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      textStyle: TextStyle(
                          color: Color.fromRGBO(255, 158, 25, 1.0)),
                      isDefaultAction: true,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Ok'),
                    )
                  ],
                )
        );
      }
      return e.message!;
    }
  }

  Future<String> signUp({required String email, required String password, required BuildContext context, required String name}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      userSetup(name: name);
      if(FirebaseAuth.instance.currentUser?.uid != null) {
        Navigator.of(context).push(_createRoute());
      }
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      print(e.message);
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: new Text("Sign Up Error"),
            content: new Text(e.message!),
            actions: <Widget>[
              CupertinoDialogAction(
                textStyle: TextStyle(color: Color.fromRGBO(143, 102, 13, 1.0)),
                isDefaultAction: true,
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text('Ok'),
              )
            ],
          )
      );
      return e.message!;
    }
  }

}

Future<void> userSetup({required String name}) async {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;
  if (auth.currentUser == null) {
    print("here");
    return;
  }
  String uid = auth.currentUser!.uid.toString();
  users.add({'name': name, 'uid': uid});
  return;
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => MainScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
