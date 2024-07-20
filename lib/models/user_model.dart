class User {
  int? _id;
  String? _username;
  String? _displayName;
  String? _password;
  String? _avatar;

  User(
      {int? id,
      String? username,
      String? displayName,
      String? password,
      String? avatar}) {
    if (id != null) {
      this._id = id;
    }
    if (username != null) {
      this._username = username;
    }
    if (displayName != null) {
      this._displayName = displayName;
    }
    if (password != null) {
      this._password = password;
    }
    if (avatar != null) {
      this._avatar = avatar;
    }
  }

  int? get id => _id;

  set id(int? id) => _id = id;

  String? get username => _username;

  set username(String? username) => _username = username;

  String? get displayName => _displayName;

  set displayName(String? displayName) => _displayName = displayName;

  String? get password => _password;

  set password(String? password) => _password = password;

  String? get avatar => _avatar;

  set avatar(String? avatar) => _avatar = avatar;

  User.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _username = json['username'];
    _displayName = json['display_name'];
    _password = json['password'];
    _avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['username'] = this._username;
    data['display_name'] = this._displayName;
    data['password'] = this._password;
    data['avatar'] = this._avatar;
    return data;
  }
}
