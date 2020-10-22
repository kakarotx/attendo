import 'package:attendo/general_classes/course_class.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:provider/provider.dart';
import 'general_classes/list_of_card.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ListofCard>(
        create: (context)=>ListofCard(),
        child: HomePage());
  }
}
