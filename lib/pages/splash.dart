import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatelessWidget {
  Splash({Key? key}) : super(key: key);
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  void _moveToNextScreen(context) async {
    final SharedPreferences pref = await _pref;
    var isUserLogin = pref.getBool('is_user_login') ?? false;
    if (isUserLogin) {
      Get.offNamed('/home');
    } else {
      Get.offNamed('/introduction');
    }
  }

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () => _moveToNextScreen(context));
    return Scaffold(
        backgroundColor: const Color(0xFF001F5A),
        body: Center(
            child: Container(
                width: 200.0,
                height: 43.0,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/img_splash.png'),
                        fit: BoxFit.cover)))));
  }
}
