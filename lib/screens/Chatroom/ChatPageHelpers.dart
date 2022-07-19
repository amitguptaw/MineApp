import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mineapp/constants/Constantcolors.dart';
import 'package:mineapp/services/Authentication.dart';
import 'package:mineapp/services/FirebaseOperations.dart';
import 'package:provider/provider.dart';

class ChatPageHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  TextEditingController messageControler = TextEditingController();

  Widget chatBody(BuildContext context,
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            AnimatedContainer(
              child: showMessages(context, documentSnapshot),
              duration: Duration(seconds: 1),
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width,
              curve: Curves.bounceIn,
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.camera_alt),
                      color: constantColors.whiteColor.withOpacity(0.6),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.73,
                      child: TextField(
                        controller: messageControler,
                        decoration: InputDecoration(
                          hintText: "Type a Message...",
                          hintStyle: TextStyle(
                              color: constantColors.greenColor.withOpacity(0.8),
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .sendMessage(
                                documentSnapshot.id,
                                Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid,
                                {
                                  "sender": Provider.of<Authentication>(context,
                                          listen: false)
                                      .getUserUid,
                                  "receiver": documentSnapshot.id,
                                  "time": Timestamp.now(),
                                  "message": messageControler.text,
                                },
                                messageControler.text)
                            .whenComplete(() {
                          messageControler.clear();
                        });
                      },
                      backgroundColor: constantColors.greenColor,
                      child: Icon(
                        Icons.send_outlined,
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
    );
  }

  showMessages(BuildContext context,
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot0) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
          .collection("chats")
          .doc(documentSnapshot0.id)
          .collection("messages")
          .orderBy("time", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: constantColors.greenColor,
            ),
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
                      Icons.new_releases_outlined,
                      color: constantColors.whiteColor,
                      size: 30,
                    ),
                    Text(
                      "No Messages Yet",
                      style: TextStyle(
                          color: constantColors.whiteColor, fontSize: 15),
                    )
                  ],
                ),
              ),
            );
          } else {
            return ListView(
              shrinkWrap: true,
              reverse: true,
              children: snapshot.data.docs.map(
                  (DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(
                    child: Container(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width * 0.1,
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                        minHeight: 35,
                      ),
                      color: constantColors.redColor,
                      child: Column(
                        children: [
                          Text(
                            documentSnapshot.data()["message"],
                            style: TextStyle(
                                color: constantColors.whiteColor, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }
        }
      },
    );
  }
}
