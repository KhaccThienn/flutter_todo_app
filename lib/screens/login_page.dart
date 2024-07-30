import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/models/login_view_model.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/screens/main_page.dart';
import 'package:todo_app/screens/register_screen.dart';
import 'package:todo_app/services/user_service.dart';

class LoginPage extends StatefulWidget {
  final String? username;
  final String? password;

  const LoginPage({super.key, this.username, this.password});


  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisiable = true;

  @override
  void initState() {
    // TODO: implement initState
    _userNameController.text = (widget.username ?? "");
    _passwordController.text = (widget.password ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo/logo_td_nasa.jpg',
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _userNameController,
                decoration: const InputDecoration(
                  labelText: 'User Name',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  prefixIcon: Icon(Icons.person_3),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Username cannot be blank";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.white),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _passwordVisiable = !_passwordVisiable;
                          });
                        },
                        icon: Icon(
                          _passwordVisiable
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        )),
                    prefixIcon: const Icon(Icons.lock)),
                obscureText: _passwordVisiable,
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password cannot be blank';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Login logic
                  if (_formKey.currentState!.validate()) {
                    var data = LoginViewModel(
                        username: _userNameController.text,
                        password: _passwordController.text);
                    // Login logic
                    var res = UserService().postLogin(data);
                    res.then((value) async {
                      if (kDebugMode) {
                        print(value.body);
                      }
                      if (value!.body == "null") {
                        Dialogs.materialDialog(
                          msg:
                              'Failed To Login, Username or Password is not correct !',
                          title: "Notice",
                          color: Colors.white,
                          context: context,
                          actions: [
                            IconsOutlineButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              text: 'OK',
                              color: Colors.red,
                              textStyle: const TextStyle(color: Colors.white),
                              iconColor: Colors.white,
                            ),
                          ],
                        );
                      } else {
                        var data = jsonDecode(
                            const Utf8Decoder().convert(value.bodyBytes));
                        var user = User.fromJson(data);
                        var prefs = await SharedPreferences.getInstance();
                        prefs.setInt("id", user.id!);
                        if (kDebugMode) {
                          print(user.id);
                        }
                        prefs.setString("display_name", user.displayName!);
                        prefs.setString("avatar", user.avatar!);
                        prefs.setString("password", user.password!);
                        if (!context.mounted) return;
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainPage()),
                            (_) => false);
                      }
                    }).catchError((error) async {
                      if (kDebugMode) {
                        print(error);
                      }
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  side: const BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()),
                    );
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
