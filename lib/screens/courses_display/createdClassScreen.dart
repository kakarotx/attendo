import 'package:attendo/modals/course_class.dart';
import 'package:attendo/screens/courses_display/createNewClass_popup.dart';
import 'package:attendo/screens/particular_course_pages/teacher_course_home_screen.dart';
import 'package:attendo/widgets/card_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  ///when there will be no classes, we will show [NO CLASSES, CREATE NEW];
  ///zeroCC = zero_created_classes
  ///this above variable will toggle that screen
  bool zeroCC = true;

  ///this function will toggle the ZeroCC screen
  void toggleZeroCCScreen() {
    //TODO: this is where we will toggle ZeroClass Screen
  }


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
                        // size: 20,
                      ),
                      onPressed: () async {
                        print('+ pressed');
                        Navigator.push(context, CupertinoPageRoute(
                            builder: (context)=>CreateNewClass(currentUser: widget.user,),fullscreenDialog: true));
                        // await showCupertinoModalBottomSheet<Course>(
                        //   context: context,
                        //   builder: (context) => CreateNewClassPopUp(
                        //     toggleScreenCallBack: toggleZeroCCScreen,
                        //     currentUser: widget.user,
                        //   ),
                        // );
                      },
                    ),
                  ),
                ];
              },
              body:buildCourseCards()),
              ///TODO: ZeroClass Screen to be made
            ///and it will be controlled here with a bool
        // child:

      );
  }

  deleteTheCourse(BuildContext context, Course course){
    confirmDeleteAlert(context, course);
  }

  ///this will show a Dailog after we press delete Course button
  ///which has 2 options, [cancel] and [delete]
  void confirmDeleteAlert(BuildContext context, Course course) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Confirm delete"),
            content: Text("Do you want to delete the Course?"),
            actions: <Widget>[
              CupertinoDialogAction(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              CupertinoDialogAction(
                  textStyle: TextStyle(color: CupertinoColors.destructiveRed),
                  // isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                    addCourseDataToDeletedCourseCollection(course);
                    deleteTheCourseFromCloud(course);
                  },
                  child: Text("Delete")),
            ],
          );
        });
  }

  ///we are the deleting the Course from [CoursesDetails] collection
  void deleteTheCourseFromCloud(Course course) {
    courseRef.doc(course.courseCode).delete();
    userRef.doc(widget.user.uid).collection('createdCoursesByUser').doc(course.courseCode).delete();
  }

  ///I made a Collection on firebase [DeletedCourses],
  ///because Student have to be notified that the class is deleted
  ///ON Student PAGE, I have implemented a logic which checks if
  ///the Document with the COURSE CODE exists on [DeletedCourses]
  addCourseDataToDeletedCourseCollection(Course course){
    deletedCoursesRef.doc(course.courseCode).set({
      'courseName': course.courseName,
      'teacherName': course.teacherName
    });
  }


  ///building List of CustomCards of Courses after  we add a course
  buildCourseCards() {
    //courseRef.snapshots(),
    return StreamBuilder<QuerySnapshot>(
      stream:userRef.doc(widget.user.uid).collection('createdCoursesByUser').orderBy('courseName').snapshots(),
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
