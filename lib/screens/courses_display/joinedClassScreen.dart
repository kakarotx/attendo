import 'package:attendo/modals/course_class.dart';
import 'package:attendo/screens/courses_display/joinNewClass_popup.dart';
import 'package:attendo/screens/particular_course_pages/student_course_home_page.dart';
import 'package:attendo/widgets/card_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';


///this screen displays all the classes joined by you
// final _fireStore = FirebaseFirestore.instance;

class JoinedClassScreen extends StatefulWidget {
  JoinedClassScreen({this.user});
  final User user;
  @override
  _JoinedClassScreenState createState() => _JoinedClassScreenState();
}

class _JoinedClassScreenState extends State<JoinedClassScreen> {
  List<Text> coursesList = [];
  Course joinedCourse;

  bool zeroJC = true;

  ///this function will toggle the ZeroCC screen
  void toggleZeroCCScreen(){
  }


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
        child: NestedScrollView(
            headerSliverBuilder:(context, bool innerBoxIsScrolled)
            {
              return [
                CupertinoSliverNavigationBar(

                  largeTitle: Text('Enrolled'),
                  trailing: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async{
                      joinedCourse =
                      await showCupertinoModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) => JoinNewClassPopup(toggleScreenCallBack: toggleZeroCCScreen,user: widget.user,),
                      );
                    },
                    child: Text('Join'),
                  ),                                                              ////,
                ),
              ];
            },
           body:buildListOfJoinedClass(),

      ),
      // child:
    );
  }




  buildListOfJoinedClass() {
      ///
      return StreamBuilder<QuerySnapshot>(
        stream:userRef.doc(widget.user.uid).collection('joinedCoursesByUser').snapshots(),
        builder: (context, snapshot,) {
          if (!snapshot.hasData) {
            return CupertinoActivityIndicator();
          } else {
            final courses = snapshot.data.docs;
            List<CardWidget> cardWidgets = [];
            for (var course in courses) {
              final courseData = course.data();
              final courseName = courseData['courseName'];
              final courseCode = courseData['courseCode'];
              final yearOfBatch = courseData['yearOfBatch'];
              final imagePath = courseData['imagePath'];
              final teacherName = courseData['createdBy'];
              final teacherImageUrl = courseData['teacherImageUrl'];
              cardWidgets.add(
                CardWidget(
                  newCourse: Course(
                      teacherImageUrl: teacherImageUrl,
                      teacherName: teacherName,
                      courseName: courseName,
                      courseCode: courseCode,
                      imagePath: imagePath,
                      yearOfBatch: yearOfBatch.toString()),
                  onCardTab: (){
                    Navigator.push(context, CupertinoPageRoute(builder: (context){
                      return CourseHomePageForStudent(
                        user: widget.user,
                        course:  Course(
                            teacherImageUrl: teacherImageUrl,
                            teacherName: teacherName,
                            courseName: courseName,
                            courseCode: courseCode,
                            imagePath: imagePath,
                            yearOfBatch: yearOfBatch.toString()),);
                    }));
                  },
                ),
              );
            }
            return ListView.builder(
                itemCount: cardWidgets.length,
                itemBuilder:(context, int){
                  return cardWidgets[int];
                }
            );
          }
        },
      );

    }


  }

///LongPressEndDetails


