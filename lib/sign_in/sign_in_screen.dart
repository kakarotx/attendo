import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


///this Page is not used anywhere as of now,
///Working on new sign in functionality in this page
class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 2,
            title: Center(child: Text('Attendo', style: TextStyle(color: Colors.black),)),
          ),
          body: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sign In'),
                MaterialButton(
                  splashColor: Colors.blueAccent,
                  color: Colors.blueAccent,
                  onPressed: null,
                  child: Center(child: Text('Sign-in with Google'),),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
