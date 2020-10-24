import 'package:flutter/material.dart';
import 'create_list_of_joined_class.dart';
import 'joinNewClass_popup.dart';

///this screen displays all the classes joined by you

class JoinedClassScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) => JoinNewClassScreen(

            ),
          );
        },
        child: Icon(Icons.add),
      backgroundColor: Colors.black,
    ),
      body: BuildListOfJoinedClasses(),
    );
  }
}
