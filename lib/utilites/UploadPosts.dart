import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:mineapp/constants/Constantcolors.dart';

import 'package:mineapp/services/Authentication.dart';
import 'package:mineapp/services/FirebaseOperations.dart';
import 'package:provider/provider.dart';

class UploadPosts with ChangeNotifier {
  final ConstantColors constantColors = ConstantColors();
  File uploadPostImage;
  File get getUploadPostImage => uploadPostImage;
  String uploadPostImageUrl;
  String get getUploadPostImageUrl => uploadPostImageUrl;
  final ImagePicker picker = ImagePicker();
  UploadTask imagePostUploadTask;
  TextEditingController captionController = TextEditingController();

  Future pickUploadPostImage(BuildContext context, ImageSource source) async {
    final uploadPostImageVal = await picker.getImage(source: source);

    // ignore: await_only_futures
    uploadPostImageVal == null
        ? print("Select Image")
        : uploadPostImage = File(uploadPostImageVal.path);

    print("pickedUserAvatar " + uploadPostImageVal.path);

    uploadPostImage != null
        ? showPostImage(context)
        : print("Image Upload error");

    notifyListeners();
  }

  Future uploadPostImageToFirebase() async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child("posts/${uploadPostImage.path}/${TimeOfDay.now()}");
    imagePostUploadTask = imageReference.putFile(uploadPostImage);
    await imagePostUploadTask.whenComplete(() async {
      print("Post Image Uploaded");
      await imageReference.getDownloadURL().then((imgUrl) {
        uploadPostImageUrl = imgUrl;
        print("upload post url -- " + uploadPostImageUrl);
        notifyListeners();
      });
    });
    notifyListeners();
  }

  selectPostImageType(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.11,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.circular(13),
            ),
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
                        pickUploadPostImage(context, ImageSource.gallery);
                      },
                      color: constantColors.blueColor,
                      child: Text(
                        "Gallery",
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        pickUploadPostImage(context, ImageSource.camera);
                      },
                      color: constantColors.blueColor,
                      child: Text(
                        "Camera",
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  showPostImage(BuildContext context) {
    Navigator.pop(context);
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.55,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Column(children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 150),
                child: Divider(
                  thickness: 4,
                  color: constantColors.whiteColor,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 12.0, right: 8, left: 8),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width * 8,
                    child: Image.file(
                      uploadPostImage,
                      fit: BoxFit.contain,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                        selectPostImageType(context);
                      },
                      child: Text(
                        "Reselect",
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: constantColors.whiteColor),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                        editPostSheet(context);
                      },
                      color: constantColors.blueColor,
                      child: Text(
                        "Confirm",
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ]),
          );
        });
  }

  editPostSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.57,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 150),
                    child: Divider(
                      thickness: 4,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.image_aspect_ratio,
                                    color: constantColors.greenColor,
                                  )),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.fit_screen_outlined,
                                    color: constantColors.yellowColor,
                                  ))
                            ],
                          ),
                        ),
                        Container(
                          height:
                              250, //MediaQuery.of(context).size.height * 0.4,
                          width: 280,
                          //height: MediaQuery.of(context).size.height * 0.4,
                          // width: MediaQuery.of(context).size.width * 65,
                          child: Image.file(
                            uploadPostImage,
                            fit: BoxFit.contain,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset("assets/icons/sunflower.png"),
                        ),
                        Container(
                          height: 110,
                          width: 5.0,
                          color: constantColors.blueColor,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 8.0,
                          ),
                          child: Container(
                            height: 120,
                            width: 330,
                            child: TextField(
                              controller: captionController,
                              maxLines: 5,
                              textCapitalization: TextCapitalization.words,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(100)
                              ],
                              maxLength: 100,
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                  hintText: "Add a Caption....",
                                  hintStyle: TextStyle(
                                      color: constantColors.whiteColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Center(
                        child: CircularProgressIndicator(),
                      );
                      uploadPostImageToFirebase().whenComplete(() async {
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .uploadPostData(
                                {
                              "caption": captionController.text,
                              "userName": Provider.of<FirebaseOperations>(
                                      context,
                                      listen: false)
                                  .initUserName,
                              "userEmail": Provider.of<FirebaseOperations>(
                                      context,
                                      listen: false)
                                  .initUserEmail,
                              "userUid": Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserUid,
                              "userImage": Provider.of<FirebaseOperations>(
                                      context,
                                      listen: false)
                                  .initUserImage,
                              "time": Timestamp.now(),
                              "Postdata": uploadPostImageUrl
                            },
                                {
                              "userUid": Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserUid,
                              "Postdata": uploadPostImageUrl,
                              "time": Timestamp.now(),
                            },
                                Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid) /*.whenComplete(() async {
                          return FirebaseFirestore.instance
                              .collection("users")
                              .doc(
                                Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid,
                              )
                              .collection("posts")
                              .doc("")
                              .set({
                            "caption": captionController.text,
                            "userName": Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .initUserName,
                            "userEmail": Provider.of<FirebaseOperations>(
                                    context,
                                    listen: false)
                                .initUserEmail,
                            "userUid": Provider.of<Authentication>(context,
                                    listen: false)
                                .getUserUid,
                            "userImage": Provider.of<FirebaseOperations>(
                                    context,
                                    listen: false)
                                .initUserImage,
                            "time": Timestamp.now(),
                            "Postdata": uploadPostImageUrl
                          });
                        }).*/
                            .whenComplete(() {
                          captionController.clear();
                          Navigator.pop(context);
                          print("post uploaded... . .. . .");
                        });
                      });
                    },
                    child: Text(
                      "Share",
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    color: constantColors.blueColor,
                  )
                ],
              ),
              decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        });
  }
}
