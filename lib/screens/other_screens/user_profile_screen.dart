import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserProfile extends StatelessWidget {


  void _signOut()async{
    await FirebaseAuth.instance.signOut();
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: Text('Profile Page'),),
        // EditProfileCard(imageUrl: imageUrl),
        //this container will contain other stuff
        SizedBox(height: 10,),
        CupertinoButton.filled(
          child: Text('Log Out'),
          onPressed: _signOut,
        )
      ],
    );
  }
}


///edit Profile Card
class EditProfileCard extends StatelessWidget {
  EditProfileCard({
    @required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
              ),
              SizedBox(
                width: 12,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pulkit',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('@pulkit'),
                ],
              )
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
            child: Text(
              'Edit',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            decoration: BoxDecoration(
              color: Color(0xFF00AAFF),
              borderRadius: BorderRadius.circular(35),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}
