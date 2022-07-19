import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mineapp/screens/Homepage/Homepage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication with ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  String userUid;
  String get getUserUid {
    return userUid;
  }

  Future LogIntoAccount(
      BuildContext context, String email, String password) async {
    UserCredential userCredential;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .whenComplete(() async {
        prefs.setString("email", email);
        prefs.setString("password", password);
      });
      /*whenComplete(() async {
        print("33333333333" + userCredential.toString());
        User user = userCredential.user;
        userUid = user.uid;
        print(userUid);
        notifyListeners();
      }).whenComplete(() {
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: Homepage(), type: PageTransitionType.rightToLeft));
      });*/
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    User user = userCredential.user;
    userUid = user.uid;
    print(userUid);
    notifyListeners();
  }

  Future signoutViaEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("email");
    prefs.remove("password").whenComplete(() {
      return firebaseAuth.signOut();
    });
  }

  Future createAccuount(String email, String password) async {
    UserCredential userCredential;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .whenComplete(() async {
        prefs.setString("email", email);
        prefs.setString("password", password);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    User user = userCredential.user;
    userUid = user.uid;
    print(userUid);
    notifyListeners();
  }

  Future signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    final UserCredential userCredential =
        await firebaseAuth.signInWithCredential(authCredential);

    final User user = userCredential.user;
    assert(user.uid != null);
    userUid = user.uid;
    print("Goog;e user uid => $userUid");
    notifyListeners();
  }

  Future signOutWithGoogle() async {
    return googleSignIn.signOut();
  }
}
