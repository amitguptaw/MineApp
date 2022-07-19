import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mineapp/constants/Constantcolors.dart';
import 'package:mineapp/screens/AltProfile/AltProfile.dart';
import 'package:mineapp/screens/Homepage/Homepage.dart';
import 'package:mineapp/screens/Profile/ShowPost.dart';
import 'package:mineapp/services/Authentication.dart';
import 'package:mineapp/services/FirebaseOperations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class AltProfileHelper with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: constantColors.whiteColor,
          )),
      title: RichText(
        text: TextSpan(
          text: "Mine",
          style: TextStyle(
              color: constantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 20),
          children: <TextSpan>[
            TextSpan(
                text: "Profile",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: constantColors.blueColor))
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
                context,
                PageTransition(
                    child: Homepage(), type: PageTransitionType.leftToRight));
          },
          icon: Icon(EvaIcons.moreVertical),
          color: constantColors.whiteColor,
        )
      ],
    );
  }

  Widget headerProfile(BuildContext context,
      DocumentSnapshot<Map<String, dynamic>> snapshot, String userUid) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.35,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 220,
                width: 180,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: GestureDetector(
                        onTap: () {},
                        child: CircleAvatar(
                          backgroundColor: constantColors.transperant,
                          radius: 60,
                          backgroundImage:
                              NetworkImage(snapshot.data()["userimage"]),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        snapshot.data()["userName"],
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            EvaIcons.emailOutline,
                            color: constantColors.greenColor,
                            size: 16,
                          ),
                          Text(
                            snapshot.data()["userEmail"],
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              checkFollowingSheet(
                                  context, snapshot, "following");
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: constantColors.darkColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              height: 70,
                              width: 80,
                              child: Column(
                                children: [
                                  StreamBuilder<
                                          QuerySnapshot<Map<String, dynamic>>>(
                                      stream: FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(snapshot.data()["useruid"])
                                          .collection("following")
                                          .snapshots(),
                                      builder: (context, snapshots) {
                                        if (snapshots.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else {
                                          return Container(
                                            child: Text(
                                              snapshots.data.docs.length
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    constantColors.whiteColor,
                                              ),
                                            ),
                                          );
                                        }
                                      }),
                                  Text(
                                    "Following",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                      color: constantColors.whiteColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              checkFollowingSheet(
                                  context, snapshot, "follower");
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: constantColors.darkColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              height: 70,
                              width: 80,
                              child: Column(
                                children: [
                                  StreamBuilder<
                                          QuerySnapshot<Map<String, dynamic>>>(
                                      stream: FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(snapshot.data()["useruid"])
                                          .collection("follower")
                                          .snapshots(),
                                      builder: (context, snapshots) {
                                        if (snapshots.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else {
                                          return Container(
                                            child: Text(
                                              snapshots.data.docs.length
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    constantColors.whiteColor,
                                              ),
                                            ),
                                          );
                                        }
                                      }),
                                  Text(
                                    "Followers",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                      color: constantColors.whiteColor,
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
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: constantColors.darkColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        height: 70,
                        width: 80,
                        child: Column(
                          children: [
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                              stream: FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(snapshot.data()["useruid"])
                                  .collection("posts")
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return Text(
                                    snapshot.data.docs.length.toString(),
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: constantColors.whiteColor,
                                    ),
                                  );
                                }
                              },
                            ),
                            Text(
                              "Posts",
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: constantColors.whiteColor,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(Provider.of<Authentication>(context, listen: false)
                            .userUid)
                        .collection("following")
                        .doc(userUid)
                        .snapshots(),
                    builder: (context, snapshot1) {
                      if (snapshot1.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        if (snapshot1.data.exists) {
                          return MaterialButton(
                            onPressed: () {
                              Provider.of<FirebaseOperations>(context,
                                      listen: false)
                                  .unfollowUser(
                                      userUid,
                                      Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserUid);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check,
                                  color: constantColors.whiteColor,
                                ),
                                Text(
                                  "Following",
                                  style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return MaterialButton(
                            onPressed: () {
                              Provider.of<FirebaseOperations>(context,
                                      listen: false)
                                  .followUser(
                                      userUid,
                                      {
                                        "username":
                                            Provider.of<FirebaseOperations>(
                                                    context,
                                                    listen: false)
                                                .initUserName,
                                        "userImage":
                                            Provider.of<FirebaseOperations>(
                                                    context,
                                                    listen: false)
                                                .initUserImage,
                                        "time": Timestamp.now(),
                                        "userUid": Provider.of<Authentication>(
                                                context,
                                                listen: false)
                                            .getUserUid
                                      },
                                      Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserUid,
                                      {
                                        "username": snapshot.data()["userName"],
                                        "userImage":
                                            snapshot.data()["userimage"],
                                        "time": Timestamp.now(),
                                        "userUid": userUid
                                      })
                                  .whenComplete(() {
                                print("followed");
                              });
                            },
                            color: constantColors.blueColor,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person_add,
                                  color: constantColors.whiteColor,
                                ),
                                Text(
                                  " Follow  ",
                                  style: TextStyle(
                                      color: constantColors.whiteColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    }),
                MaterialButton(
                  onPressed: () {},
                  color: constantColors.blueColor,
                  child: Row(
                    children: [
                      Icon(
                        Icons.chat,
                        color: constantColors.whiteColor,
                      ),
                      Text(
                        " Message",
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget divider(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.70,
        height: 15,
        child: Divider(
          color: constantColors.whiteColor,
          thickness: 0.1,
        ),
      ),
    );
  }

  Widget middileprofile(
      BuildContext context, DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  FontAwesomeIcons.userAstronaut,
                  color: constantColors.yellowColor,
                  size: 16,
                ),
                Text(
                  "Recently Added",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: constantColors.whiteColor,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(snapshot.data()["useruid"])
                          .collection("following")
                          .snapshots(),
                      builder: (context, snapshots) {
                        if (snapshots.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return new ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshots.data.docs.map(
                                (DocumentSnapshot<Map<String, dynamic>>
                                    documentsnapshot) {
                              return Container(
                                height: 40,
                                width: 40,
                                child: CircleAvatar(
                                  backgroundColor: constantColors.transperant,
                                  backgroundImage: NetworkImage(
                                      documentsnapshot.data()["userImage"]),
                                ),
                              );
                            }).toList(),
                          );
                        }
                      }),
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: constantColors.darkColor.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(50.0)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget footerProfile(BuildContext context, String uUid) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(uUid)
            .collection("posts")
            .orderBy("time", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return GridView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: snapshot.data.docs.map(
                    (DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(
                      child: GestureDetector(
                        onTap: () {
                          print(documentSnapshot.id);
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: ShowPost(
                                    postId: documentSnapshot.id,
                                  ),
                                  type: PageTransitionType.rightToLeft));
                        },
                        child: Container(
                            decoration:
                                BoxDecoration(color: constantColors.whiteColor),
                            // height: MediaQuery.of(context).size.height * 0.3,
                            //width: MediaQuery.of(context).size.width,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Container(
                                child: Image.network(
                                    documentSnapshot.data()["Postdata"]),
                              ),
                            )),
                      ),
                    ),
                  );
                }).toList(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3));
          }
        },
      ),
    );
  }

  checkFollowingSheet(
      BuildContext context, dynamic snapshot, String collectionName) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: constantColors.blueGreyColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
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
                    width: 100,
                    decoration: BoxDecoration(
                        border: Border.all(color: constantColors.whiteColor),
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: Text(
                        (collectionName == "following")
                            ? "Following"
                            : "Followers",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: constantColors.blueColor),
                      ),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(snapshot.data()["useruid"])
                          .collection(collectionName)
                          .snapshots(),
                      builder: (context, snapshots) {
                        if (snapshots.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          if (snapshots.data.docs.isEmpty) {
                            return Center(
                              child: Text(
                                "No Data Available",
                                style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }
                          return new ListView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: snapshots.data.docs.map(
                                (DocumentSnapshot<Map<String, dynamic>>
                                    documentsnapshot) {
                              return new ListTile(
                                  onTap: () {
                                    if (documentsnapshot.data()["userUid"] ==
                                        Provider.of<Authentication>(context,
                                                listen: false)
                                            .getUserUid) {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              child: AltProfile(
                                                userUid: documentsnapshot
                                                    .data()["userUid"],
                                              ),
                                              type: PageTransitionType
                                                  .rightToLeft));
                                    }
                                  },
                                  leading: CircleAvatar(
                                    backgroundColor: constantColors.transperant,
                                    backgroundImage: NetworkImage(
                                        documentsnapshot.data()["userImage"]),
                                  ),
                                  title: Text(
                                    documentsnapshot.data()["username"],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: constantColors.whiteColor),
                                  ),
                                  trailing: documentsnapshot
                                              .data()["userUid"] ==
                                          Provider.of<Authentication>(context,
                                                  listen: false)
                                              .getUserUid
                                      ? Container(
                                          height: 0,
                                          width: 0,
                                        )
                                      : IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.person_remove),
                                          color: constantColors.redColor,
                                        ));
                            }).toList(),
                          );
                        }
                      }),
                ],
              ));
        });
  }
}
