import 'package:attendo/modals/course_class.dart';
import 'package:attendo/modals/size_config.dart';
import 'package:flutter/cupertino.dart';

//MediaQuery r2d
final cardTextStyle = TextStyle(color: CupertinoColors.white, fontSize: (SizeConfig.one_W*14).roundToDouble());
final double cardBorderRadius = (SizeConfig.one_W*8).roundToDouble();

class CardWidget extends StatelessWidget {
  CardWidget({this.newCourse,this.onCardTab});

  final Course newCourse;
  final Function onCardTab;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTab,
      child: Padding(
        padding: EdgeInsets.all((SizeConfig.one_W*8.0).roundToDouble()),
        child: Container(
          margin: EdgeInsets.only(
              bottom: (SizeConfig.one_H*12).roundToDouble(),
              left: (SizeConfig.one_W*12).roundToDouble(),
              right: (SizeConfig.one_W*12).roundToDouble()),
          padding: EdgeInsets.only(
              top: (SizeConfig.one_H*15).roundToDouble(),
              left: (SizeConfig.one_W*15).roundToDouble(),
              bottom: (SizeConfig.one_W*15).roundToDouble()),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                newCourse.imagePath,
              ),
            ),
            borderRadius: BorderRadius.circular(cardBorderRadius),
            // boxShadow: [
            //   BoxShadow(
            //     color: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle.color.withAlpha(20),
            //     spreadRadius: 4,
            //     blurRadius: 7,
            //     offset: Offset(0, 3), // changes position of shadow
            //   ),
            // ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                newCourse.courseName,
                style: cardTextStyle.copyWith(fontSize: (SizeConfig.one_W*15).roundToDouble()),
              ),
              SizedBox(
                height: (SizeConfig.one_H*5).roundToDouble(),
              ),
              Text(
                '${newCourse.yearOfBatch}',
                style: cardTextStyle,
              ),
              SizedBox(
                height: (SizeConfig.one_H*5).roundToDouble(),
              ),
              Text(
                'Code:${newCourse.courseCode}',
                style: cardTextStyle,
              ),
              SizedBox(
                height: (SizeConfig.one_H*40).roundToDouble(),
              ),
              Text(
                'Teacher: ${newCourse.teacherName}',
                style: cardTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
