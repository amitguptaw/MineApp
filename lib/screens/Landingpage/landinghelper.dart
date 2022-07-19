import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mineapp/constants/Constantcolors.dart';
import 'package:mineapp/screens/Homepage/Homepage.dart';
import 'package:mineapp/screens/Landingpage/landingServices.dart';
import 'package:mineapp/screens/Landingpage/landingUtils.dart';
import 'package:mineapp/services/Authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LandingHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget bodyimage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/login.png"))),
    );
  }

  Widget taglineText(BuildContext context) {
    return Positioned(
        top: 450,
        left: 30,
        child: Container(
          constraints: BoxConstraints(maxWidth: 200),
          child: RichText(
            text: TextSpan(
                text: "Say, ",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: constantColors.blueColor,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "World ",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 33,
                      fontWeight: FontWeight.bold,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  TextSpan(
                    text: "is ",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 33,
                      fontWeight: FontWeight.bold,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  TextSpan(
                    text: "Mine",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: constantColors.blueColor,
                    ),
                  ),
                  TextSpan(
                    text: "!",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: constantColors.blueColor,
                    ),
                  ),
                ]),
          ),
        ));
  }

  Widget mainButton(BuildContext context) {
    return Positioned(
        top: 630,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  emailAuthSheet(context);
                },
                child: Container(
                  height: 40.0,
                  width: 80.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: constantColors.yellowColor),
                      borderRadius: BorderRadius.circular(20)),
                  child: Icon(EvaIcons.emailOutline,
                      color: constantColors.yellowColor),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Provider.of<Authentication>(context, listen: false)
                      .signInWithGoogle()
                      .whenComplete(() => Navigator.pushReplacement(
                          context,
                          PageTransition(
                              child: Homepage(),
                              type: PageTransitionType.rightToLeft)));
                },
                child: Container(
                  height: 40.0,
                  width: 80.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: constantColors.redColor),
                      borderRadius: BorderRadius.circular(20)),
                  child: Icon(EvaIcons.google, color: constantColors.redColor),
                ),
              ),
              GestureDetector(
                child: Container(
                  height: 40.0,
                  width: 80.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: constantColors.blueColor),
                      borderRadius: BorderRadius.circular(20)),
                  child:
                      Icon(EvaIcons.facebook, color: constantColors.blueColor),
                ),
              ),
            ],
          ),
        ));
  }

  Widget privacyText(BuildContext context) {
    return Positioned(
        top: 720,
        right: 20,
        left: 20,
        child: Column(
          children: [
            Container(
              child: Text(
                "By consulting you agree MineApp's",
                style: TextStyle(color: constantColors.greyColor, fontSize: 12),
              ),
            ),
            Container(
              child: Text(
                "Terms & Conditions",
                style: TextStyle(color: constantColors.greyColor, fontSize: 12),
              ),
            )
          ],
        ));
  }

  emailAuthSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150),
                child: Divider(
                  thickness: 4.0,
                  color: constantColors.whiteColor,
                ),
              ),
              Provider.of<LandingService>(context, listen: false)
                  .passwordLessSignIn(context),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    onPressed: () => {
                      Provider.of<LandingService>(context, listen: false)
                          .logInSheet(context)
                    },
                    color: constantColors.blueColor,
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () => {
                      Provider.of<landingUtils>(context, listen: false)
                          .selectAvatarOptionsSheet(context)
                    },
                    color: constantColors.redColor,
                    child: Text(
                      "Register",
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(13.0),
                  topRight: Radius.circular(13.0))),
        );
      },
    );
  }
}
