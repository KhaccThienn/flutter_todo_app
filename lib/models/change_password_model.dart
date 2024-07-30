class ChangePasswordModel {
  int? _id;
  String? _password;

  ChangePasswordModel({
    int? id,
    String? password,
  }) {
    if (id != null) {
      this._id = id;
    }

    if (password != null) {
      this._password = password;
    }
  }

  int? get id => _id;

  set id(int? id) => _id = id;

  String? get password => _password;

  set password(String? password) => _password = password;

  ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['password'] = this._password;
    return data;
  }
}
