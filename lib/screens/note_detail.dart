import 'package:flutter/material.dart';
import 'dart:async';
import 'package:note_keeper/model/notes.dart';
import 'package:note_keeper/utils/database_helper.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget {
  String appBarTitle;
  final Notes notes;
  NoteDetail(this.notes, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NoteDetailState(this.notes, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  static var _priorities = ['High Expense', 'Low Expense'];
  String appBarTitle;
  final Notes notes;

  NoteDetailState(this.notes, this.appBarTitle);
  DatabaseHelper helper = DatabaseHelper();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    TextStyle textStyle = Theme.of(context).textTheme.subhead;

    titleController.text = notes.title;
    descriptionController.text = notes.description;
    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
              moveToLastScreen();
            }),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: DropdownButton(
                      items: _priorities.map((String newValueSelected) {
                        return DropdownMenuItem<String>(
                          value: newValueSelected,
                          child: Text(newValueSelected),
                        );
                      }).toList(),
                      style: textStyle,
                      value: getPriorityAsString(notes.priority),
                      onChanged: (valueSelectedUser) {
                        setState(() {
                          debugPrint('user select $valueSelectedUser');
                          updatePriorityAsInt(valueSelectedUser);
                        });
                      }),
                ),

                // second element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: titleController,
                    style: textStyle,
                    onChanged: (value){
                      debugPrint('sth changed in title text');
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                // third element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: descriptionController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('something changed $value');
                      updateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              'Create',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                debugPrint('Create clicked');
                                _save();
                              });
                            }),
                      ),
                      Container(
                        width: 15.0,
                      ),
                      Expanded(
                        child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              'Delete',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                debugPrint('Cancel clicked');
                                _delete();
                              });
                            }),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void moveToLastScreen(){
    Navigator.pop(context, true);
  }
  // convert the string priority in the form of integer before saving it to database
  void updatePriorityAsInt(String value){
    switch(value) {
      case 'High Expense':
        notes.priority = 1;
        break;
      case 'Low Expense':
        notes.priority = 2;
        break;
    }
  }

  // Convert Int priority to String priority and display it to user in Dropdown
  String getPriorityAsString(int value){
    String priority;
    switch(value) {
      case 1:
        priority = _priorities[0];
        break;
      case 2:
        priority = _priorities[1];
        break;
    }
    return priority;
  }

  // Update the title of Note Object
  void updateTitle (){
    notes.title = titleController.text;
  }
  // Update the description of Note Object
  void updateDescription() {
    notes.description = descriptionController.text;
  }
  // Delete in database
  void _delete() async {
    moveToLastScreen();

    // Case 1: if user is tying to delete the New Note. i.e He has come to the detail page by pressing the FAB of NoteList Page
    if (notes.id == null) {
      _showAlertDialog('Status', 'No note was deleted');
      return;
    }

    // Case 2: user is trying to delete the old note that already has a valid ID
    int result = await helper.deleteNote(notes.id);
    if (result != 0){
      _showAlertDialog('status', 'Note deleted Successfully');
    }
    else{
      _showAlertDialog('status', 'Error occur while deleting');
    }
  }


  // Save data to database
  void _save() async {
    moveToLastScreen();
    notes.date = DateFormat.yMMMd().format(DateTime.now());

    int result;
    if (notes.id != null) { // Case 1: update operation
      result = await helper.updateNote(notes);
    }
    else{ // Case 2: update operation
      result  =await helper.insertNote(notes);
    }
    if (result !=0) { // success
      _showAlertDialog('status', 'Noted Saved Successfully');
    }
    else{
      _showAlertDialog('status', 'Problem Saving Note');
    }

  }

  void _showAlertDialog(String title, String message){
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content:  Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }



}
