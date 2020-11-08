import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  UserProfile({this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EditProfileCard(imageUrl: imageUrl),
        //this container will contain other stuff
        GestureDetector(
          onTap: () {
            print('logging out');
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Text(
              'LogOut',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            decoration: BoxDecoration(
              color: Color(0xFF00AAFF),
              borderRadius: BorderRadius.circular(35),
            ),
          ),
        ),
      ],
    );
  }
}

///edit Profile Card
class EditProfileCard extends StatelessWidget {
  EditProfileCard({
    @required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
              ),
              SizedBox(
                width: 12,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pulkit',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('@pulkit'),
                ],
              )
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
            child: Text(
              'Edit',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            decoration: BoxDecoration(
              color: Color(0xFF00AAFF),
              borderRadius: BorderRadius.circular(35),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}
