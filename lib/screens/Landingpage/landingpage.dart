import 'package:flutter/material.dart';
import 'package:mineapp/constants/Constantcolors.dart';
import 'package:mineapp/screens/Landingpage/landinghelper.dart';
import 'package:provider/provider.dart';

class landingpage extends StatelessWidget {
  final ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.lightColor,
      body: Stack(
        children: [
          bodycolor(),
          Provider.of<LandingHelpers>(context, listen: false)
              .bodyimage(context),
          Provider.of<LandingHelpers>(context, listen: false)
              .taglineText(context),
          Provider.of<LandingHelpers>(context, listen: false)
              .mainButton(context),
          Provider.of<LandingHelpers>(context, listen: false)
              .privacyText(context)
        ],
      ),
    );
  }

  bodycolor() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.5, 0.9],
            colors: [constantColors.darkColor, constantColors.blueGreyColor]),
      ),
    );
  }
}
