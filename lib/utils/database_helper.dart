import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:note_keeper/model/notes.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // SingleTon Database
  DatabaseHelper.createInstance(); // Named constructor to create instance of DatabaseHelper
  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';


  factory DatabaseHelper (){
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          .createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async{
    if (_database == null){
       _database = await initializeDatabase();
    }
    return _database;
  }


  Future<Database> initializeDatabase() async{
    // Get the directory path for both Android and IOS to store database
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';

    //Open/ Create the database at a given path
    var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $noteTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, ' '$colDescription TEXT, $colPriority INTEGER, $colDate TEXT)');
  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    var result = await db.query(noteTable, orderBy: '$colPriority ASC');
    return result;
  }

  // Insert Operation: Insert a Note object
  Future<int> insertNote(Notes notes) async{
    Database db = await this.database;
    var result = await db.insert(noteTable, notes.toMap());
    return result;
  }
  // Update operation: Update a note object and save it to database
  Future<int> updateNote (Notes notes) async{
    Database db = await this.database;
    var result = await db.update(noteTable, notes.toMap(), where: '$colId = ?', whereArgs: [notes.id]);
    return result;
  }

  // Delete operation: Delete a note object from database

  Future<int> deleteNote (int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;

  }
  // Get number of Note objects in database

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $noteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [List <Note> ]
  Future<List<Notes>> getNoteList() async {
    var noteMapList = await getNoteMapList(); // Get MapList from Database
    int count = noteMapList.length; // Count the number of map entries in db table
    List<Notes> noteList = List<Notes>();
    // For Loop to create a 'Note list' from a 'Map List'
    for (int i=0 ; i<count ; i++) {
      noteList.add(Notes.fromMapObject(noteMapList[i]));
    }
    return noteList;

  }
}
