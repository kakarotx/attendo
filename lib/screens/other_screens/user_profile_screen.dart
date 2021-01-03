import 'package:attendo/modals/size_config.dart';
import 'package:attendo/screens/other_screens/developers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

//Media Query r2d
final userRef = FirebaseFirestore.instance.collection('users');

class UserProfile extends StatefulWidget {
  UserProfile({this.user, this.toggleTheme});

  final User user;
  final Function toggleTheme;

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  String rollNo;
  String enteredRollNumber;

  updateData(){
    userRef.doc(widget.user.uid).update({
      'rollNo': enteredRollNumber,
    });
  }
  void _signOut()async{
    // print('signing out');
    await FirebaseAuth.instance.signOut();
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  ///this will show a Dailog after we press delete Course button
  ///which has 2 options, [cancel] and [delete]
  void confirmDeleteAlert(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('Confirm'),
            content: Text("Do you want to Logout?"),
            actions: <Widget>[
              CupertinoDialogAction(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              CupertinoDialogAction(
                  textStyle: TextStyle(color: CupertinoColors.destructiveRed),
                  // isDefaultAction: true,
                  onPressed: (){
                    Navigator.pop(context);
                    _signOut();
                  },
                  child: Text("Log0ut")),
            ],
          );
        });
  }

  ///called at: Show app demo
  ///and will take user to a youtube video
  _launchURL() async {
    const url = 'https://www.youtube.com/watch?v=s9TQIiq9fF0';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        // backgroundColor: CupertinoColors.systemGrey,
        navigationBar: CupertinoNavigationBar(
          middle:Text('Profile'),
          trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: (){
                confirmDeleteAlert(context);
              },
              child: Text('Logout', style: TextStyle(color: CupertinoColors.activeBlue),),),
        ),
        child: listOfOptions(),
    );
  }

  ///here we are displaying List of all different options under setting
  listOfOptions(){
    return
      SafeArea(
      child: (
          Column(
            children: [
              ProfileCard(user: widget.user),
              Divider(height: (0.122*SizeConfig.heightMultiplier).roundToDouble(),color: CupertinoColors.inactiveGray,),
              CupertinoButton(
                padding: EdgeInsets.only(left: (SizeConfig.one_W*10).roundToDouble()),
                onPressed: widget.toggleTheme,
                child: CupertinoTile(
                  title: 'Switch Theme',
                ),
              ),
              Divider(height: (0.122*SizeConfig.heightMultiplier).roundToDouble(),color: CupertinoColors.inactiveGray,),
              CupertinoButton(
                padding: EdgeInsets.only(left: (SizeConfig.one_W*10).roundToDouble()),              // padding: EdgeInsets.zero,
                child: CupertinoTile(
                  title: 'Show app demo',
                ),
                onPressed: (){
                  // print('taking to youtube page');
                  //TODO: take to Youtube Video
                  _launchURL();
                },
              ),
              Divider(height: (0.122*SizeConfig.heightMultiplier).roundToDouble(),color: CupertinoColors.inactiveGray,),
              CupertinoButton(
                padding: EdgeInsets.only(left: (SizeConfig.one_W*10).roundToDouble()),
                child: CupertinoTile(
                  title: 'About us',
                ),
                onPressed: (){
                  // print('Showing About us screen');
                  Navigator.push(context, CupertinoPageRoute(builder: (context)=>DevelopersPage(),
                     ),);
                },
              ),
              Divider(height: (0.122*SizeConfig.heightMultiplier).roundToDouble(),color: CupertinoColors.inactiveGray,),
              CupertinoButton(
                padding: EdgeInsets.only(left: (SizeConfig.one_W*10).roundToDouble()),
                child: CupertinoTile(
                  title: 'Log out',
                ),
                onPressed: (){
                  confirmDeleteAlert(context);
                },
              ),
              Divider(height: (0.122*SizeConfig.heightMultiplier).roundToDouble(),color: CupertinoColors.inactiveGray,),
            ],
          )
      ),
    );
  }

}



///
///
///edit Profile Card
class ProfileCard extends StatelessWidget {
  ProfileCard({
    this.user,
  });
  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: (2.45*SizeConfig.heightMultiplier).roundToDouble(),
          horizontal: (5.1*SizeConfig.widthMultiplier).roundToDouble()),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user.photoURL),
            radius: (7.14*SizeConfig.widthMultiplier).roundToDouble(),
          ),
          SizedBox(
            height: (0.24*SizeConfig.heightMultiplier).roundToDouble(),
          ),
          Text(
            user.displayName,
            style: TextStyle(fontWeight: FontWeight.w500,fontSize: (2.20*SizeConfig.textMultiplier.roundToDouble())),
          ),
          SizedBox(height: (0.24*SizeConfig.heightMultiplier).roundToDouble(),),
          Text(user.email, style: TextStyle(fontSize: (1.47*SizeConfig.textMultiplier).roundToDouble(),),),
        ],
      ),
      decoration: BoxDecoration(

      ),
    );
  }
}

class CupertinoTile extends StatelessWidget {
  CupertinoTile({
    this.title,
  });

  final String title;


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle.color
              ),
        ),
        Icon(CupertinoIcons.forward)
      ],
    );
  }
}
