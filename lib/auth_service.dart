import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roadout/welcome.dart';
import 'package:roadout/homescreen.dart';

import 'database_service.dart';

String username = "User Name";

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.idTokenChanges();

  Future<void> resetPassword({required String email}) async {
    email = email.replaceAll(" ", "");
    print(email);
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut({required BuildContext context}) async {
    await _firebaseAuth.signOut();
    Navigator.of(context).push(_createRouteAfterSignOut());
  }

  Future<String> signIn({required String email, required String password, required BuildContext context}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      print("Signed in");
      if(FirebaseAuth.instance.currentUser?.uid != null) {
          Navigator.of(context).push(_createRoute());
      }
      username = await DatabaseService().getUserData();
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      print(e.message);
      if (e.message == 'The password is invalid or the user does not have a password.' || e.message == 'Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later.') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              insetPadding: EdgeInsets.all(40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              title: Text('Sign In Error', style: GoogleFonts.karla(
                  fontSize: 20.0, fontWeight: FontWeight.w600)),
              content: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget> [
                      Text(e.message!, style: GoogleFonts.karla(
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
                            disabledColor: Color.fromRGBO(214, 109, 0, 1.0),
                            color: Color.fromRGBO(214, 109, 0, 1.0),
                            borderRadius: BorderRadius.all(Radius.circular(13.0)),
                          )
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
                          width: 250,
                          height: 40,
                          child: CupertinoButton(
                            padding: EdgeInsets.all(0.0),
                            child: Text('Reset password', style: GoogleFonts.karla(fontSize: 18.0, fontWeight: FontWeight.w600, color: Color.fromRGBO(214, 109, 0, 1.0)),),
                            onPressed: () {
                              resetPassword(email: signInEmailController.text);
                              Navigator.pop(context);
                            },
                            borderRadius: BorderRadius.all(Radius.circular(13.0)),
                          )
                      )
                    ],
                  )
              ),
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              insetPadding: EdgeInsets.all(40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              title: Text('Sign In Error', style: GoogleFonts.karla(
                  fontSize: 20.0, fontWeight: FontWeight.w600)),
              content: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget> [
                      Text(e.message!, style: GoogleFonts.karla(
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
      username = await DatabaseService().getUserData();
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      print(e.message);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: EdgeInsets.all(40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: Text('Sign Up Error', style: GoogleFonts.karla(
                fontSize: 20.0, fontWeight: FontWeight.w600)),
            content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget> [
                    Text(e.message!, style: GoogleFonts.karla(
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
  users.doc(uid).set({'name': name, 'uid': uid,});
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

Route _createRouteAfterSignOut() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => WelcomeScreen(),
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