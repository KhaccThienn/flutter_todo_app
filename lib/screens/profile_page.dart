import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/constants/common.dart';
import 'package:todo_app/constants/constants.dart';
import 'package:todo_app/screens/change_password_screen.dart';
import 'package:todo_app/screens/faq_page.dart';
import 'package:todo_app/screens/login_page.dart';
import 'package:todo_app/widgets/profiles/profile_card.dart';
import 'package:todo_app/widgets/profiles/profile_menu_list_tile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
    // TODO: implement initState
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      body: ListView(
        children: [
          ProfileCard(
            name: _display_name!,
            imageSrc: "${Common.domain}/${_avatar!}",
            // proLableText: "Sliver",
            // isPro: true, if the user is pro
          ),
          const SizedBox(height: defaultPadding),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding / 2),
            child: Text(
              "Settings",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),

          ProfileMenuListTile(
            text: "Change Password",
            svgSrc: "assets/icons/change-password-icon.svg",
            press: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ChangePasswordScreen()));
            },
          ),
          const SizedBox(height: defaultPadding),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding / 2),
            child: Text(
              "Help & Support",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          ProfileMenuListTile(
            text: "FAQ",
            svgSrc: "assets/icons/FAQ.svg",
            press: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const FaqPage()));
            },
            isShowDivider: false,
          ),
          const SizedBox(height: defaultPadding),

          // Log Out
          ListTile(
            onTap: () {
              _showConfirmDialog();
            },
            minLeadingWidth: 24,
            leading: SvgPicture.asset(
              "assets/icons/logout.svg",
              height: 24,
              width: 24,
              colorFilter: const ColorFilter.mode(
                errorColor,
                BlendMode.srcIn,
              ),
            ),
            title: const Text(
              "Log Out",
              style: TextStyle(color: errorColor, fontSize: 14, height: 1),
            ),
          )
        ],
      ),
    );
  }
  _showSuccessAlertDialog() {
    Dialogs.materialDialog(
      msg: 'Success !',
      title: "Notice",
      color: Colors.white,
      context: context,
      actions: [
        IconsOutlineButton(
          onPressed: () {
            Navigator.pop(context);
          },
          text: 'OK',
          iconData: Icons.done,
          color: Colors.blue,
          textStyle: const TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ],
    );
  }
  _showConfirmDialog() {
    Dialogs.materialDialog(
        msg: 'Do You Want To Log Out ?',
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
              _showSuccessAlertDialog();

              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()), (_) => false);
            },
            text: 'Log Out',
            iconData: Icons.logout,
            color: Colors.red,
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }
}
