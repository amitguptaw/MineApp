import 'package:flutter/material.dart';
import 'package:mineapp/constants/Constantcolors.dart';
import 'package:mineapp/screens/Chatroom/ChatPageHelpers.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  ConstantColors constantColors = ConstantColors();
  dynamic documentSnapshot;
  ChatPage({@required this.documentSnapshot});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_outlined,
              color: constantColors.whiteColor,
            )),
        backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
      ),
      backgroundColor: constantColors.darkColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Provider.of<ChatPageHelpers>(context, listen: false)
            .chatBody(context, documentSnapshot),
      ),
    );
  }
}
