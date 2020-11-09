import 'package:attendo/home_page.dart';
import 'package:attendo/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  auth.User _user;

  _updateUser(auth.User user) {
    setState(() {
      _user = user;
    });
  }
  Future<void> _checkCurrentUser() async{
    final auth.User user = await auth.FirebaseAuth.instance.currentUser;
    _updateUser(user);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return _user==null ? SignInPage(
      onSignIn: _updateUser,
    ) : HomePage(updateUser: ()=>_updateUser(null));
  }

}
