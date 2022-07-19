import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mineapp/constants/Constantcolors.dart';
import 'package:mineapp/screens/AltProfile/AltProfile.dart';
import 'package:mineapp/services/Authentication.dart';
import 'package:mineapp/services/FirebaseOperations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostFunctions with ChangeNotifier {
  final ConstantColors constantColors = ConstantColors();
  TextEditingController commentController = TextEditingController();

  String imageTimePosted;
  String get getImageTimePosted => imageTimePosted;

  showTime(Timestamp timedata) {
    Timestamp timestamp = timedata;
    DateTime dateTime = timestamp.toDate();
    imageTimePosted = timeago.format(dateTime);
    print("imageTimePosted - " + imageTimePosted);
  }

  Future addLike(BuildContext context, String postId, String subDocId) async {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("likes")
        .doc(subDocId)
        .set({
      "likes": FieldValue.increment(1),
      "username":
          Provider.of<FirebaseOperations>(context, listen: false).initUserName,
      "userUid": Provider.of<Authentication>(context, listen: false).getUserUid,
      "userImage":
          Provider.of<FirebaseOperations>(context, listen: false).initUserImage,
      "time": Timestamp.now()
    }).whenComplete(() {
      notifyListeners();
    });
  }

  Future removeLike(String postId, String subDocId) {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("likes")
        .doc(subDocId)
        .delete()
        .whenComplete(() {
      notifyListeners();
    });
  }

  showPostOptions(BuildContext context, String docId, String oldcap) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.1,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                color: constantColors.blueGreyColor),
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                          TextEditingController recaptionController =
                              new TextEditingController(text: oldcap);
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
                                        color: constantColors.blueGreyColor),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 150),
                                          child: Divider(
                                            thickness: 4,
                                            color: constantColors.whiteColor,
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Container(
                                                    width: 300,
                                                    height: 50,
                                                    child: TextField(
                                                      controller:
                                                          recaptionController,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            "Add Caption...",
                                                        hintStyle: TextStyle(
                                                            color:
                                                                constantColors
                                                                    .whiteColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16),
                                                      ),
                                                      style: TextStyle(
                                                          color: constantColors
                                                              .whiteColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    )),
                                              ),
                                              FloatingActionButton(
                                                onPressed: () {
                                                  Provider.of<FirebaseOperations>(
                                                          context,
                                                          listen: false)
                                                      .updateCaption(docId, {
                                                    "caption":
                                                        recaptionController.text
                                                  }).whenComplete(() {
                                                    Navigator.pop(context);
                                                    notifyListeners();
                                                  });
                                                },
                                                backgroundColor:
                                                    constantColors.redColor,
                                                child: Icon(
                                                  FontAwesomeIcons.shareSquare,
                                                  color:
                                                      constantColors.whiteColor,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        color: constantColors.blueColor,
                        child: Text(
                          "Edit Caption",
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: constantColors.darkColor,
                                  title: Text(
                                    "Delete this Post ?",
                                    style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
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
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor:
                                                constantColors.whiteColor),
                                      ),
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        Provider.of<FirebaseOperations>(context,
                                                listen: false)
                                            .deletePostData(context, docId)
                                            .whenComplete(() {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        });
                                      },
                                      color: constantColors.redColor,
                                      child: Text(
                                        "Yes",
                                        style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        },
                        color: constantColors.redColor,
                        child: Text(
                          "Delete Post",
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  Future addComment(BuildContext context, String postId, String comment) async {
    await FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("comments")
        .doc(comment)
        .set({
      "comment": comment,
      "username":
          Provider.of<FirebaseOperations>(context, listen: false).initUserName,
      "userUid": Provider.of<Authentication>(context, listen: false).getUserUid,
      "userImage":
          Provider.of<FirebaseOperations>(context, listen: false).initUserImage,
      "time": Timestamp.now()
    }).whenComplete(() {
      notifyListeners();
    });
  }

  showCommentSheet(BuildContext context,
      DocumentSnapshot<Map<String, dynamic>> snapshot, String docId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.80,
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
                    width: 100,
                    decoration: BoxDecoration(
                        border: Border.all(color: constantColors.whiteColor),
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: Text(
                        "Comments",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: constantColors.blueColor),
                      ),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection("posts")
                        .doc(docId)
                        .collection("comments")
                        .orderBy("time")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return new ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: snapshot.data.docs.map(
                              (DocumentSnapshot<Map<String, dynamic>>
                                  documentSnapshot) {
                            print(documentSnapshot.data().toString());
                            return Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.145,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 8),
                                        child: GestureDetector(
                                          onTap: () {
                                            if (documentSnapshot
                                                    .data()["userUid"] !=
                                                Provider.of<Authentication>(
                                                        context,
                                                        listen: false)
                                                    .getUserUid) {
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      child: AltProfile(
                                                          userUid:
                                                              documentSnapshot
                                                                      .data()[
                                                                  "userUid"]),
                                                      type: PageTransitionType
                                                          .rightToLeft));
                                            }
                                          },
                                          child: CircleAvatar(
                                            backgroundColor:
                                                constantColors.transperant,
                                            backgroundImage: NetworkImage(
                                                documentSnapshot
                                                    .data()["userImage"]),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            if (documentSnapshot
                                                    .data()["userUid"] !=
                                                Provider.of<Authentication>(
                                                        context,
                                                        listen: false)
                                                    .getUserUid) {
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      child: AltProfile(
                                                          userUid:
                                                              documentSnapshot
                                                                      .data()[
                                                                  "userUid"]),
                                                      type: PageTransitionType
                                                          .rightToLeft));
                                            }
                                          },
                                          child: Container(
                                            child: Text(
                                              documentSnapshot
                                                  .data()["username"],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      constantColors.whiteColor,
                                                  fontSize: 16.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                FontAwesomeIcons.arrowUp,
                                                color:
                                                    constantColors.yellowColor,
                                                size: 13,
                                              ),
                                            ),
                                            Text(
                                              "0",
                                              style: TextStyle(
                                                  color:
                                                      constantColors.whiteColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                    FontAwesomeIcons.reply,
                                                    color: constantColors
                                                        .greenColor,
                                                    size: 13)),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color: constantColors.blueColor,
                                            size: 12,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.75,
                                          child: Text(
                                            documentSnapshot.data()["comment"],
                                            style: TextStyle(
                                                fontSize: 16,
                                                color:
                                                    constantColors.whiteColor),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                                FontAwesomeIcons.trashAlt,
                                                color: constantColors.redColor,
                                                size: 15)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                  Spacer(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              hintText: "Comment here...",
                              hintStyle: TextStyle(
                                  color: constantColors.whiteColor
                                      .withOpacity(0.8),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            controller: commentController,
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            print("add commnets");
                            addComment(context, snapshot.id,
                                    commentController.text)
                                .whenComplete(() {
                              commentController.clear();
                              notifyListeners();
                            });
                          },
                          backgroundColor: constantColors.greenColor,
                          child: Icon(
                            FontAwesomeIcons.comment,
                            color: constantColors.whiteColor,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  topLeft: Radius.circular(12),
                ),
              ),
            ),
          );
        });
  }

  showLikes(BuildContext context, String docId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.55,
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
                  width: 100,
                  decoration: BoxDecoration(
                      border: Border.all(color: constantColors.whiteColor),
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: Text(
                      "Likes",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: constantColors.blueColor),
                    ),
                  ),
                ),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection("posts")
                      .doc(docId)
                      .collection("likes")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return new ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: snapshot.data.docs.map(
                            (DocumentSnapshot<Map<String, dynamic>>
                                documentsnapshot) {
                          print("doc s  " + documentsnapshot.data().toString());
                          return ListTile(
                            leading: GestureDetector(
                              onTap: () {
                                if (documentsnapshot.data()["userUid"] !=
                                    Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserUid) {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: AltProfile(
                                              userUid: documentsnapshot
                                                  .data()["userUid"]),
                                          type:
                                              PageTransitionType.rightToLeft));
                                }
                              },
                              child: CircleAvatar(
                                backgroundColor: constantColors.transperant,
                                backgroundImage: NetworkImage(
                                    documentsnapshot.data()["userImage"]),
                              ),
                            ),
                            title: GestureDetector(
                              onTap: () {
                                if (documentsnapshot.data()["userUid"] !=
                                    Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserUid) {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: AltProfile(
                                              userUid: documentsnapshot
                                                  .data()["userUid"]),
                                          type:
                                              PageTransitionType.rightToLeft));
                                }
                              },
                              child: Text(documentsnapshot.data()["username"],
                                  style: TextStyle(
                                      color: constantColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            ),
                            trailing: (documentsnapshot.data()["userUid"] ==
                                    Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserUid)
                                ? Container(
                                    width: 0,
                                    height: 0,
                                  )
                                : IconButton(
                                    icon: Icon(
                                      Icons.person_add,
                                      color: constantColors.blueColor,
                                      size: 25,
                                    ),
                                    onPressed: () {},
                                  ),
                          );
                        }).toList(),
                      );
                    }
                  },
                )
              ],
            ),
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
          );
        });
  }
}
