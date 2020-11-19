import 'package:attendo/modals/course_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
//style
const bottomDrawerStyle =
    TextStyle(color: CupertinoColors.black, fontSize: 20, fontWeight: FontWeight.bold);

final userRef = FirebaseFirestore.instance.collection('users');
final courseRef = FirebaseFirestore.instance.collection('coursesDetails');
///to join already created classes by others
class JoinNewClassPopup extends StatefulWidget {
  JoinNewClassPopup({this.toggleScreenCallBack, this.user});
  final Function toggleScreenCallBack;
  final User user;

  @override
  _JoinNewClassPopupState createState() => _JoinNewClassPopupState();
}

class _JoinNewClassPopupState extends State<JoinNewClassPopup> {
  String enteredClassCode;
  CollectionReference courseRef;
  String courseName;
  String yearOfBatch;
  String courseCode;
  String imagePath;
  String teacherName;
  String teacherImageUrl;

  getCourseDataFor({String enteredClassCode}) async {
    final DocumentSnapshot courseData =
        await courseRef.doc(enteredClassCode).get();

    try {
      courseName = courseData.data()['courseName'];
      courseCode = courseData.data()['courseCode'];
      yearOfBatch = courseData.data()['yearOfBatch'];
      imagePath = courseData.data()['imagePath'];
      teacherName = courseData.data()['createdBy'];
      teacherImageUrl = courseData.data()['teacherImageUrl'];
      print('this is $courseName');
    } catch (e) {
      print('qwerty error::::$e');
    }
  }

  ///user>ClassJoinedByUser>
  uploadJoinedClassDataToCloud({String courseName,String courseCode,String imagePath,String yearOfBatch}){
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
    });
  }

  addStudentToTheCloud({String courseCode}){
    courseRef.doc(courseCode)
        .collection('studentsEnrolled')
        .doc(widget.user.uid)
        .set({
      "emailId": widget.user.email,
      "studentName": widget.user.displayName,
      "studentPhotoUrl": widget.user.photoURL
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    courseRef = FirebaseFirestore.instance.collection('coursesDetails');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 50, horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Join New Class',
            ),
          ),
          SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Text(
                'ClassCode :  ',
              ),
              Expanded(
                child: CupertinoTextField(
                  textAlign: TextAlign.center,
                  onChanged: (String newValue) {
                    enteredClassCode = newValue;
                  },
                  // textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Center(
            child: CupertinoButton.filled(
              onPressed: _onJoinButtonPressed,
              child: Text(
                'Join Class',
              ),
            ),
          )
        ],
      ),
    );
  }

  _onJoinButtonPressed() async {
    
    ///getting the data of the particular course through ENTERED CODE
    await getCourseDataFor(enteredClassCode: enteredClassCode);
    
    ///uploading the same data to Cloud
    uploadJoinedClassDataToCloud(
      courseName: courseName,
      courseCode: courseCode,
      yearOfBatch: yearOfBatch,
      imagePath: imagePath
    );
    
    ///adding Student to the Particular Course
    addStudentToTheCloud(courseCode: courseCode);
    print('joining new course');
    
    ///the provider part that was here is commented below, OUTSIDE THE CLASS

    ///now we are using Data on Cloud

    widget.toggleScreenCallBack();
    Navigator.pop(context, Course(
      teacherName: teacherName,
      imagePath: imagePath,
      yearOfBatch: yearOfBatch,
      courseCode: courseCode,
      courseName: courseName,
      teacherImageUrl: teacherImageUrl
    ));
  }
}

///provider part
// if(Provider.of<ListOfCourseDetails>(context, listen: false).listOfAllCourseCodes.contains(enteredClassCode))
// {
// //storing the index of courseCode and
// int indexOfCode = Provider.of<ListOfCourseDetails>(context, listen: false).listOfAllCourseCodes.indexOf(enteredClassCode);
// //storing that specific CardWidget to local Variable
// CardWidget cardOfNewJoinClass=Provider.of<ListOfCourseDetails>(context, listen: false).finalListOfCreatedCourses[indexOfCode];
// //and adding it to the NewListOfJoinedClasses
// Provider.of<ListOfCourseDetails>(context, listen: false).addItemToJoinedCoursesList(cardOfNewJoinClass);
// }
