import 'package:flutter/material.dart';
import 'package:note_keeper/screens/note_detail.dart';
import 'dart:async';
import 'package:note_keeper/model/notes.dart';
import 'package:note_keeper/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NoteListState();
  }
}

class NoteListState extends State<NoteList>{

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Notes> noteList;

  var count = 0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (noteList == null) {
      noteList = List<Notes>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Note'),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Button',
          child: Icon(Icons.add),
          onPressed: (){
          debugPrint('FAB clicked');
          navigateToDetail(Notes('', '', 2) ,'Add Note');
          }),
    );
  }

  // Returns the priority color
  Color getPriorityColor (int priority){
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;
    }
  }
  // Returns the priority icon
  Icon getPriorityIcon (int priority){
    switch(priority){
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;
      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete (BuildContext context, Notes notes) async {
    int result = await databaseHelper.deleteNote(notes.id);
    if (result !=0 ){
      _showSnackBar (context, 'Note Deleted Successfully');
      updateListView();
    }

  }
  void _showSnackBar(BuildContext context, String message){
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);

  }

  void navigateToDetail(Notes notes, String title) async{
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
      return NoteDetail(notes,title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){
      Future<List<Notes>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

  ListView getNoteListView(){
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: count,
        itemBuilder: (BuildContext context, int position){
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(this.noteList[position].priority),
              child: getPriorityIcon(this.noteList[position].priority)
            ),
            subtitle: Text(this.noteList[position].date),
            title: Text(this.noteList[position].title, style: titleStyle),
            trailing: GestureDetector(
              child:  Icon(Icons.delete, color: Colors.grey,),
              onTap: (){
                _delete(context, noteList[position]);
              },
            ),
            onTap: (){
              setState(() {
                debugPrint('List Printed');
                navigateToDetail(this.noteList[position], 'Edit Notes');
              });
            },
          ),
        );
        });
  }


}

