import 'package:attendo/modals/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

//Media Query r2d

final userRef = FirebaseFirestore.instance.collection('users');
final courseRef = FirebaseFirestore.instance.collection('coursesDetails');

///to join already created classes by others
class JoinNew extends StatefulWidget {
  JoinNew({this.user});

  final User user;

  @override
  _JoinNewState createState() => _JoinNewState();
}

class _JoinNewState extends State<JoinNew> {
  String enteredClassCode;
  CollectionReference courseRef;
  String courseName;
  String yearOfBatch;
  String courseCode;
  String imagePath;
  String teacherName;
  String teacherImageUrl;

  getCourseDataFor({String enteredClassCode}) async {
    //checking if the class is created by same user so that he/she can't join their own class
    final usersData = await userRef
        .doc(widget.user.uid)
        .collection('createdCoursesByUser')
        .doc(enteredClassCode)
        .get();
    final bool isClassCreatedByTheSameUser = !usersData.exists;

    final DocumentSnapshot courseData =
        await courseRef.doc(enteredClassCode).get();
    if (isClassCreatedByTheSameUser) {
      if (courseData.exists) {
        try {
          courseName = courseData.data()['courseName'];
          courseCode = courseData.data()['courseCode'];
          yearOfBatch = courseData.data()['yearOfBatch'];
          imagePath = courseData.data()['imagePath'];
          teacherName = courseData.data()['createdBy'];
          teacherImageUrl = courseData.data()['teacherImageUrl'];
          // print('this is $courseName');
        } catch (e) {
          // print('qwerty error::::$e');
        }
      }
    } else {}
  }

  int _totalClassesTillNow = 0;

  ///user>ClassJoinedByUser>
  uploadJoinedClassDataToCloud(
      {String courseName,
      String courseCode,
      String imagePath,
      String yearOfBatch}) async {
    final DocumentSnapshot doc = await courseRef.doc(enteredClassCode).get();

    if (doc.exists) {
      _totalClassesTillNow = doc.data()['totalClasses'];

      userRef
          .doc(widget.user.uid)
          .collection('joinedCoursesByUser')
          .doc(courseCode)
          .set({
        "courseName": courseName,
        'courseCode': courseCode,
        'createdBy': teacherName,
        'imagePath': imagePath,
        'yearOfBatch': yearOfBatch,
        'absent': 0,
        'present': 0,
        'totalClasses': _totalClassesTillNow
      });
    }
  }

  ///adding student to course
  addStudentToTheCloud({String courseCode}) async {
    final doc = await courseRef.doc(courseCode).get();

    if (doc.exists) {
      courseRef
          .doc(courseCode)
          .collection('studentsEnrolled')
          .doc(widget.user.uid)
          .set({
        "emailId": widget.user.email,
        "studentName": widget.user.displayName,
        "studentPhotoUrl": widget.user.photoURL,
        "studentId": widget.user.uid,
        "absent": 0,
        "present": 0,
        'totalClasses': _totalClassesTillNow
      });

      ///totalStudent++
      courseRef.doc(courseCode).update({
        'totalStudents': FieldValue.increment(1)
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    courseRef = FirebaseFirestore.instance.collection('coursesDetails');
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text('Join'),
          onPressed: _onJoinButtonPressed,
        ),
      ),
      resizeToAvoidBottomInset: false,
      child: Container(
        padding: EdgeInsets.only(
          top: (1.96 * SizeConfig.heightMultiplier).roundToDouble(),
          bottom: (6.12 * SizeConfig.heightMultiplier).roundToDouble(),
          left: (6.37 * SizeConfig.widthMultiplier).roundToDouble(),
          right: (6.37 * SizeConfig.widthMultiplier).roundToDouble(),
        ),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ClassCode',
            ),
            SizedBox(
              height: (0.61*SizeConfig.heightMultiplier).roundToDouble(),
            ),
            CupertinoTextField(
              keyboardType: TextInputType.number,
              placeholder: 'Enter Class Code',
              textAlign: TextAlign.center,
              onChanged: (String newValue) {
                enteredClassCode = newValue;
              },
              // textAlign: TextAlign.center,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: (SizeConfig.one_H * 20).roundToDouble(),
                  ),
                  Text(
                    'NOTE',
                    style: TextStyle(color: CupertinoColors.destructiveRed),
                  ),
                  SizedBox(
                    height: (SizeConfig.one_H * 4).roundToDouble(),
                  ),
                  Text(
                      '1. Ask your teacher for Class Code and enter it to join the class.'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _onJoinButtonPressed() async {


    //checking if the class is created by same user so that he/she can't join their own class
    final usersData = await userRef
        .doc(widget.user.uid)
        .collection('createdCoursesByUser')
        .doc(enteredClassCode)
        .get();

    final bool isClassCreatedByTheSameUser = usersData.exists;

    if (enteredClassCode != null) {
      final courseDocs = await courseRef.doc(enteredClassCode).get();
      if (!courseDocs.exists) {
        showNoticeDialog("Enter Valid Course Code.");
      } else {
        if (isClassCreatedByTheSameUser) {
          showNoticeDialog('You cannot join the class created by you');
        } else {
          ///getting the data of the particular course through ENTERED CODE
          await getCourseDataFor(enteredClassCode: enteredClassCode);

          ///uploading the same data to Cloud
          try {
            uploadJoinedClassDataToCloud(
                courseName: courseName,
                courseCode: courseCode,
                yearOfBatch: yearOfBatch,
                imagePath: imagePath);

            ///adding Student to the Particular Course

            addStudentToTheCloud(courseCode: courseCode);
            Fluttertoast.showToast(
                msg: "Course joined",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: CupertinoTheme.of(context).primaryColor,
                textColor: CupertinoColors.white,
                fontSize: 16.0);
          } catch (e) {
            Fluttertoast.showToast(
                msg: "Unexpected Error, try again",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: CupertinoTheme.of(context).primaryColor,
                textColor: CupertinoColors.white,
                fontSize: 16.0);
          }
          // print('joining new course');

          ///the provider part that was here is commented below, OUTSIDE THE CLASS

          ///now we are using Data on Cloud

          Navigator.pop(context);
        }
      }
    } else {
      showNoticeDialog("Enter Valid Course Code.");
    }
  }

  showNoticeDialog(String message) {
    Navigator.of(context).push(
      PageRouteBuilder(
          pageBuilder: (context, _, __) => CupertinoAlertDialog(
                title: Text("Note"),
                content: Text(message),
                actions: <Widget>[
                  CupertinoDialogAction(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Okays")),
                ],
              ),
          opaque: false),
    );
  }
}
