import 'package:flutter/cupertino.dart';

class ThemeChanger with ChangeNotifier {

  CupertinoThemeData _cupertinoThemeData = CupertinoThemeData(brightness: Brightness.light);


  getThemeData()=> _cupertinoThemeData;

  setTheme(CupertinoThemeData themeData){
    _cupertinoThemeData = themeData;
    notifyListeners();
  }

}