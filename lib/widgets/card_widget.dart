import 'package:flutter/material.dart';

const attendoTextStyle = TextStyle(color: Colors.white, fontSize: 18);

class CardWidget extends StatelessWidget {
  CardWidget({this.imagePath});

  final String imagePath;



  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: double.infinity,
      child: FlatButton(

        onPressed: (){
          print('heehee');
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            margin: EdgeInsets.only(top: 6, bottom: 6, left: 6,right: 6),
            padding: EdgeInsets.only(top: 15, left: 15, bottom: 15),
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      imagePath,
                    )),
                color: Colors.red,
                borderRadius: BorderRadius.circular(5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Computer Architecture',
                  style: attendoTextStyle,
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  'Batch 2019',
                  style: attendoTextStyle.copyWith(fontSize: 12),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Surrendra Beniwal',
                  style: attendoTextStyle.copyWith(fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
