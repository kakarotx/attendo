import 'package:attendo/screens/other_screens/help_dart.dart';
import 'package:attendo/screens/particular_course_pages/set_roll_no.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final userRef = FirebaseFirestore.instance.collection('users');

class UserProfile extends StatefulWidget {
  UserProfile({this.user, this.toggleTheme});

  final User user;
  final Function toggleTheme;

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
  String rollNo;
  String enteredRollNumber;

  updateData(){
    userRef.doc(widget.user.uid).update({
      'rollNo': enteredRollNumber,
    });
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
              onPressed: _signOut,
              child: Text('Logout', style: TextStyle(color: CupertinoColors.activeBlue),)),
        ),
        child: listOfOptions(),
    );
  }

  ///here we are displaying List of all different options under setting
  listOfOptions(){
    return(
        ListView(
          children: [
            StreamBuilder(
              stream: userRef.doc(widget.user.uid).snapshots(),
              builder: (context, snapshot){
                if(!snapshot.hasData){
                  return CupertinoActivityIndicator();
                } else
                  {
                    final rollNo = snapshot.data['rollNo'];
                    return EditProfileCard(user: widget.user,rollNo:rollNo,);
                  }
              },
            ),
            Divider(height: 1,color: CupertinoColors.inactiveGray,),
            GestureDetector(
              // padding: EdgeInsets.zero,
              child: CupertinoTile(
                // addPadding: false,
                title: 'Add RollNo. (if student)',
                trailingWidget: Icon(CupertinoIcons.forward),
              ),
              onTap: (){
                print('opening editing page');
                Navigator.push(context, CupertinoPageRoute(
                  fullscreenDialog: true,
                  builder: (context)=>SetRollNoPage(user: widget.user,)
                ));
                // setAttendenceDialog();
              },
            ),
            Divider(height: 0.3,color: CupertinoColors.inactiveGray,),
            Divider(height: 1,color: CupertinoColors.inactiveGray,),
            GestureDetector(
              onTap: widget.toggleTheme,
              child: CupertinoTile(
                title: 'Switch Theme',
                trailingWidget: Icon(CupertinoIcons.forward),
              ),
            ),
            Divider(height: 1,color: CupertinoColors.inactiveGray,),
            GestureDetector(
              // padding: EdgeInsets.zero,
              child: CupertinoTile(
                // addPadding: false,
                title: 'Help',
                trailingWidget: Icon(CupertinoIcons.forward),
              ),
              onTap: (){
                print('Help');
                Navigator.push(context, CupertinoPageRoute(builder: (context)=>HelpPage(),),);
              },
            ),
            Divider(height: 1,color: CupertinoColors.inactiveGray,),
            GestureDetector(
              // padding: EdgeInsets.zero,
              child: CupertinoTile(
                // addPadding: false,
                title: 'About us',
                trailingWidget: Icon(CupertinoIcons.forward),
              ),
              onTap: (){
                print('Showing About us screen');
                Navigator.push(context, CupertinoPageRoute(builder: (context)=>HelpPage(),
                   ),);
              },
            ),
            Divider(height: 1,color: CupertinoColors.inactiveGray,),
          ],
        )
    );
  }


  setAttendenceDialog(){
    Navigator.of(context).push(
      PageRouteBuilder(
          pageBuilder: (context, _, __) => CupertinoAlertDialog(
            // title: Text("Note"),
            content: CupertinoTextField(
              placeholder: 'Roll No/Enrollment No.',
              onChanged: (value){
                enteredRollNumber=value;
              },
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                  onPressed: () {
                    updateData();
                    Navigator.pop(context);
                  },
                  child: Text("Set")),

              CupertinoDialogAction(
                  onPressed: () {
                    updateData();
                    Navigator.pop(context);
                  },
                  child: Text("Cancel",style: TextStyle(color: CupertinoColors.destructiveRed),)),
            ],
          ),
          opaque: false),
    );

  }

}



///
///
///edit Profile Card
class EditProfileCard extends StatelessWidget {
  EditProfileCard({
    this.user,this.rollNo
  });
  final String rollNo;
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
            style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),
          ),
          SizedBox(height: 2,),
          Text(user.email, style: TextStyle(fontSize: 12,),),
          SizedBox(
            height: 2,
          ),
          rollNo==null?Container():Text(
            'Roll No: $rollNo',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
      decoration: BoxDecoration(

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
                ),
          ),
          trailingWidget
        ],
      ),
      decoration: BoxDecoration(
        // color: CupertinoColors.lightBackgroundGray,
      ),
    );
  }
}
