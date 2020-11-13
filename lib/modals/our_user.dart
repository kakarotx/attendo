import 'package:attendo/modals/course_class.dart';

///User class
class OurUser {

  ///this data will come from Google Login
  String userName;
  String userId;
  String profileImageUrl;
  String userEmail;

  ///whenever User Joins any Class, it will be added to this List
  List<Course> coursesJoinedByUser;

  ///aPercentage = attendence_percentage
  ///EXAMPLE of the map:
  ///  aPercentage[
  /// 'maths': 50%,
  /// 'english': 60%:
  ///  ]
  Map aPercentage = Map();

  ///Map['courseName' : NoOfPresents]
  Map presentRecord=Map();

  ///Map['courseName' : NoOfAbsents]
  Map absentRecord=Map();

}