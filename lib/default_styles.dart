import 'package:flutter/material.dart';

class DefaultStyles {
  static const Color primaryColor = Color.fromARGB(255, 204, 223, 238); 
  static const Color mainBackgroundColor = Color.fromARGB(255, 0, 74, 173); 
  static const Color backgroundColor = Color.fromARGB(255, 116, 180, 218); 

  static const TextStyle basicTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 16,
    decoration: TextDecoration.none
  );
  
  static const TextStyle basicTitleStyle = TextStyle(
    color: Colors.black,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    decoration: TextDecoration.none
  );

  static const TextStyle basicSubtitleStyle = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.w300,
    decoration: TextDecoration.none
  );

  static final BoxDecoration basicBoxContainerStyle = BoxDecoration(
    color: backgroundColor,
    border: Border.all(width: 2),
    borderRadius: BorderRadius.circular(15),
  );
 
  static final BoxDecoration basicBoxContainerSecondStyle = BoxDecoration(
    color: Color.fromARGB(30, 255, 255, 255),
    border: Border.all(width: 2),
    borderRadius: BorderRadius.circular(15),
  );

  static final BoxDecoration basicBackgroundStyle = BoxDecoration(
    color: mainBackgroundColor
  );
}