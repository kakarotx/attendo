import 'package:flutter/material.dart';
import 'Screens/createdClassScreen.dart';
import 'Screens/joinedClassScreen.dart';


const attendoTextStyle = TextStyle(color: Colors.black);

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

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
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: Icon(Icons.list, color: Colors.black,size: 30,),
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
                Text('CreatedClass', style: attendoTextStyle,),
                Text('JoinedClass', style: attendoTextStyle,)
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
