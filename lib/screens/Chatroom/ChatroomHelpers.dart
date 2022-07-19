import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mineapp/constants/Constantcolors.dart';
import 'package:mineapp/screens/Chatroom/ChatPage.dart';
import 'package:mineapp/services/Authentication.dart';
import 'package:mineapp/services/FirebaseOperations.dart';
import 'package:mineapp/utilites/PostOptions.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ChatroomHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  showCreateChatRoomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
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
                  child: Text(
                    "Send Message to...",
                    style: TextStyle(
                        color: constantColors.greenColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ),
                SingleChildScrollView(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(Provider.of<Authentication>(context, listen: false)
                            .getUserUid)
                        .collection("following")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView(
                            shrinkWrap: true,
                            children: snapshot.data.docs.map(
                                (DocumentSnapshot<Map<String, dynamic>>
                                    documentSnapshot) {
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: constantColors.transperant,
                                  backgroundImage: NetworkImage(
                                      documentSnapshot.data()["userImage"]),
                                ),
                                title: Text(
                                  documentSnapshot.data()["username"],
                                  style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: IconButton(
                                    onPressed: () {
                                      Provider.of<FirebaseOperations>(context,
                                              listen: false)
                                          .createchat(
                                              documentSnapshot
                                                  .data()["userUid"],
                                              documentSnapshot
                                                  .data()["userImage"],
                                              documentSnapshot
                                                  .data()["username"],
                                              Provider.of<Authentication>(
                                                      context,
                                                      listen: false)
                                                  .getUserUid);
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(
                                      Icons.message,
                                      color: constantColors.whiteColor,
                                    )),
                              );
                            }).toList());
                      }
                    },
                  ),
                )
              ],
            ),
          );
        });
  }

  allmessages(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
            .collection("chats")
            .orderBy("time", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data.docs.isEmpty) {
              return Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.speaker_notes_off_rounded,
                        color: constantColors.whiteColor,
                        size: 30,
                      ),
                      Text(
                        "No chats found",
                        style: TextStyle(
                            color: constantColors.whiteColor, fontSize: 15),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return SingleChildScrollView(
                child: ListView(
                  shrinkWrap: true,
                  children: snapshot.data.docs.map(
                      (DocumentSnapshot<Map<String, dynamic>>
                          documentSnapshot) {
                    Provider.of<PostFunctions>(context, listen: false)
                        .showTime(documentSnapshot.data()["time"]);
                    return Padding(
                      padding: EdgeInsets.only(
                        top: 8.0,
                      ),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        decoration: BoxDecoration(
                            color:
                                constantColors.blueGreyColor.withOpacity(0.6)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ListTile(
                              onTap: () {
                                Navigator.push(
                                        context,
                                        PageTransition(
                                            child: ChatPage(
                                              documentSnapshot:
                                                  documentSnapshot,
                                            ),
                                            type:
                                                PageTransitionType.rightToLeft))
                                    .whenComplete(() {
                                  Provider.of<FirebaseOperations>(context,
                                          listen: false)
                                      .seenmessage(
                                    Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserUid,
                                    documentSnapshot.id,
                                  );
                                });
                              },
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundColor: constantColors.transperant,
                                backgroundImage: NetworkImage(
                                    documentSnapshot.data()["userImage"]),
                              ),
                              title: Row(
                                children: [
                                  Text(
                                    documentSnapshot.data()["username"] + " ",
                                    style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  documentSnapshot.data()["isnew"]
                                      ? Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: constantColors.yellowColor,
                                          ),
                                        )
                                      : Container(
                                          width: 0,
                                          height: 0,
                                        )
                                ],
                              ),
                              subtitle: Text(
                                documentSnapshot.data()["lastmessage"] == null
                                    ? ""
                                    : documentSnapshot.data()["lastmessage"],
                                style: TextStyle(
                                    color: constantColors.whiteColor
                                        .withOpacity(0.6),
                                    fontWeight: FontWeight.normal),
                              ),
                              trailing: Text(
                                Provider.of<PostFunctions>(context,
                                                listen: false)
                                            .getImageTimePosted ==
                                        null
                                    ? ""
                                    : Provider.of<PostFunctions>(context,
                                            listen: false)
                                        .getImageTimePosted,
                                style: TextStyle(
                                    color: constantColors.whiteColor
                                        .withOpacity(0.5)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
