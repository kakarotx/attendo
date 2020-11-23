import 'package:flutter/cupertino.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(Navigator.canPop(context,).toString());
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        navigationBar: CupertinoNavigationBar(
          middle: Text('Guidelines'),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: (){
              Navigator.canPop(context,);
              print(Navigator.canPop(context,).toString());
            },
            child: Text('Okays'),
          ),
          // leading: CupertinoButton(
          //   padding: EdgeInsets.zero,
          //   onPressed: ()=>Navigator.pop(context),
          //   child: Text('<Back'),
          // ),
        ),
        child: Container(
          child: Center(
            child: Text('Guidelines'),
          ),
        ),

    );
  }
}
