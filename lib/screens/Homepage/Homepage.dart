import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mineapp/constants/Constantcolors.dart';
import 'package:mineapp/screens/Chatroom/chatroom.dart';
import 'package:mineapp/screens/Feed/Feed.dart';
import 'package:mineapp/screens/Homepage/HomePageHelpers.dart';

import 'package:mineapp/screens/Profile/profile.dart';
import 'package:mineapp/services/Authentication.dart';
import 'package:mineapp/services/FirebaseOperations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  ConstantColors constantColors = ConstantColors();
  PageController homePageController = PageController();
  int pageindex = 0;

  @override
  void initState() {
    Provider.of<FirebaseOperations>(context, listen: false)
        .initUserData(context);
    super.initState();

    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<FirebaseOperations>(context).flag) {
      return Scaffold(
          backgroundColor: constantColors.darkColor,
          body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: PageView(
        controller: homePageController,
        children: [Feed(), Chatroom(), Profile()],
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (page) {
          setState(() {
            pageindex = page;
          });
        },
      ),
      bottomNavigationBar: Provider.of<HomePageHelpers>(context, listen: false)
          .bottomNavBar(context, pageindex, homePageController),
    );
  }
}
