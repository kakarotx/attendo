import 'package:flutter/material.dart';
import 'package:attendo/widgets/card_widget.dart';

//this screen displays all the classes joined by you

class JoinedClassScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
      backgroundColor: Colors.black,
    ),
      body: ListView(
        children: [
          CardWidget(imagePath: 'assets/images/artWork/bookwormOrange.jpg',),
          CardWidget(imagePath: 'assets/images/artWork/bookworm.jpg',),
          CardWidget(imagePath: 'assets/images/artWork/bookwormOrange.jpg',),
          CardWidget(imagePath: 'assets/images/artWork/bookwormOrange.jpg',),
          CardWidget(imagePath: 'assets/images/artWork/bookworm.jpg',),
          CardWidget(imagePath: 'assets/images/artWork/bookwormOrange.jpg',),
          CardWidget(imagePath: 'assets/images/artWork/bookworm.jpg',),

        ],
      ),
    );
  }
}
