
import 'package:attendo/screens/other_screens/edit_profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:attendo/screens/other_screens/edit_profile_page.dart';

final userRef = FirebaseFirestore.instance.collection('users');

class UserProfile extends StatefulWidget {
  UserProfile({this.user});

  final User user;

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  void _signOut()async{
    print('signing out');
    await FirebaseAuth.instance.signOut();
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      // backgroundColor: CupertinoColors.systemGrey,
      navigationBar: CupertinoNavigationBar(
        middle:Text('Profile'),
        trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: _signOut,
            child: Text('Logout', style: TextStyle(color: CupertinoColors.activeBlue),)),
      ),
      child: listOfOptions(),
    );
  }
  var _lights=true;
  ///here we are displaying List of all different options under setting
  listOfOptions(){
    return(
        ListView(
          children: [
            EditProfileCard(user: widget.user,),
            Divider(height: 1.5,color: CupertinoColors.inactiveGray,),
            GestureDetector(
              // padding: EdgeInsets.zero,
              child: CupertinoTile(
                // addPadding: false,
                title: 'Edit Profile',
                trailingWidget: Icon(CupertinoIcons.forward),
              ),
              onTap: (){
                print('opening editing page');
                Navigator.push(context, CupertinoPageRoute(builder: (context)=>EditProfilePage()));
              },
            ),
            Divider(height: 1,color: CupertinoColors.inactiveGray,),
            CupertinoTile(
              addPadding: false,
            title: 'Notification',
            trailingWidget: CupertinoSwitch(
              activeColor: CupertinoColors.activeBlue,
              value: _lights,
              onChanged: (bool value){
                setState(() {
                  _lights=value;
                });
              },
            ),
          )
          ],
        )
    );
  }


}



///
///
///edit Profile Card
class EditProfileCard extends StatelessWidget {
  EditProfileCard({
    this.user
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user.photoURL),
            radius: 28,
          ),
          SizedBox(
            height: 2,
          ),
          Text(
            user.displayName,
            style: TextStyle(fontWeight: FontWeight.w500, color: CupertinoColors.black,fontSize: 18),
          ),
          SizedBox(height: 2,),
          Text(user.email, style: TextStyle(fontSize: 12, color: CupertinoColors.black),),
        ],
      ),
      decoration: BoxDecoration(
        color: CupertinoColors.lightBackgroundGray,
      ),
    );
  }
}

class CupertinoTile extends StatelessWidget {
  CupertinoTile({
    this.title,this.iconData, this.trailingWidget,this.addPadding=true
  });

  final String title;
  final IconData iconData;
  final Widget trailingWidget;
  final bool addPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: addPadding? EdgeInsets.only(top: 6,bottom: 7,left: 10):EdgeInsets.only(left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyle(
                color: CupertinoColors.black,),
          ),
          trailingWidget
        ],
      ),
      decoration: BoxDecoration(
        color: CupertinoColors.lightBackgroundGray,
      ),
    );
  }
}
