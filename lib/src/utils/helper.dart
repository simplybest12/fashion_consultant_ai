import 'package:flutter/material.dart';


class AppHelperFunctions {
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static Color? getColor(String value){

    if( value == 'Green') return Colors.green;
    if( value == 'Red') return Colors.red;
    if( value == 'Blue') return Colors.blue;
    if( value == 'Pink') return Colors.pink;
    if( value == 'Purple') return Colors.purple;
    if( value == 'Black') return Colors.black;
    if( value == 'White') return Colors.white;
    if( value == 'Brown') return Colors.brown;
    if( value == 'Indigo') return Colors.indigo;
    if( value == 'Teal') return Colors.teal;

  }

  
}
