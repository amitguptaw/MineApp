import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mineapp/constants/Constantcolors.dart';
import 'package:mineapp/screens/AltProfile/altProfileHelper.dart';
import 'package:provider/provider.dart';

class AltProfile extends StatelessWidget {
  final String userUid;
  AltProfile({@required this.userUid});
  ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          Provider.of<AltProfileHelper>(context, listen: false).appBar(context),
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
              maxHeight: double.infinity),
          // height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(userUid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                  children: [
                    Provider.of<AltProfileHelper>(context, listen: false)
                        .headerProfile(context, snapshot.data, userUid),
                    Provider.of<AltProfileHelper>(context, listen: false)
                        .divider(context),
                    Provider.of<AltProfileHelper>(context, listen: false)
                        .middileprofile(context, snapshot.data),
                    Provider.of<AltProfileHelper>(context, listen: false)
                        .footerProfile(context, userUid),
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
    );
  }
}
