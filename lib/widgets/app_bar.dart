import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/constants/common.dart';

class AppBarBuilded extends StatefulWidget implements PreferredSizeWidget  {
  const AppBarBuilded({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  State<AppBarBuilded> createState() => _AppBarBuildedState();
}

class _AppBarBuildedState extends State<AppBarBuilded> {
  int? _user_id = 0;
  String? _display_name = "";
  String? _avatar = "";

  _loadUserData() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      _user_id = pref.getInt("id");
      _display_name = pref.getString("display_name");
      _avatar = pref.getString("avatar");
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        SizedBox(
          height: 40,
          width: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network("${Common.domain}/${_avatar!}"),
          ),
        ),
      ]),
    );
  }
}
