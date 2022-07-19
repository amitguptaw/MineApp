import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:mineapp/constants/Constantcolors.dart';
import 'package:mineapp/screens/AltProfile/AltProfile.dart';
import 'package:mineapp/services/Authentication.dart';
import 'package:mineapp/utilites/PostOptions.dart';
import 'package:mineapp/utilites/UploadPosts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class FeedHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
      actions: [
        IconButton(
          onPressed: () {
            Provider.of<UploadPosts>(context, listen: false)
                .selectPostImageType(context);
          },
          icon: Icon(
            Icons.camera_enhance_rounded,
            color: constantColors.greenColor,
          ),
        )
      ],
      title: RichText(
        text: TextSpan(
            text: "Mine",
            style: TextStyle(
              color: constantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            children: <TextSpan>[
              TextSpan(
                  text: "Feeds",
                  style: TextStyle(
                      color: constantColors.blueColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold))
            ]),
      ),
    );
  }

  Widget feedBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            top: 8.0, bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection("posts")
                .orderBy("time", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                return loadPost(context, snapshot);
              }
            },
          ),
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.darkColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.0),
              topRight: Radius.circular(18.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget loadPost(BuildContext context,
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    return new ListView(
      children: snapshot.data.docs
          .map((DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
        Provider.of<PostFunctions>(context, listen: false)
            .showTime(documentSnapshot.data()["time"]);
        return Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: constantColors.blueGreyColor.withOpacity(0.2),
            ),

            height: MediaQuery.of(context).size.width *
                1.35, // MediaQuery.of(context).size.height * 0.68,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (documentSnapshot.data()["userUid"] !=
                              Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserUid) {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: AltProfile(
                                        userUid:
                                            documentSnapshot.data()["userUid"]),
                                    type: PageTransitionType.rightToLeft));
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: constantColors.blueGreyColor,
                          radius: 20.0,
                          backgroundImage: NetworkImage(
                              documentSnapshot.data()["userImage"]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (documentSnapshot.data()["userUid"] !=
                                      Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserUid) {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: AltProfile(
                                                userUid: documentSnapshot
                                                    .data()["userUid"]),
                                            type: PageTransitionType
                                                .rightToLeft));
                                  }
                                },
                                child: Container(
                                  child: Text(
                                    documentSnapshot.data()["userName"],
                                    style: TextStyle(
                                        color: constantColors.greenColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                child: RichText(
                                  text: TextSpan(
                                      text: documentSnapshot.data()["caption"],
                                      style: TextStyle(
                                          color: constantColors.blueColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: Provider.of<PostFunctions>(
                                                  context,
                                                  listen: false)
                                              .getImageTimePosted,
                                          style: TextStyle(
                                            color: constantColors.lightColor
                                                .withOpacity(0.8),
                                          ),
                                        )
                                      ]),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    color: constantColors.whiteColor.withOpacity(0.9),
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    child: FittedBox(
                      child: Image.network(
                        documentSnapshot.data()["Postdata"],
                        scale: 2,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 20), //Like button
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 75,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            StreamBuilder<
                                    DocumentSnapshot<Map<String, dynamic>>>(
                                stream: FirebaseFirestore.instance
                                    .collection("posts")
                                    .doc(documentSnapshot.id)
                                    .collection("likes")
                                    .doc(Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserUid)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    if (snapshot.data.exists) {
                                      return GestureDetector(
                                        onTap: () {
                                          Provider.of<PostFunctions>(context,
                                                  listen: false)
                                              .removeLike(
                                                  documentSnapshot.id,
                                                  Provider.of<Authentication>(
                                                          context,
                                                          listen: false)
                                                      .getUserUid);
                                        },
                                        child: Icon(
                                          FontAwesomeIcons.solidHeart,
                                          color: constantColors.redColor,
                                          size: 22,
                                        ),
                                      );
                                    } else {
                                      return GestureDetector(
                                        onTap: () {
                                          Provider.of<PostFunctions>(context,
                                                  listen: false)
                                              .addLike(
                                                  context,
                                                  documentSnapshot.id,
                                                  Provider.of<Authentication>(
                                                          context,
                                                          listen: false)
                                                      .getUserUid)
                                              .whenComplete(() {
                                            print("liked post");
                                          });
                                        },
                                        child: Icon(
                                          FontAwesomeIcons.heart,
                                          color: constantColors.redColor,
                                          size: 22,
                                        ),
                                      );
                                    }
                                  }
                                }),
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                stream: FirebaseFirestore.instance
                                    .collection("posts")
                                    .doc(documentSnapshot.id)
                                    .collection("likes")
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        "-",
                                        style: TextStyle(
                                            color: constantColors.whiteColor
                                                .withOpacity(0.6),
                                            fontSize: 18),
                                      ),
                                    );
                                  } else {
                                    return GestureDetector(
                                      onTap: () {
                                        Provider.of<PostFunctions>(context,
                                                listen: false)
                                            .showLikes(
                                                context, documentSnapshot.id);
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          snapshot.data.docs.length.toString(),
                                          style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                    );
                                  }
                                })
                          ],
                        ),
                      ),
                      Container(
                        width: 75,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Comment button
                            GestureDetector(
                              onTap: () {
                                Provider.of<PostFunctions>(context,
                                        listen: false)
                                    .showCommentSheet(context, documentSnapshot,
                                        documentSnapshot.id);
                              },
                              child: Icon(
                                FontAwesomeIcons.comment,
                                color: constantColors.yellowColor,
                                size: 22,
                              ),
                            ),
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                stream: FirebaseFirestore.instance
                                    .collection("posts")
                                    .doc(documentSnapshot.id)
                                    .collection("comments")
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        "-",
                                        style: TextStyle(
                                            color: constantColors.whiteColor
                                                .withOpacity(0.6),
                                            fontSize: 18),
                                      ),
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        snapshot.data.docs.length.toString(),
                                        style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    );
                                  }
                                })
                          ],
                        ),
                      ),
                      Container(
                        width: 60,
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.start, //share button
                          children: [
                            GestureDetector(
                              child: Icon(
                                FontAwesomeIcons.share,
                                color: constantColors.blueColor,
                                size: 22,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "",
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      Provider.of<Authentication>(context, listen: false)
                                  .getUserUid ==
                              documentSnapshot.data()["userUid"]
                          ? IconButton(
                              onPressed: () {
                                Provider.of<PostFunctions>(context,
                                        listen: false)
                                    .showPostOptions(
                                        context,
                                        documentSnapshot.id,
                                        documentSnapshot.data()["caption"]);
                              },
                              icon: Icon(
                                EvaIcons.moreVertical,
                                color: constantColors.whiteColor,
                              ))
                          : Container(
                              height: 0,
                              width: 0,
                            )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
