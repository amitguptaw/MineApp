import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mineapp/constants/Constantcolors.dart';
import 'package:mineapp/screens/AltProfile/altProfile.dart';
import 'package:mineapp/screens/Landingpage/landingpage.dart';
import 'package:mineapp/screens/Profile/ShowPost.dart';
import 'package:mineapp/services/Authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ProfileHelpers with ChangeNotifier {
  final ConstantColors constantColors = ConstantColors();
  Widget headerProfile(
      BuildContext context, DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.width,
      child: Row(
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
                          checkFollowingSheet(context, snapshot, "following");
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
                                      return Container(
                                        child: Text(
                                          "-",
                                          style: TextStyle(
                                            fontSize: 28,
                                            color: constantColors.whiteColor
                                                .withOpacity(0.6),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Container(
                                        child: Text(
                                          snapshots.data.docs.length.toString(),
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: constantColors.whiteColor,
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
                          checkFollowingSheet(context, snapshot, "follower");
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
                                          snapshots.data.docs.length.toString(),
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: constantColors.whiteColor,
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
                            builder: (context, snapshots) {
                              if (snapshots.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return Text(
                                  snapshots.data.docs.length.toString(),
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: constantColors.whiteColor,
                                  ),
                                );
                              }
                            }),
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

  Widget footerProfile(BuildContext context, String docId) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(docId)
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

  logoutDailog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: constantColors.darkColor,
            title: Text(
              " Log Out?",
              style: TextStyle(
                  color: constantColors.whiteColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "No",
                  style: TextStyle(
                    color: constantColors.whiteColor,
                    decoration: TextDecoration.underline,
                    decorationColor: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  Provider.of<Authentication>(context, listen: false)
                      .signoutViaEmail()
                      .whenComplete(() {
                    Navigator.pop(context);

                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: landingpage(),
                          type: PageTransitionType.leftToRight),
                    );
                  });
                },
                color: constantColors.redColor,
                child: Text(
                  "Yes",
                  style: TextStyle(
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              )
            ],
          );
        });
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
                                "You have no Data",
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
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: AltProfile(
                                              userUid: documentsnapshot
                                                  .data()["userUid"],
                                            ),
                                            type: PageTransitionType
                                                .rightToLeft));
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
                                  trailing: IconButton(
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
