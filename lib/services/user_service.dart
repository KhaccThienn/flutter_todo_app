import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:todo_app/constants/common.dart';
import 'package:todo_app/models/change_password_model.dart';
import 'package:todo_app/models/login_view_model.dart';
import 'package:todo_app/models/register_view_model.dart';
import 'package:todo_app/models/user_model.dart';

class UserService {
  Map<String, String> headers = {
    "Content-Type": "application/json; charset=UTF-8"
  };

  Future<http.Response> getUserData(int id) {
    return http.get(Uri.parse('${Common.domain}/api/v1/user/$id'),
        headers: headers);
  }

  Future<http.Response> postLogin(LoginViewModel model) {
    return http.post(Uri.parse('${Common.domain}/api/v1/login'),
        headers: headers, body: jsonEncode(model));
  }

  Future<http.Response> changePassword(ChangePasswordModel model) {
    return http.post(Uri.parse('${Common.domain}/api/v1/password'),
        headers: headers, body: jsonEncode(model));
  }

  Future<http.Response> registerUser(RegisterViewModel model) {
    return http.post(Uri.parse('${Common.domain}/api/v1/register'),
        headers: headers, body: jsonEncode(model.toJson()));
  }

  Future<http.StreamedResponse> register(User model, String filePath) async {
    var request = http.MultipartRequest(
        "POST", Uri.parse('${Common.domain}/api/v1/register'));
    request.files.add(await http.MultipartFile.fromPath("file", filePath));
    request.fields.addAll(model.toMap());
    return request.send();
  }
}
