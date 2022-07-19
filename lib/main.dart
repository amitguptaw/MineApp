import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mineapp/screens/AltProfile/altProfileHelper.dart';
import 'package:mineapp/screens/Chatroom/ChatPageHelpers.dart';
import 'package:mineapp/screens/Chatroom/ChatroomHelpers.dart';
import 'package:mineapp/screens/Feed/FeedHelpers.dart';
import 'package:mineapp/screens/Homepage/HomePageHelpers.dart';
import 'package:mineapp/screens/Landingpage/landingServices.dart';
import 'package:mineapp/screens/Landingpage/landingUtils.dart';
import 'package:mineapp/screens/Landingpage/landinghelper.dart';
import 'package:mineapp/screens/Profile/ProfileHelpers.dart';
import 'package:mineapp/screens/Splashscreen/Splashscreen.dart';
import 'package:mineapp/services/Authentication.dart';
import 'package:mineapp/services/FirebaseOperations.dart';
import 'package:mineapp/utilites/PostOptions.dart';
import 'package:mineapp/utilites/UploadPosts.dart';
import 'package:provider/provider.dart';
import 'constants/Constantcolors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors = ConstantColors();
    return MultiProvider(
        child: MaterialApp(
          home: Splashscreen(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              accentColor: constantColors.blueColor,
              fontFamily: "Poppins",
              canvasColor: Colors.transparent),
        ),
        providers: [
          ChangeNotifierProvider(create: (_) => ChatPageHelpers()),
          ChangeNotifierProvider(create: (_) => ChatroomHelpers()),
          ChangeNotifierProvider(create: (_) => AltProfileHelper()),
          ChangeNotifierProvider(create: (_) => PostFunctions()),
          ChangeNotifierProvider(create: (_) => ProfileHelpers()),
          ChangeNotifierProvider(create: (_) => HomePageHelpers()),
          ChangeNotifierProvider(create: (_) => LandingHelpers()),
          ChangeNotifierProvider(create: (_) => Authentication()),
          ChangeNotifierProvider(create: (_) => LandingService()),
          ChangeNotifierProvider(create: (_) => FirebaseOperations()),
          ChangeNotifierProvider(create: (_) => landingUtils()),
          ChangeNotifierProvider(create: (_) => UploadPosts()),
          ChangeNotifierProvider(create: (_) => FeedHelpers()),
        ]);
  }
}
