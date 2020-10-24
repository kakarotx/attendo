import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Screens/createdClassScreen.dart';
import 'Screens/joinedClassScreen.dart';
import 'package:provider/provider.dart';
import 'modals/list_of_course_details.dart';

const attendoTextStyle = TextStyle(color: Colors.black);

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          drawer: CustomDrawer(),
          appBar: AppBar(
            title: Text(
              'Attendo',
              style: attendoTextStyle,
            ),
            backgroundColor: Colors.white,
            bottom: TabBar(
              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              labelPadding: EdgeInsets.all(8),
              controller: tabController,
              tabs: [
                Text(
                  'CreatedClass',
                  style: attendoTextStyle,
                ),
                Text(
                  'JoinedClass',
                  style: attendoTextStyle,
                )
              ],
            ),
          ),
          body: TabBarView(
            controller: tabController,
            children: [
              CreatedClassScreen(),
              JoinedClassScreen(),
            ],
          ),
        ),
      ),
    );
  }
}



//custom drawer class
class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(

                      color: Colors.grey,
                    )),
              ),
              padding: const EdgeInsets.all(15.0),
              child: Text(
                '//Attendo',
                style: attendoTextStyle.copyWith(
                    fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text('Created By You:', style: attendoTextStyle.copyWith(fontWeight: FontWeight.w500),),
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          children:[
                            //TODO: add RealCourses to this list
                            Text('Course 1'),
                            Text('Course 2'),
                            Text('Course 3')
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }
}

