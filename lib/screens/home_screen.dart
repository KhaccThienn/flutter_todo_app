import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/screens/todo_form.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:todo_app/widgets/todo_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todo> todoList = [];
  List<Todo> foundedTodo = [];

  _loadTodoList(int userId) async {
    try {
      var response = await TodoService().getTodos(userId);
      var data =
          jsonDecode(const Utf8Decoder().convert(response.bodyBytes)) as List;
      setState(() {
        foundedTodo = todoList = data.map((e) => Todo.fromJson(e)).toList();
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching todos: $e");
      }
    }
  }

  @override
  void initState() {
    _loadTodoList(1);
    super.initState();
    foundedTodo = todoList;
  }

  Map<String, List<Todo>> _groupTodosByDate(List<Todo> todos) {
    Map<String, List<Todo>> groupedTodos = {};

    for (var todo in todos) {
      String dateKey = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(todo.createdDate!).toLocal());

      if (groupedTodos[dateKey] == null) {
        groupedTodos[dateKey] = [];
      }

      groupedTodos[dateKey]!.add(todo);
    }

    return groupedTodos;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Todo>> groupedTodos = _groupTodosByDate(foundedTodo);
    List<String> sortedDates = groupedTodos.keys.toList()..sort();

    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                searchBox(),
                const SizedBox(height: 20), // Add some space
                const Text(
                  'All Todos',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10), // Add some space
                Expanded(
                  child: ListView(
                    children: [
                      for (String date in sortedDates) ...[
                        Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 10),
                          child: Text(
                            DateFormat('yyyy-MM-dd')
                                .format(DateTime.parse(date)),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        for (Todo todo in groupedTodos[date]!)
                          TodoItem(
                            todo: todo,
                            onToDoChanged: _handleToDoChange,
                            onDeleteItem: _deleteToDoItem,
                          ),
                      ],
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10.0,
        backgroundColor: tdBlue,
        onPressed: () async {
          final newTodo = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => TodoForm()));
          if (newTodo != null) {
            setState(() {
              todoList.add(newTodo);
              foundedTodo = todoList;
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _handleToDoChange(Todo todo) {
    if (kDebugMode) {
      print(todo.toJson());
    }
    var data = Todo(
      id: todo.id,
      isDone: 1,
    );
    if (todo.isDone == 1) {
      data = Todo(
        id: todo.id,
        isDone: 0,
      );
    }
    TodoService().save(data, "PUT").then((value) async {
      if (kDebugMode) {
        print(value.statusCode);
      }
      setState(() {
        _loadTodoList(1);
      });
    });
  }

  void _deleteToDoItem(int? id) {
    if (kDebugMode) {
      print(id);
    }
    _showConfirmDeleteDialog(id);
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        SizedBox(
          height: 40,
          width: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('assets/images/logo.png'),
          ),
        ),
      ]),
    );
  }

  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  void _runFilter(String enteredKeyword) {
    List<Todo> results = [];
    if (enteredKeyword.isEmpty) {
      results = todoList;
    } else {
      results = todoList
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      foundedTodo = results;
    });
  }

  _showSuccessAlertDialog() {
    Dialogs.materialDialog(
      msg: 'Success !',
      title: "Notice",
      color: Colors.white,
      context: context,
      actions: [
        IconsButton(
          onPressed: () {
            Navigator.pop(context);
          },
          text: 'Claim',
          iconData: Icons.done,
          color: Colors.blue,
          textStyle: const TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ],
    );
  }

  _showConfirmDeleteDialog(int? id) {
    Dialogs.materialDialog(
        msg: 'Are you sure ? you can\'t undo this',
        title: "Delete",
        color: Colors.white,
        context: context,
        actions: [
          IconsOutlineButton(
            onPressed: () {
              Navigator.pop(context);
            },
            text: 'Cancel',
            iconData: Icons.cancel_outlined,
            textStyle: const TextStyle(color: Colors.grey),
            iconColor: Colors.grey,
          ),
          IconsOutlineButton(
            onPressed: () {
              Navigator.pop(context);
              TodoService().deleteTodo(id!).then((value) {
                _loadTodoList(1);
              });
              _showSuccessAlertDialog();
            },
            text: 'Delete',
            iconData: Icons.delete,
            color: Colors.red,
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }
}
