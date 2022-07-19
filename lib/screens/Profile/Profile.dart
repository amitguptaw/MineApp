import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mineapp/constants/Constantcolors.dart';
import 'package:mineapp/screens/Landingpage/landingpage.dart';
import 'package:mineapp/screens/Profile/ProfileHelpers.dart';
import 'package:mineapp/services/Authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            EvaIcons.settings2Outline,
            color: constantColors.lightBlueColor,
          ),
          onPressed: null,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Provider.of<ProfileHelpers>(context, listen: false)
                    .logoutDailog(context);
              },
              icon: Icon(
                EvaIcons.logOutOutline,
                color: constantColors.redColor,
              ))
        ],
        backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
        title: RichText(
          text: TextSpan(
              text: "My",
              style: TextStyle(
                color: constantColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: "Profile",
                    style: TextStyle(
                        color: constantColors.blueColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold))
              ]),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
                maxHeight: double.infinity),
            // height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(Provider.of<Authentication>(context).getUserUid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return new Column(
                    children: [
                      Provider.of<ProfileHelpers>(context, listen: false)
                          .headerProfile(context, snapshot.data),
                      Provider.of<ProfileHelpers>(context, listen: false)
                          .divider(context),
                      Provider.of<ProfileHelpers>(context, listen: false)
                          .middileprofile(context, snapshot.data),
                      Provider.of<ProfileHelpers>(context, listen: false)
                          .footerProfile(context, snapshot.data.id),
                    ],
                  );
                }
              },
            ),
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor.withOpacity(0.6),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
