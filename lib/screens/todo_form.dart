import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/services/todo_service.dart';

// ignore: must_be_immutable
class TodoForm extends StatefulWidget {
  Todo? todo;

  TodoForm({super.key, this.todo});

  @override
  State<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _todoTextController = TextEditingController();
  final _createdDateController = TextEditingController();
  final _endDateController = TextEditingController();

  final String _buttonLabelText = "Add New";
  String? _errorMsg;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: AppBar(
        title: const Text("Add New Todo"),
        backgroundColor: tdBGColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              widget.todo != null
                  ? TextFormField(
                      controller: _idController,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blueGrey, width: 2.0)),
                        border: OutlineInputBorder(borderSide: BorderSide()),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Todo Id",
                      ),
                      readOnly: true,
                    )
                  : const SizedBox(),
              TextFormField(
                controller: _todoTextController,
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blueGrey, width: 2.0)),
                    border: OutlineInputBorder(borderSide: BorderSide()),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Todo Text",
                    labelText: "Todo Text"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Todo Text Cannot Null';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _createdDateController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.calendar_today),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueGrey, width: 2.0)),
                  border: OutlineInputBorder(borderSide: BorderSide()),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Start Date',
                ),
                readOnly: true,
                onTap: () {
                  _selectStartDateTime(context);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter Start Date';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _endDateController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.calendar_today),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueGrey, width: 2.0)),
                  border: OutlineInputBorder(borderSide: BorderSide()),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'End Date',
                ),
                readOnly: true,
                onTap: () {
                  _selectEndDateTime(context);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter End Date';
                  } else if (value.isNotEmpty) {
                    DateTime startDate = DateFormat('yyyy-MM-dd HH:mm:ss')
                        .parse(_createdDateController.text);
                    if (startDate.isAfter(
                        DateFormat('yyyy-MM-dd HH:mm:ss').parse(value))) {
                      return "The end date must be greater than the start date";
                    }
                    return null;
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        var todo = Todo(
                            id: _idController.text.isEmpty
                                ? null
                                : int.tryParse(_idController.text),
                            todoText: _todoTextController.text,
                            userId: 1,
                            isDone: 0,
                            createdDate: _createdDateController.text,
                            endDate: _endDateController.text);

                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          var method = widget.todo == null ? "POST" : "PUT";
                          var res = TodoService().save(todo, method);
                          res.then((value) async {
                            if (kDebugMode) {
                              print(value);
                            }
                            setState(() {
                              _isLoading = false;
                            });
                            Navigator.pop(context, todo); // Pass the todo back
                          }).catchError((error) async {
                            if (kDebugMode) {
                              print(error);
                            }
                            setState(() {
                              _isLoading = false;
                            });
                          });
                        } else {
                          if (kDebugMode) {
                            print(_formKey.currentState);
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  // Full width and specific height
                  backgroundColor: tdBlue, // Background color
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text(
                        _buttonLabelText,
                        style: const TextStyle(color: Colors.white),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _selectStartDateTime(context) {
    return DatePicker.showDatePicker(context,
        dateFormat: 'yyyy-MM-dd HH:mm:ss',
        initialDateTime: DateTime.now(),
        minDateTime: DateTime(2000),
        maxDateTime: DateTime(3000),
        onMonthChangeStartWithFirstDate: true,
        onConfirm: (dateTime, List<int> index) {
      DateTime selectDate = dateTime;
      final selIOS = DateFormat('yyyy-MM-dd HH:mm:ss').format(selectDate);
      if (kDebugMode) {
        print(selIOS);
      }
      setState(() {
        _createdDateController.text = selIOS;
      });
    }, onCancel: () {
      setState(() {
        _createdDateController.text = "";
      });
    });
  }

  _selectEndDateTime(context) {
    setState(() {
      _errorMsg = "";
    });
    return DatePicker.showDatePicker(context,
        dateFormat: 'yyyy-MM-dd HH:mm:ss',
        initialDateTime: DateTime.now(),
        minDateTime: DateTime(2000),
        maxDateTime: DateTime(3000),
        onMonthChangeStartWithFirstDate: true,
        onConfirm: (dateTime, List<int> index) {
      DateTime selectDate = dateTime;
      final selIOS = DateFormat('yyyy-MM-dd HH:mm:ss').format(selectDate);
      if (kDebugMode) {
        print(selIOS);
      }
      setState(() {
        _endDateController.text = selIOS;
      });
    }, onCancel: () {
      setState(() {
        _endDateController.text = "";
      });
    });
  }

  void _showMessage(
      {required BuildContext context,
      String title = "Thông báo",
      String content = "",
      required String icon}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset("assets/images/$icon"),
                  Text(content),
                ]),
            actions: [
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: const Text('Đồng ý'),
              ),
            ],
          );
        });
  }
}
