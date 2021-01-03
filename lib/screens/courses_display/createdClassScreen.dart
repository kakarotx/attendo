import 'package:attendo/modals/course_class.dart';
import 'package:attendo/screens/courses_display/createNewClass_popup.dart';
import 'package:attendo/screens/particular_course_pages/teacher_course_home_screen.dart';
import 'package:attendo/widgets/card_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//MediaQuery r2d

final userRef = FirebaseFirestore.instance.collection('users');
final courseRef = FirebaseFirestore.instance.collection('coursesDetails');


///this Screen displays all the created classes by user
class CreatedClassScreen extends StatefulWidget {
  CreatedClassScreen({this.user});
  final User user;
  @override
  _CreatedClassScreenState createState() => _CreatedClassScreenState();
}

class _CreatedClassScreenState extends State<CreatedClassScreen> {
  List<CardWidget> listOfCourses;

  @override
  Widget build(BuildContext context) {
    return
      CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        child: NestedScrollView(
          headerSliverBuilder: (context, bool innerBoxIsScrolled) {
            return [
              CupertinoSliverNavigationBar(
                largeTitle: Text('Courses'),
                trailing: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Text(
                      'Create'
                  ),
                  onPressed: () async {
                    // print('+ pressed');
                    Navigator.push(context, CupertinoPageRoute(
                        builder: (context) =>
                            CreateNewClass(currentUser: widget.user,),
                        fullscreenDialog: true),);
                  },
                ),
              ),
            ];
          },
          body: buildCourseCards(),),

        ///TODO: ZeroClass Screen to be made
        ///and it will be controlled here with a bool
      );
  }


  ///building List of CustomCards of Courses after  we add a course
  buildCourseCards() {
    //courseRef.snapshots(),
    return StreamBuilder<QuerySnapshot>(
      stream:userRef.doc(widget.user.uid).collection('createdCoursesByUser').orderBy('courseName',descending: false).snapshots(),
        builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CupertinoActivityIndicator();
        } else {
          List<Hero> cardWidgets = [];
          if(snapshot.data.docs.isEmpty){
            return Container(
              child: Image.asset('assets/images/createNewClass.png',),
            );
          }
          else{
            final courses = snapshot.data.docs;
            for (var course in courses) {
              final courseData = course.data();
              final courseName = courseData['courseName'];
              final courseCode = courseData['courseCode'];
              final yearOfBatch = courseData['yearOfBatch'];
              final imagePath = courseData['imagePath'];
              final teacherName = courseData['createdBy'];
              final teacherImageUrl= courseData['teacherImageUrl'];
              cardWidgets.add(
                Hero(
                  tag: courseCode,
                  child: CardWidget(
                    newCourse: Course(
                        teacherImageUrl: teacherImageUrl,
                        teacherName: teacherName,
                        courseName: courseName,
                        courseCode: courseCode,
                        imagePath: imagePath,
                        yearOfBatch: yearOfBatch.toString()),
                    onCardTab: (){
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => CourseHomePageForTeacher(
                            user: widget.user,
                            course: Course(
                                teacherImageUrl: teacherImageUrl,
                                teacherName: teacherName,
                                courseName: courseName,
                                courseCode: courseCode,
                                imagePath: imagePath,
                                yearOfBatch: yearOfBatch.toString()),),),
                      );
                    },
                  ),
                ),
              );
            }

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
