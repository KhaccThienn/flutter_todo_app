import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/screens/login_page.dart';

class SplashScreenV2 extends StatefulWidget {
  const SplashScreenV2({super.key});

  @override
  State<SplashScreenV2> createState() => _SplashScreenV2State();
}

class _SplashScreenV2State extends State<SplashScreenV2> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const LoginPage()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset(
              'assets/images/logo.png',
              // Ensure this image is added to your assets folder
              width: 100,
              height: 100,
            ),
            const SizedBox(
              height: 50,
            ),
            const SpinKitDualRing(color: Colors.blue, size: 40),
            const Spacer(),
            const Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.facebook, size: 24, color: Colors.grey),
                    SizedBox(width: 8),
                    Icon(Icons.message, size: 24, color: Colors.grey),
                    SizedBox(width: 8),
                    Icon(Icons.notifications_active,
                        size: 24, color: Colors.grey),
                    SizedBox(width: 8),
                    Icon(Icons.library_add, size: 24, color: Colors.grey),
                    SizedBox(width: 8),
                    Icon(Icons.cloud_done_outlined,
                        size: 24, color: Colors.grey),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'TODO APP',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 1.2,
                  ),
                ),
                Text("Powered by KhaccThienn")
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
