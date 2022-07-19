import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mineapp/constants/Constantcolors.dart';
import 'package:mineapp/screens/Homepage/Homepage.dart';
import 'package:mineapp/screens/Landingpage/landingUtils.dart';
import 'package:mineapp/services/Authentication.dart';
import 'package:mineapp/services/FirebaseOperations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LandingService with ChangeNotifier {
  final ConstantColors constantColors = ConstantColors();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  Future showUserAvatar(BuildContext context) async {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.circular(12.0)),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                CircleAvatar(
                  radius: 80,
                  backgroundColor: constantColors.transperant,
                  backgroundImage: FileImage(
                      Provider.of<landingUtils>(context, listen: false)
                          .userAvatar),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Provider.of<landingUtils>(context, listen: false)
                              .pickUserAvatar(context, ImageSource.gallery);
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
                          Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .uploadUserAvatar(context)
                              .whenComplete(() {
                            signInSheet(context);
                          });
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
              ],
            ),
          );
        });
  }

  Widget passwordLessSignIn(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return new ListView(
              children: snapshot.data.docs.map(
                  (DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
                return ListTile(
                  trailing: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.trashAlt,
                      color: constantColors.redColor,
                    ),
                    onPressed: () {},
                  ),
                  leading: CircleAvatar(
                    backgroundColor: constantColors.transperant,
                    backgroundImage: NetworkImage(
                        documentSnapshot.data()['userimage'].toString()),
                  ),
                  title: Text(
                    documentSnapshot.data()['userName'],
                    style: TextStyle(color: constantColors.greenColor),
                  ),
                  subtitle: Text(
                    documentSnapshot.data()['userEmail'],
                    style: TextStyle(
                        color: constantColors.greenColor, fontSize: 13.0),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }

  logInSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                          hintText: 'Enter Email Id',
                          hintStyle: TextStyle(
                              fontSize: 16,
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold)),
                      style: TextStyle(
                          fontSize: 18,
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                          hintText: 'Enter password',
                          hintStyle: TextStyle(
                              fontSize: 16,
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold)),
                      style: TextStyle(
                          fontSize: 18,
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      if (passwordController.text.isNotEmpty &&
                          emailController.text.isNotEmpty) {
                        Provider.of<Authentication>(context, listen: false)
                            .LogIntoAccount(context, emailController.text,
                                passwordController.text)
                            .whenComplete(() {
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  child: Homepage(),
                                  type: PageTransitionType.rightToLeft));
                          emailController.clear();
                          passwordController.clear();
                        });
                      } else {
                        warningText(context, "Fill all blanks");
                      }
                    },
                    backgroundColor: constantColors.blueColor,
                    child: Icon(
                      FontAwesomeIcons.check,
                      color: constantColors.whiteColor,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  signInSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
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
                  CircleAvatar(
                    backgroundImage: FileImage(
                        Provider.of<landingUtils>(context, listen: false)
                            .getUserAvatar),
                    backgroundColor: constantColors.redColor,
                    radius: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                          hintText: 'Enter UserName',
                          hintStyle: TextStyle(
                              fontSize: 16,
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold)),
                      style: TextStyle(
                          fontSize: 18,
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                          hintText: 'Enter Email Id',
                          hintStyle: TextStyle(
                              fontSize: 16,
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold)),
                      style: TextStyle(
                          fontSize: 18,
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                          hintText: 'Enter password',
                          hintStyle: TextStyle(
                              fontSize: 16,
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold)),
                      style: TextStyle(
                          fontSize: 18,
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: FloatingActionButton(
                      onPressed: () {
                        if (usernameController.text.isNotEmpty &&
                            passwordController.text.isNotEmpty &&
                            emailController.text.isNotEmpty) {
                          Provider.of<Authentication>(context, listen: false)
                              .createAccuount(
                                  emailController.text, passwordController.text)
                              .whenComplete(() {
                            print("User collection creating");
                            Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .createUserCollection(context, {
                              "useruid": Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserUid,
                              "userEmail": emailController.text,
                              "userName": usernameController.text,
                              "userimage": Provider.of<landingUtils>(context,
                                      listen: false)
                                  .getUserAvatarUrl
                            });
                          }).whenComplete(() {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    child: Homepage(),
                                    type: PageTransitionType.rightToLeft));

                            emailController.clear();
                            usernameController.clear();
                            passwordController.clear();
                          });
                        } else {
                          warningText(context, "Fill all blanks");
                        }
                      },
                      backgroundColor: constantColors.redColor,
                      child: Icon(
                        FontAwesomeIcons.check,
                        color: constantColors.whiteColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  warningText(BuildContext context, String warning) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.redColor,
                borderRadius: BorderRadius.circular(15.0)),
            child: Text(
              warning,
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: constantColors.whiteColor),
            ),
          );
        });
  }
}
