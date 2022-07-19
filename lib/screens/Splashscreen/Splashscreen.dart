import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mineapp/constants/Constantcolors.dart';
import 'package:mineapp/screens/Homepage/Homepage.dart';
import 'package:mineapp/screens/Landingpage/landingpage.dart';
import 'package:mineapp/services/Authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  Splashscreen({Key key}) : super(key: key);

  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  ConstantColors constantColors = ConstantColors();

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 2), () => authcheck()
        /*() => Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft, child: landingpage()))*/
        );
  }

  authcheck() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String email = sharedPreferences.get("email");
    if (email == null) {
      Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft, child: landingpage()));
    } else {
      Provider.of<Authentication>(context, listen: false)
          .LogIntoAccount(context, sharedPreferences.getString("email"),
              sharedPreferences.getString("password"))
          .whenComplete(() {
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: Homepage(), type: PageTransitionType.rightToLeft));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: Center(
        child: RichText(
          text: TextSpan(
              text: "Mine",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 33,
                fontWeight: FontWeight.bold,
                color: constantColors.blueColor,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: "App",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 33,
                    fontWeight: FontWeight.bold,
                    color: constantColors.whiteColor,
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
