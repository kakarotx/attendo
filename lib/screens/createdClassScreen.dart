import 'package:flutter/material.dart';
import 'package:attendo/widgets/card_widget.dart';
import 'package:attendo/Screens/create_class_popup.dart';


//this Screen displays all the created classes by you

class CreatedClassScreen extends StatelessWidget {




  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(context: context, builder: (BuildContext context)=>CreateNewClassScreen(),);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          CardWidget(
            imagePath: 'assets/images/artWork/bookworm.jpg',
          ),
          CardWidget(
            imagePath: 'assets/images/artWork/bookwormOrange.jpg',
          ),
          CardWidget(
            imagePath: 'assets/images/artWork/bookworm.jpg',
          ),
          CardWidget(
            imagePath: 'assets/images/artWork/bookworm.jpg',
          ),
          CardWidget(
            imagePath: 'assets/images/artWork/bookwormOrange.jpg',
          ),
          CardWidget(
            imagePath: 'assets/images/artWork/bookwormOrange.jpg',
          ),
        ],
      ),
    ));
  }
}
