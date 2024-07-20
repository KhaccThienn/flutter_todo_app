class Todo {
  int? _id;
  String? _todoText;
  int? _isDone;
  int? _userId;
  String? _createdDate;
  String? _endDate;

  Todo(
      {int? id,
      String? todoText,
      int? isDone,
      int? userId,
      String? createdDate,
      String? endDate}) {
    if (id != null) {
      this._id = id;
    }
    if (todoText != null) {
      this._todoText = todoText;
    }
    if (isDone != null) {
      this._isDone = isDone;
    }
    if (userId != null) {
      this._userId = userId;
    }
    if (createdDate != null) {
      this._createdDate = createdDate;
    }
    if (endDate != null) {
      this._endDate = endDate;
    }
  }

  int? get id => _id;

  set id(int? id) => _id = id;

  String? get todoText => _todoText;

  set todoText(String? todoText) => _todoText = todoText;

  int? get isDone => _isDone;

  set isDone(int? isDone) => _isDone = isDone;

  int? get userId => _userId;

  set userId(int? userId) => _userId = userId;

  String? get createdDate => _createdDate;

  set createdDate(String? createdDate) => _createdDate = createdDate;

  String? get endDate => _endDate;

  set endDate(String? endDate) => _endDate = endDate;

  Todo.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _todoText = json['todoText'];
    _isDone = json['isDone'];
    _userId = json['user_id'];
    _createdDate = json['created_date'];
    _endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['todoText'] = this._todoText;
    data['isDone'] = this._isDone;
    data['user_id'] = this._userId;
    data['created_date'] = this._createdDate;
    data['end_date'] = this._endDate;
    return data;
  }

  Map<String, String> toMap(){
    return {
      "id": id.toString(),
      "todoText": todoText!,
      "isDone": isDone.toString(),
      "user_id": userId.toString(),
      "created_date": createdDate!,
      "end_date": endDate!
    };
  }
}
