import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/models/change_password_model.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/screens/main_page.dart';
import 'package:todo_app/services/user_service.dart';
import 'package:todo_app/widgets/app_bar.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late User? user;

  bool _oldPasswordVisiable = true;
  bool _newPasswordVisiable = true;
  bool _confirmPasswordVisiable = true;

  bool _isLoading = false;

  int? _user_id = 0;
  String? old_password = "";

  _loadUserData() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      _user_id = pref.getInt("id");
      old_password = pref.getString("password");
    });
  }

  _loadUser(int? user_id) async {
    try {
      final response = await UserService().getUserData(user_id!);
      if (response.statusCode == 200) {
        setState(() {
          var data =
              jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
          user = User.fromJson(data);
          if (kDebugMode) {
            print(user?.password);
          }
        });
      } else {
        // Handle errors here
        setState(() {
          _isLoading = false;
        });
        // Display an error message
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to load user data.'),
        ));
      }
    } catch (e) {
      // Display an error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred: $e'),
      ));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: const AppBarBuilded(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _oldPasswordController,
                decoration: InputDecoration(
                  labelText: "Old Password",
                  enabledBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueGrey, width: 2.0)),
                  border: const OutlineInputBorder(borderSide: BorderSide()),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _oldPasswordVisiable = !_oldPasswordVisiable;
                        });
                      },
                      icon: Icon(
                        _oldPasswordVisiable
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black54,
                      )),
                ),
                obscureText: _oldPasswordVisiable,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter Old Password";
                  } else {
                    if (value.length <= 5) {
                      return "Password must be greater than 5 characters";
                    }
                    if (old_password?.compareTo(value) != 0) {
                      return "Password does not match";
                    }
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                  labelText: "New Password",
                  enabledBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueGrey, width: 2.0)),
                  border: const OutlineInputBorder(borderSide: BorderSide()),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _newPasswordVisiable = !_newPasswordVisiable;
                        });
                      },
                      icon: Icon(
                        _newPasswordVisiable
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black54,
                      )),
                ),
                obscureText: _newPasswordVisiable,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter New Password";
                  } else if (value.length <= 5) {
                    return "Password must be greater than 5 characters";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  enabledBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueGrey, width: 2.0)),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _confirmPasswordVisiable = !_confirmPasswordVisiable;
                        });
                      },
                      icon: Icon(
                        _confirmPasswordVisiable
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black54,
                      )),
                ),
                obscureText: _confirmPasswordVisiable,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter Password";
                  } else {
                    if (value.compareTo(_newPasswordController.text) != 0) {
                      return "Password Does Not Match !";
                    }
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
                        var data = ChangePasswordModel(
                            id: _user_id,
                            password: _newPasswordController.text);

                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          var res = UserService().changePassword(data);
                          res.then((value) async {
                            final pref = await SharedPreferences.getInstance();

                            if (kDebugMode) {
                              print(value);
                            }
                            pref.setString("password", _newPasswordController.text);
                            setState(() {
                              _isLoading = false;
                            });
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MainPage()));
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
                    : const Text(
                        "Change Password",
                        style: TextStyle(color: Colors.white),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
