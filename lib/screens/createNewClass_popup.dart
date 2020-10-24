import 'package:attendo/modals/course_class.dart';
import 'package:attendo/widgets/card_widget.dart';
import 'package:attendo/modals/list_of_course_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

//style
const bottomDrawerStyle =
    TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold);

///this is popUp_Screen to create New class
class CreateNewClassScreen extends StatefulWidget {
  @override
  _CreateNewClassScreenState createState() => _CreateNewClassScreenState();
}

class _CreateNewClassScreenState extends State<CreateNewClassScreen> {

  //variables for create a new Course
  String courseName;
  String yearOfBatch;
  int courseCode;
  //variables for Generating a new non-repeating Random Integer
  List<int> randomIntList = [];


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

    //
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF737373),
      child: Container(
        padding: EdgeInsets.all(20),
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
              height: 10,
            ),
            Center(
              child: RaisedButton(
                onPressed: () {
                  //generate Random courseCode
                  courseCode = 9999 + Random().nextInt(99999 - 9999);

                  //generated a random int which is passed through ImageList index
                  //TODO: make a function so that images don't gListofCourseCardd
                  //min + Random().nextInt(max-min);
                  int randomInt = 0 + Random().nextInt(3 - 0);

                  if (yearOfBatch != null && courseName != null) {

                    //adding the courseCode to the ListOfCourseCodes which is located in []
                    Provider.of<ListOfCourseDetails>(context, listen: false).
                        addItemToCourseCodeList(courseCode.toString());
                    //adding the Course Object to the ListOfCard
                    Provider.of<ListOfCourseDetails>(context, listen: false)
                        .addItemToCourseList(
                      CardWidget(
                        course: Course(
                            yearOfBatch: yearOfBatch,
                            courseCode: courseCode,
                            courseName: courseName),
                        imagePath: getRandomImg(imagePaths, randomInt),
                      ),
                    );
                    _showToast(
                        toastMsg: 'Class Created', toastIcon: Icons.check);
                  }
                  Navigator.pop(context);
                  _showToast(
                      toastMsg: 'Enter Valid Details', toastIcon: Icons.warning);
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
