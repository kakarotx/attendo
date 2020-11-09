import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

///this Page is not used anywhere as of now,
///Working on new sign in functionality in this page
class SignInPage extends StatelessWidget {
  SignInPage({@required this.onSignIn});

  final Function(User) onSignIn;

  _signInAnonymously() async {
    try {
      final UserCredential authResult =
          await FirebaseAuth.instance.signInAnonymously();
      onSignIn(authResult.user);
    } catch (e) {
      print('Sign in Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 2,
            title: Center(
                child: Text(
              'Attendo',
              style: TextStyle(color: Colors.black),
            )),
          ),
          body: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sign In'),
                FlatButton(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  splashColor: Colors.blue.shade600,
                  color: Colors.blueAccent,
                  onPressed: () {
                    print('pressed');
                  },
                  child: Center(
                    child: Text('Sign-in with Google'),
                  ),
                ),
                FlatButton(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  splashColor: Colors.black26,
                  color: Colors.black54,
                  onPressed: () {
                    print('pressed');
                    _signInAnonymously();
                  },
                  child: Center(
                    child: Text('Sign-in Anonymously'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
