import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:todo_app/constants/common.dart';
import 'package:todo_app/models/login_view_model.dart';

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
}
