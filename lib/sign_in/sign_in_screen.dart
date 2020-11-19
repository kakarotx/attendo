import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
///this Page is not used anywhere as of now,
///Working on new sign in functionality in this page
class SignInPage extends StatelessWidget {
  final _firebaseAuth = FirebaseAuth.instance;

  ///this is the same user who logged in, but also contains
  ///some more properties
  User user;

  ///Implementation of SignInWithGoogle
  _signInWithGoogle() async {
    try{
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount googleAccount = await googleSignIn.signIn();

      if (googleAccount != null) {
        GoogleSignInAuthentication googleAuth =
        await googleAccount.authentication;
        if (googleAuth.accessToken != null && googleAuth.idToken != null) {
          final authResult = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                accessToken: googleAuth.accessToken, idToken: googleAuth.idToken),
          );
          print(authResult.user.email);
          user=authResult.user;
          _uploadUserData(user);
          return user;
        } else{
          PlatformException(
              code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN', message: 'Missing Google Auth Token');
        }
      } else {
        PlatformException(
            code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by User');
      }
    } catch(e){
      print('QWERTY:: $e');
    }

  }

  _uploadUserData(User user) {

    print('qwerty:: called');
    final _firestore = FirebaseFirestore.instance;
    final userCollection = _firestore.collection('users');
    userCollection.doc(user.uid.toString()).set(
        {
          'userEmail': user.email,
          'usedId': user.uid,
          'userImageUrl': user.photoURL,
          'userDisplayName': user.displayName,
          'lastLogin' : DateTime.now(),
        });

    print('qwerty:: ${user.email}');
  }
  @override
  Widget build(BuildContext context) {
    return signInScreen();
  }

  ///method that builds signInScreen
  CupertinoApp signInScreen() {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
    home: CupertinoPageScaffold(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Sign In'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
              child: CupertinoButton.filled(
                onPressed: (){
                  _signInWithGoogle();
                },
                child: Center(
                  child: Text('Sign in with Google'),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }
}
