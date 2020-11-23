import 'package:attendo/home_page.dart';
import 'package:attendo/sign_in/sign_in_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class LandingPage extends StatelessWidget {


  void initState() {
    auth.FirebaseAuth.instance.authStateChanges().listen((user) {
      print('user :${user?.uid}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (_) => HomePage(),
        // 'deeper': (_) => (),
      },
      home: CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        child: StreamBuilder<auth.User>(
            initialData: auth.FirebaseAuth.instance.currentUser,
            ///this is the stream of type [User] and we listen to it
            ///when any new data comes
            ///the builder: property builds it self every time new
            ///data comes
            stream: auth.FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              ///this snapshot contains the Data from our Stream
              ///Stream can contain any data eg. [int, list, null]
              if (snapshot.connectionState == ConnectionState.active) {
                final user = snapshot.data;
                if (user == null) {
                  print('qwerty ::${user?.uid}');
                  return SignInPage();
                } else{
                  print('qwerty ::${user?.uid}');
                  return HomePage();
                }
              } else{
                return CupertinoApp(
                  home: CupertinoPageScaffold(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }

            }),
      ),
    );
  }
}