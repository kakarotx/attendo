
import 'package:attendo/modals/course_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:attendo/screens/attendence_screens/course_home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
const cardTextStyle = TextStyle(color: CupertinoColors.white, fontSize: 12);
const double cardBorderRadius = 10;

class CardWidget extends StatelessWidget {
  CardWidget({this.newCourse,this.onTabActive });

  final Course newCourse;
  final bool onTabActive;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTabActive? () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            // fullscreenDialog: true,
            builder: (context) => CupertinoSegmentedControlDemo(course: newCourse),),
        );
      }:null,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          margin: EdgeInsets.only(bottom: 12, left: 12, right: 12),
          padding: EdgeInsets.only(top: 15, left: 15, bottom: 15),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                newCourse.imagePath,
              ),
            ),
            borderRadius: BorderRadius.circular(cardBorderRadius),
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.systemGrey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                newCourse.courseName,
                style: cardTextStyle,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Batch Year :  ${newCourse.yearOfBatch}',
                style: cardTextStyle,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Code:${newCourse.courseCode}',
                style: cardTextStyle,
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                'Teacher: UserName',
                style: cardTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
