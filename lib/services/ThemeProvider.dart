import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  // bool _isDark=false;

  // getBool()async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //  _isDark = prefs.getBool('color')!;
  //   return _isDark;
  // }
  //
  // bool myMode(){
  //    bool mode;
  //
  //    getBool();
  //   // print(_isDark);
  //   if(_isDark==true){
  //     mode = true;
  //   }else
  //     {
  //        mode =false;
  //     }
  //
  //   return mode;
  // }


  ThemeMode get currentTheme => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
