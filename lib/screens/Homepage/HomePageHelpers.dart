import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mineapp/constants/Constantcolors.dart';
import 'package:mineapp/services/FirebaseOperations.dart';
import 'package:provider/provider.dart';

class HomePageHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget bottomNavBar(
      BuildContext context, int index, PageController pageController) {
    // print(" . . . . .. " +   Provider.of<FirebaseOperations>(context, listen: false).initUserImage);
    return CustomNavigationBar(
        currentIndex: index,
        bubbleCurve: Curves.bounceIn,
        scaleCurve: Curves.decelerate,
        selectedColor: constantColors.blueColor,
        unSelectedColor: constantColors.whiteColor,
        strokeColor: constantColors.blueColor,
        scaleFactor: 0.5,
        iconSize: 30,
        onTap: (value) {
          index = value;
          pageController.jumpToPage(value);
        },
        backgroundColor: Colors.black38,
        items: [
          CustomNavigationBarItem(icon: Icon(EvaIcons.home)),
          CustomNavigationBarItem(icon: Icon(Icons.message_rounded)),
          CustomNavigationBarItem(
              icon: CircleAvatar(
            backgroundColor: constantColors.blueGreyColor,
            backgroundImage: NetworkImage(
                Provider.of<FirebaseOperations>(context).initUserImage),
          ))
        ]);
  }
}
