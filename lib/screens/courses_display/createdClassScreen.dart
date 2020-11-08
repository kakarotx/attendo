import 'package:attendo/modals/list_of_course_details.dart';
import 'package:attendo/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'createNewClass_popup.dart';
import 'create_list_of_created_class.dart';
import 'package:provider/provider.dart';


///this Screen displays all the created classes by user
class CreatedClassScreen extends StatefulWidget {
  @override
  _CreatedClassScreenState createState() => _CreatedClassScreenState();
}

class _CreatedClassScreenState extends State<CreatedClassScreen> {

  List<CardWidget> listOfCourses;

  ///when there will be no classes, we will show [NO CLASSES, CREATE NEW];
  ///zeroCC = zero_created_classes
  ///this above variable will toggle that screen
  bool zeroCC = true;

  ///this function will toggle the ZeroCC screen
  void toggleZeroCCScreen(){
    if(Provider.of<ListOfCourseDetails>(context, listen: false).
    finalListOfCreatedCourses.length==0){
      setState(() {
        zeroCC = true;
      });
    } else{
      setState(() {
        zeroCC = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled:true,
                context: context,
                builder: (BuildContext context) => CreateNewClassScreen(
                    toggleScreenCallBack: toggleZeroCCScreen,
                ),
              );
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.black,
          ),
          body: zeroCC ? ZeroCCScreen():BuildListOfMyClasses()),
    );
  }
}

///this is the zeroCCScreen or [NO CLASS CREATED SCREEN]
class ZeroCCScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Center(
      child: Text('NO CLASS CREATED',
        style: TextStyle(fontSize: 25,
            fontWeight: FontWeight.bold,
        color: Colors.black54),
      ),
    );
  }
}
