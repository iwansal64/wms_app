import 'package:flutter/material.dart';
import 'package:wms_app/pages/wrapper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Water-loss Monitoring System',
      theme: ThemeData(
        fontFamily: "Saira",
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black,
          selectionColor: Colors.blueGrey,
          selectionHandleColor: Colors.white
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            color: Colors.black
          ),
          bodyLarge: TextStyle(
            color: Colors.black
          ),
          bodySmall: TextStyle(
            color: Colors.black
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            side: BorderSide(
              color: Colors.black,
              width: 1
            )
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
          ),
        ),
      ),
      home: const WrapperPage(),
    );
  }
}