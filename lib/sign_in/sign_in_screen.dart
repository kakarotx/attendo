import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

///this Page is not used anywhere as of now,
///Working on new sign in functionality in this page
// ignore: must_be_immutable
class SignInPage extends StatefulWidget {
  SignInPage({this.isThemeLight});
  final bool isThemeLight;

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _firebaseAuth = FirebaseAuth.instance;

  ///this is the same user who logged in, but also contains
  ///some more properties
  User user;

  ///Implementation of SignInWithGoogle
  _signInWithGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount googleAccount = await googleSignIn.signIn();

      if (googleAccount != null) {
        GoogleSignInAuthentication googleAuth =
            await googleAccount.authentication;
        if (googleAuth.accessToken != null && googleAuth.idToken != null) {
          final authResult = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                accessToken: googleAuth.accessToken,
                idToken: googleAuth.idToken),
          );
          print(authResult.user.email);
          user = authResult.user;
          _uploadUserData(user);
          return user;
        } else {
          PlatformException(
              code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
              message: 'Missing Google Auth Token');
        }
      } else {
        PlatformException(
            code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by User');
      }
    } catch (e) {
      print('QWERTY:: $e');
    }
  }

  _uploadUserData(User user) {
    print('qwerty:: called');
    final _firestore = FirebaseFirestore.instance;
    final userCollection = _firestore.collection('users');
    userCollection.doc(user.uid.toString()).set({
      'userEmail': user.email,
      'usedId': user.uid,
      'userImageUrl': user.photoURL,
      'userDisplayName': user.displayName,
      'lastLogin': DateTime.now(),
      'rollNo': null,
    });

    print('qwerty:: ${user.email}');
  }

  @override
  Widget build(BuildContext context) {
    return signInScreen(context);
  }

  ///method that builds signInScreen
  CupertinoPageScaffold signInScreen(BuildContext context) {
    final kStyle = TextStyle(
        fontSize: 45,
        fontFamily: 'inter',
        fontWeight: FontWeight.w900,
        color: CupertinoColors.white);

    return CupertinoPageScaffold(
      child: widget.isThemeLight ? lightThemeLogin() : darkThemeLogin(),
    );
  }

  Stack darkThemeLogin() {
    return Stack(children: [
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/signIn_dark.jpg',
            ),
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
      Column(
        children: [
          SizedBox(
            height: 680,
          ),
          GestureDetector(
            onTap: _signInWithGoogle,
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 62),
                padding: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                    color: Color(0xFF0000CC),
                    borderRadius: BorderRadius.circular(6)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('assets/images/google_sign.png'),
                      height: 30,
                      width: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Continue with Google',
                      style: TextStyle(color: CupertinoColors.white),
                    )
                  ],
                ),),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 26, vertical: 4),
            margin: EdgeInsets.only(left: 20, right: 20, top: 40),
            child: Center(
              child: Text(
                "By continuing you agree Okays's Terms of services & Privacy Policy.",
                textAlign: TextAlign.center,
                style: TextStyle(color: CupertinoColors.white, fontSize: 12),
              ),
            ),
          )
        ],
      ),
    ],);
  }

  Stack lightThemeLogin() {
    return Stack(children: [
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/signIn_light.jpg',
            ),
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
      Column(
        children: [
          SizedBox(
            height: 680,
          ),
          GestureDetector(
            onTap: _signInWithGoogle,
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 62),
                padding: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  // color: CupertinoColors.systemBlue,
                  color: Color(0xFF13375B),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('assets/images/google_sign.png'),
                      height: 30,
                      width: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Continue with Google',
                      style: TextStyle(color: CupertinoColors.white),
                    )
                  ],
                )),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 26, vertical: 4),
            margin: EdgeInsets.only(left: 20, right: 20, top: 40),
            child: Center(
              child: Text(
                "By continuing you agree Okays's Terms of services & Privacy Policy.",
                textAlign: TextAlign.center,
                style: TextStyle(color: CupertinoColors.white, fontSize: 12),
              ),
            ),
          )
        ],
      ),
    ]);
  }
}
