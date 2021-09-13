import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:roadout/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
class VerifyEmail extends StatefulWidget {


  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final auth = FirebaseAuth.instance;
  late User user;
  late Timer timer;
  late String email;

  @override
  void initState(){
    user = auth.currentUser!;
    email = user.email!;
    user.sendEmailVerification();
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      checkEmail();
    });
    super.initState();
  }


  @override
  void dispose(){
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                width: 264,
                child: Align(
                  child: Text(
                    'Welcome to Roadout',
                    style: GoogleFonts.karla(
                        fontSize: 30.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                padding: EdgeInsets.only(top: 50.0, bottom: 40.0),
              ),
              Text("Verify your email",
                style: GoogleFonts.karla(
                    fontSize: 24.0, fontWeight: FontWeight.w700,color: Color.fromRGBO(103, 72, 5, 1.0)),
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Container(
                width: 353,
                height: 164,
                decoration: BoxDecoration(
                    color:
                    Color.fromRGBO(128, 128, 129, 0.3),
                    borderRadius:
                    BorderRadius.all(Radius.circular(26)),
                    ),
                child: Column(
                  children: <Widget> [
                    Padding(padding: EdgeInsets.only(top: 30.0),),
                    Icon(CupertinoIcons.tray, size: 50, color: Color.fromRGBO(
                        136, 126, 115, 1.0),),
                    Padding(padding: EdgeInsets.only(top: 10.0),),
                    Center(
                      child: Text("Go check your inbox and verify your email before continuing. We sent an email to $email.",
                        style: GoogleFonts.karla(
                            fontSize: 16.0, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Center(
                child: Text("Stay tuned in the meantime, you are onto something :)",
                  style: GoogleFonts.karla(
                      fontSize: 16.0, fontWeight: FontWeight.w500,color: Color.fromRGBO(136, 126, 115, 1.0)),
                  textAlign: TextAlign.center,
                ),
              ),
              Spacer(),
              Container(
                child: Row(
                    children: <Widget>[
                      Container(
                        width: 42.0,
                        height: 42.0,
                        child: Image.asset('assets/Logo.png'),
                        padding: EdgeInsets.only(right: 10.0),
                      ),
                      Text('Terms of Use & Privacy Policy',
                          style: GoogleFonts.karla(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center)
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center),
              )
            ],
          ),
        )
      )
    );
  }


  Future<void> checkEmail() async{
    user = auth.currentUser!;
    await user.reload();
    if(user.emailVerified){
      timer.cancel();
      Navigator.of(context).push(_createRoute());
    }
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
}
