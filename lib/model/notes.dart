class Notes{
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;

  Notes(this._title, this._date, this._priority, [this._description]);
  Notes.withId(this._id,this._title, this._date, this._priority, [this._description]);

  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get date => _date;
  int get priority => _priority;

  set title(String newTitle){
    if (newTitle.length <= 255){
      this._title = newTitle;
    }
  }
  set description (String newDescription){
    if (newDescription.length <= 255){
      this._description = newDescription;
    }
  }

  set priority (int newPriority){
    if (newPriority >= 1 && newPriority <= 2){
      this._priority = newPriority;
    }
  }

  set date (String newDate){
    this._date = newDate;
  }

  // convert a Note object into a MAP object
  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    if (id != null){
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['date'] = _date;
    map['priority'] = _priority;

    return map;
  }

  // Extract a Note object from a MAP object
  Notes.fromMapObject(Map<String, dynamic> map){
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._priority = map['priority'];
    this._date = map['date'];
  }
}