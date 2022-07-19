import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mineapp/constants/Constantcolors.dart';
import 'package:mineapp/screens/Landingpage/landingServices.dart';

import 'package:provider/provider.dart';

class landingUtils with ChangeNotifier {
  final picker = ImagePicker();
  final ConstantColors constantColors = ConstantColors();
  File userAvatar;
  File get getUserAvatar => userAvatar;
  String userAvatarUrl;
  String get getUserAvatarUrl => userAvatarUrl;

  Future pickUserAvatar(BuildContext context, ImageSource source) async {
    final pickedUserAvatar = await picker.getImage(source: source);

    // ignore: await_only_futures
    pickedUserAvatar == null
        ? print("Select Image")
        : userAvatar = File(pickedUserAvatar.path);

    print("pickedUserAvatar " + pickedUserAvatar.path);

    userAvatar != null
        ? Provider.of<LandingService>(context, listen: false)
            .showUserAvatar(context)
        : print("Image Upload error");

    notifyListeners();
  }

  Future selectAvatarOptionsSheet(BuildContext context) async {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        pickUserAvatar(context, ImageSource.gallery)
                            .whenComplete(() {
                          Navigator.pop(context);
                          Provider.of<LandingService>(context, listen: false)
                              .showUserAvatar(context);
                        });
                      },
                      color: constantColors.blueColor,
                      child: Text(
                        "Gallery",
                        style: TextStyle(
                            fontSize: 18,
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        pickUserAvatar(context, ImageSource.camera)
                            .whenComplete(() => Navigator.pop(context));
                        Provider.of<LandingService>(context, listen: false)
                            .showUserAvatar(context);
                      },
                      color: constantColors.blueColor,
                      child: Text(
                        "Camera",
                        style: TextStyle(
                            fontSize: 18,
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: constantColors.blueGreyColor),
          );
        });
  }
}
