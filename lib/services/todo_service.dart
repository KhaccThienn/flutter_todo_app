import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:todo_app/constants/common.dart';
import 'package:todo_app/models/todo_model.dart';

class TodoService {
  Map<String, String> headers = {
    "Content-Type": "application/json; charset=UTF-8"
  };

  Future<http.Response> getTodos(int userId) {
    return http.get(Uri.parse('${Common.domain}/api/v1/todos/$userId'),
        headers: headers);
  }

  Future<http.Response> save(Todo todo, String method) async {
    if (method == "POST") {
      return await http.post(Uri.parse('${Common.domain}/api/v1/todos/create'),
          headers: headers, body: jsonEncode(todo));
    } else {
      var dataTodo = Todo(
        isDone: todo.isDone
      );
      return await http.patch(
          Uri.parse('${Common.domain}/api/v1/todos/update/${todo.id}'),
          headers: headers,
          body: jsonEncode(dataTodo));
    }
  }

  Future<http.Response> deleteTodo(int id) {
    return http.delete(Uri.parse('${Common.domain}/api/v1/todos/delete/$id'),
        headers: headers);
  }
}
