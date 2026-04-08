import 'package:chat_application/on_boarding/signup/signup_page.dart';
import 'package:flutter/cupertino.dart';
import '../../on_boarding/login/login_page.dart';
import '../../ui/screens/all_message_page.dart';
class AppRoutes {
  static final signUp = "signUp";
  static final splash = "/";
  static final login = "loginPage";
  static final allMessagePage="allMessagePage";

  static Map<String, WidgetBuilder> getRoutes() => {
    signUp: (context) => SignUpPage(),
    login: (context) => LoginPage(),
    allMessagePage:(_)=>AllMessagePage(),

  };
}
