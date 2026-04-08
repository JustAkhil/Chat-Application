import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/remote/firebase_repository.dart';
import '../../ui/screens/all_message_page.dart';
import '../login/login_page.dart';
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () async {
      var prefs = await SharedPreferences.getInstance();
      String? value = prefs.getString(FirebaseRepository.PREFS_USER_ID_KEY);

      Widget nextPage = LoginPage();

      if(value!=null && value!=""){
        nextPage = AllMessagePage();
      }


      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => nextPage),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.white.withOpacity(0.5)),
            child: SizedBox(
                width: 100,
                height: 100,
                child: Image.asset(
                  '',
                  fit: BoxFit.contain,
                ))),
      ),
    );
  }
}