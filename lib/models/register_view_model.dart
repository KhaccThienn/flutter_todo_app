import 'dart:convert';
import 'dart:io';

class RegisterViewModel {
  String username;
  String displayName;
  String password;
  File? avatar;

  RegisterViewModel({
    required this.username,
    required this.displayName,
    required this.password,
    this.avatar,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'displayName': displayName,
      'password': password,
      'avatar': avatar != null ? base64Encode(avatar!.readAsBytesSync()) : null,
    };
  }
}
