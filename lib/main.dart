import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:provider/provider.dart';
import 'modals/list_of_course_details.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ListOfCourseDetails>(
        create: (context)=>ListOfCourseDetails(),
        child: HomePage());
  }
}
