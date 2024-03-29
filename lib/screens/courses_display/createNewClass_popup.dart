import 'package:attendo/modals/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';

//Media Query r2d

final coursesRef = FirebaseFirestore.instance.collection('coursesDetails');
final userRef = FirebaseFirestore.instance.collection('users');

class CreateNewClass extends StatefulWidget {
  CreateNewClass({this.currentUser, this.toggleScreenCallBack});

  final User currentUser;

  ///this is a callback, which is called when we press createNewClass,
  ///this chances the [NO CREATED CLASS screen] to LIST_OF_CREATED_CLASSES SCREEN
  final Function toggleScreenCallBack;

  @override
  _CreateNewClassState createState() => _CreateNewClassState();
}

class _CreateNewClassState extends State<CreateNewClass> {
  //variables to create a new Course
  String courseName;
  String yearOfBatch;
  String courseCode;
  String teacherImageUrl;

  String imagePath;
  // FToast fToast;

  ///list of ImagePaths which are used for creating new CardWidgets
  List<String> imagePaths = [
    'assets/images/artWork/art01.jpg',
    'assets/images/artWork/art02.jpg',
    'assets/images/artWork/art03.jpg',
    'assets/images/artWork/art04.jpg',
    'assets/images/artWork/art01.jpg',
  ];
  int randomIntForImage;

  //TODO: generateNonRepeatativeRandomNumber

  String getRandomImg(List<String> imageList, int randomInt) {
    return imageList[randomInt];
  }

  ///this data has CourseDetails
  ///When user create new Course this data is uploaded
  uploadCourseDataToCloud({
    String nameOfCourse,
    String codeOfCourse,
    String year,
    String imagePath,
  }) async {
    ///this will upload to a Universal Collections of all Courses
    coursesRef.doc(courseCode).set({
      'courseName': nameOfCourse,
      'courseCode': codeOfCourse,
      'createdBy': widget.currentUser.displayName,
      'yearOfBatch': year,
      'imagePath': imagePath,
      'teacherImageUrl': widget.currentUser.photoURL,
      'isCourseDeletedByTeacher': false,
      'totalStudents': 0,
      'totalClasses': 0
    });

    ///this will upload to User Collection > CoursesCreated >
    ///means Only courses created by that particular user
    userRef
        .doc(widget.currentUser.uid.toString())
        .collection('createdCoursesByUser')
        .doc(courseCode)
        .set({
      "courseName": nameOfCourse,
      'courseCode': codeOfCourse,
      'createdBy': widget.currentUser.displayName,
      'imagePath': imagePath,
      'yearOfBatch': year,
      'teacherImageUrl': widget.currentUser.photoURL,
      'totalStudents': 0,
      'totalClasses': 0

    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        resizeToAvoidBottomInset: true,
          navigationBar: CupertinoNavigationBar(
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: Text('Create'),
              onPressed: () {
                _onCreateButtonPressed();
              },
            ),
          ),
          child: Container(
            padding: EdgeInsets.only(
              top: (1.96*SizeConfig.heightMultiplier).roundToDouble(),
                bottom: (6.12*SizeConfig.heightMultiplier).roundToDouble(),
                left: (6.37*SizeConfig.widthMultiplier).roundToDouble(),
                right: (6.37*SizeConfig.widthMultiplier).roundToDouble(),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular((5.1*SizeConfig.widthMultiplier).roundToDouble()),
                topRight: Radius.circular((5.1*SizeConfig.widthMultiplier).roundToDouble()),
              ),
            ),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(
                //   height: (4.90*SizeConfig.heightMultiplier).roundToDouble(),
                // ),
                Text(
                  'Course Name',
                ),
                SizedBox(
                  height: (0.61*SizeConfig.heightMultiplier).roundToDouble(),
                ),
                CupertinoTextField(
                  placeholder: 'Enter Course Name',
                  onChanged: (String newValue) {
                    return courseName = newValue;
                  },
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: (0.61*SizeConfig.heightMultiplier).roundToDouble(),
                ),
                Text(
                  'Batch/Class Description',
                ),
                SizedBox(
                  height: (0.61*SizeConfig.heightMultiplier).roundToDouble(),
                ),
                CupertinoTextField(
                  placeholder: 'Enter Batch Year or Class',
                    // keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    onChanged: (String newValue) {
                      return yearOfBatch = (newValue);
                    }),
                SizedBox(
                  height: (1.96*SizeConfig.heightMultiplier).roundToDouble(),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'IMPORTANT',
                        style: TextStyle(color: CupertinoColors.destructiveRed),
                      ),
                      SizedBox(
                        height: (0.46*SizeConfig.heightMultiplier).roundToDouble(),//4
                      ),
                      Text(
                          '1. Enter a CourseName for your class and class description.'),
                      SizedBox(
                        height: (1.22*SizeConfig.heightMultiplier).roundToDouble(),//10
                      ),
                      Text(
                          "2. A Code for your class will be provided to you which you can share"
                          " with your class so Students can join, you can also add students manually"),
                    ],
                  ),
                )
              ],
            ),
          )
    );
  }

  ///TODO: later make a general class and transfer all these little functions to that class
  showNoticeDialog(){

    Navigator.of(context).push(
      PageRouteBuilder(
          pageBuilder: (context, _, __) =>  CupertinoAlertDialog(
            // title: Text("Note"),
            content: Text("Please fill out CourseName as well as Batch before creating new class."),
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

  regenerateTheRandomCode(){
    //generate Random courseCode
    int classCode = 9999 + Random().nextInt(99999 - 9999);
    courseCode = classCode.toString();

    //generated a random int which is passed through ImageList index
    //TODO: make a function so that images don't ListOfCourseCard
    //min + Random().nextInt(max-min);
    //this is for card image selection
    randomIntForImage = 0 + Random().nextInt(3 - 0);
  }


  ///making _onCreateButtonPressed
  _onCreateButtonPressed() async{
    regenerateTheRandomCode();
    //checkIfTheGeneratedCodeAlreadyExist();
    final courseDoc = await coursesRef.doc(courseCode).get();

    if (courseDoc.exists){
      _onCreateButtonPressed();
    }
    else {
      ///
      ///
      /// print('creating new class...');

      ///here many things are happening
      ///1. gerating a random int to select a Image for card
      ///and random code for the course.
      ///2.Uploading data to firebase, after check if anything is not null
      ///TODO: random number can generate repetative random numbers so we
      ///have to make another function to takle that

      if (yearOfBatch != null && courseName != null) {
        ///adding the courseCode to the ListOfCourseCodes
        ///later when we will join class, we will check in this list
        ///whether the enteredCode exists or not
        ///Later we will check enteredCode in database


        Navigator.pop(context);

        ///toast msg when any field is left and create class is pressed

        try{
          ///this part is uploading course details as a Document to fireStore
          ///whose ID is set as CourseCode.
          uploadCourseDataToCloud(
              codeOfCourse: courseCode,
              nameOfCourse: courseName,
              year: yearOfBatch,
              imagePath: getRandomImg(imagePaths, randomIntForImage));

          Fluttertoast.showToast(
              msg: "New course added",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: CupertinoTheme.of(context).primaryColor,
              textColor: CupertinoColors.white,
              fontSize: 16.0
          );
        } catch(e){

          Fluttertoast.showToast(
              msg: "Unexpected Error, try again",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: CupertinoTheme.of(context).primaryColor,
              textColor: CupertinoColors.white,
              fontSize: 16.0
          );

        }

      } else{
        showNoticeDialog();
      }
    }

  }

}

