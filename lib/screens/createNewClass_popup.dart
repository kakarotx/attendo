import 'package:attendo/general_classes/course_class.dart';
import 'package:attendo/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:attendo/general_classes/list_of_card.dart';


//style
const bottomDrawerStyle = TextStyle(
  color: Colors.black,fontSize: 20, fontWeight: FontWeight.bold
);


//this is popScreen to create New class
// ignore: must_be_immutable
class CreateNewClassScreen extends StatefulWidget {


  @override
  _CreateNewClassScreenState createState() => _CreateNewClassScreenState();
}

class _CreateNewClassScreenState extends State<CreateNewClassScreen> {

  String courseName;

  String yearOfBatch;

  int courseCode;

  @override
  Widget build(BuildContext context) {

    courseCode = 9999 + Random().nextInt(99999-9999);
    // newCourse.courseCode = courseCode;
    // newCourse=Course(courseName: courseName,courseCode: courseCode,yearOfBatch: yearOfBatch);


    return Container(
      color: Color(0xFF737373),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
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
                    onChanged: (newValue){
                    setState(() {
                      courseName = newValue;
                    });
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
            SizedBox(height: 5,),
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
                    onChanged: (newValue){
                      setState(() {
                        yearOfBatch=(newValue);
                      });
                    },
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Enter Year',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Text(
              'Class Code : $courseCode',
              style: bottomDrawerStyle,
            ),
            SizedBox(height: 20,),

            Center(
              child: RaisedButton(
                onPressed:(){

                  Provider.of<ListofCard>(context,
                  listen: false).addItemToCourseList(CardWidget(course: Course(
                    yearOfBatch: yearOfBatch, courseCode: courseCode,courseName: courseName
                  )));
                  //create a new card with Course details and
                  //add it to the List


                  Navigator.pop(context);
                }
                ,
                child: Text('Create Class', style: TextStyle(color: Colors.white),),
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}
