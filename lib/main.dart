import 'package:flutter/material.dart';
import 'package:todo_sqflite_flutter/ui/home.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   brightness: Brightness.dark,
      //   primaryColor: Colors.black,
      //   accentColor: Colors.lightBlue,
      // ),
      home: new Home(),
    );
  }
}

