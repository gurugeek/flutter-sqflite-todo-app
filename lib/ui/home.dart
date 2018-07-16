import 'package:flutter/material.dart';
import 'package:todo_sqflite_flutter/ui/todo_screen.dart';

class Home extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Sqflite Todo App"), 
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
      ),
      body: new TodoScreen(),
    );
  }


}