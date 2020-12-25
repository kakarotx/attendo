import 'package:flutter/cupertino.dart';

class StudentsForAttendanceCard extends ChangeNotifier {
  StudentsForAttendanceCard({this.name, this.sid, this.status});
  String name;
  String sid;
  bool status;
}