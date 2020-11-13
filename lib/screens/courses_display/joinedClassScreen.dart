import 'package:attendo/modals/list_of_course_details.dart';
import 'package:attendo/screens/courses_display/create_list_of_joined_class.dart';
import 'package:attendo/screens/courses_display/joinNewClass_popup.dart';
import 'package:attendo/screens/courses_display/zero_class_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';


///this screen displays all the classes joined by you
final _fireStore = FirebaseFirestore.instance;

class JoinedClassScreen extends StatefulWidget {
  @override
  _JoinedClassScreenState createState() => _JoinedClassScreenState();
}

class _JoinedClassScreenState extends State<JoinedClassScreen> {
  List<Text> coursesList = [];

  bool zeroJC = true;

  ///this function will toggle the ZeroCC screen
  void toggleZeroCCScreen(){
    if(Provider.of<ListOfCourseDetails>(context, listen: false).
    finalListOfJoinedCourses.length==0){
      setState(() {
        zeroJC = true;
      });
    } else{
      setState(() {
        zeroJC = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: CupertinoPageScaffold(
        child: NestedScrollView(
            headerSliverBuilder:(context, bool innerBoxIsScrolled)
            {
              return [
                CupertinoSliverNavigationBar(

                  largeTitle: Text('Enrolled'),
                  trailing: CupertinoButton(
                    padding: EdgeInsets.only(bottom: 2),
                    child: Icon(
                      CupertinoIcons.add,
                      // size: 20,
                    ),
                    onPressed: () {
                      showCupertinoModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) => JoinNewClassScreen(toggleScreenCallBack: toggleZeroCCScreen,),
                      );
                    },
                  ),                                                              ////,
                ),
              ];
            },
           body: zeroJC ? ZeroClassScreen(title: 'NO CLASS JOINED',):BuildListOfJoinedClasses(),

      ),
      // child:
    ));
  }
}

///LongPressEndDetails


