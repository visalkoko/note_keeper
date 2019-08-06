import 'package:flutter/material.dart';
import 'package:note_keeper/screens/note_list.dart';
import 'package:note_keeper/screens/note_detail.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepOrange
      ),
      home: NoteList(),
    );
  }
}
