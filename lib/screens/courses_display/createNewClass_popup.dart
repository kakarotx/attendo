import 'package:attendo/modals/course_class.dart';
import 'package:attendo/widgets/card_widget.dart';
import 'package:attendo/modals/list_of_course_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


final coursesRef = FirebaseFirestore.instance.collection('coursesDetails');

//style
const bottomDrawerStyle =
    TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold);

///this is popUp_Screen to create New class
class CreateNewClassScreen extends StatefulWidget {
  CreateNewClassScreen({this.toggleScreenCallBack});

  ///this is a callback, which is called when we press createNewClass,
  ///this chances the [NO CREATED CLASS screen] to LIST_OF_CREATED_CLASSES SCREEN
  final Function toggleScreenCallBack;

  @override
  _CreateNewClassScreenState createState() => _CreateNewClassScreenState();
}

class _CreateNewClassScreenState extends State<CreateNewClassScreen> {

  //variables to create a new Course
  String courseName;
  String yearOfBatch;
  int courseCode;
  //variables for Generating a new non-repeating Random Integer
  List<int> randomIntList = [];

  ///list of ImagePaths which are used for creating new CardWidgets
  List<String> imagePaths = [
      'assets/images/artWork/art01.jpg',
      'assets/images/artWork/art02.jpg',
      'assets/images/artWork/art03.jpg',
    ];

    //TODO: generateNonRepeatativeRandomNumber

    String getRandomImg(List<String> imageList, int randomInt) {
      return imageList[randomInt];
    }

    String imagePath;

    FToast fToast;

    @override
    void initState() {
      super.initState();
      fToast = FToast();
      fToast.init(context);
    }

    _showToast({String toastMsg, IconData toastIcon}) {
      Widget toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.black,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              toastIcon,
              color: Colors.white,
            ),
            SizedBox(
              width: 12.0,
            ),
            Text(
              toastMsg,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
      fToast.showToast(
        child: toast,
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 2),
      );
    }

    uploadCourseDataToCloud({String nameOfCourse,int codeOfCourse, String year})async{
      final DocumentSnapshot courseDoc = await coursesRef.doc(courseCode.toString()).get();
      coursesRef.doc(courseCode.toString()).set({
        'courseName': nameOfCourse,
        'courseCode': codeOfCourse,
        'yearOfBatch': year,
      });

    }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF737373),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  'Course :',
                  style: bottomDrawerStyle.copyWith(fontSize: 20),
                ),
                Expanded(
                  child: TextField(
                    onChanged: (String newValue) {
                      return courseName = newValue;
                    },
                    style: bottomDrawerStyle,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Enter Course Name',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  'Batch : ',
                  style: bottomDrawerStyle,
                ),
                Expanded(
                  child: TextField(
                    onChanged: (String newValue) {
                      return yearOfBatch = (newValue);
                    },
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Enter Year',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: RaisedButton(
                onPressed: () {
                  print('creating new class');
                  //generate Random courseCode
                  courseCode = 9999 + Random().nextInt(99999 - 9999);

                  //generated a random int which is passed through ImageList index
                  //TODO: make a function so that images don't ListOfCourseCard
                  //min + Random().nextInt(max-min);
                  //this is for card image selection
                  int randomInt = 0 + Random().nextInt(3 - 0);


                  if (yearOfBatch != null && courseName != null) {

                    ///adding the courseCode to the ListOfCourseCodes
                    ///later when we will join class, we will check in this list
                    ///whether the enteredCode exists or not
                    ///Later we will check enteredCode in database
                    Provider.of<ListOfCourseDetails>(context, listen: false).
                        addItemToCourseCodeList(courseCode.toString());

                    ///adding the Course Object to the ListOfCard
                    Provider.of<ListOfCourseDetails>(context, listen: false).addItemToCourseList(
                      CardWidget(
                        newCourse: Course(
                            yearOfBatch: yearOfBatch,
                            courseCode: courseCode,
                            courseName: courseName),
                        imagePath: getRandomImg(imagePaths, randomInt),
                      ),
                    );
                    widget.toggleScreenCallBack();
                    _showToast(
                        toastMsg: 'Class Created', toastIcon: Icons.check);
                  }
                  Navigator.pop(context);

                  ///toast msg when any field is left and create class is pressed
                  _showToast(
                      toastMsg: 'Enter Valid Details', toastIcon: Icons.warning);

                  ///this part is uploading course details as a Document to fireStore
                  ///whose ID is set as CourseCode.
                  uploadCourseDataToCloud(
                    codeOfCourse: courseCode,
                    nameOfCourse: courseName,
                    year: yearOfBatch
                  );
                },
                child: Text(
                  'Create Class',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}


///DANGER AHEAD-
//TODO: create a non repeating random number function
//outside of class
//failed attempt to create a RandomGenerator
//TODO: make RANDOM_NUMBER_GENERATOR work
// int generatedRandomInt() {
//   int permanentRandomInt;
//   int tempRandomInt;
//
//
//   //this will run after we create our second card
//   if (randomIntList.length == 0) {
//     tempRandomInt = 0 + Random().nextInt(3 - 0);
//     permanentRandomInt = tempRandomInt;
//     print('randomInt: $permanentRandomInt');
//     randomIntList.add(permanentRandomInt);
//   }
//   else {
//     tempRandomInt = 0 + Random().nextInt(3 - 0);
//     permanentRandomInt = tempRandomInt;
//     print('randomInt: $permanentRandomInt');
//     randomIntList.add(permanentRandomInt);
//     while (randomIntList[randomIntList.last] == randomIntList[randomIntList.length - 2]) {
//       tempRandomInt = 0 + Random().nextInt(3 - 0);
//       permanentRandomInt = tempRandomInt;
//       print('randomInt: $permanentRandomInt');
//       randomIntList.add(permanentRandomInt);
//       // print(randomIntList.length);
//     }
//
//   }
//   return randomIntList.last;
//
// }
