import 'package:chat_application/on_boarding/signup/signup_page.dart';
import 'package:chat_application/ui/screens/my-profile_page.dart';
import 'package:chat_application/ui/screens/set_profile.dart';
import 'package:flutter/cupertino.dart';
import '../../on_boarding/login/login_page.dart';
import '../../on_boarding/splash/splash_page.dart';
import '../../ui/screens/all_contacts_page.dart';
import '../../ui/screens/all_message_page.dart';
import '../../ui/screens/chat_page.dart';
class AppRoutes {
  static final signUp = "/signUp";
  static final splash = "/";
  static final login = "/loginPage";
  static final allMessagePage="/allMessagePage";
  static final allContactsPage="/allContactsPage";
  static final chatPage="/chat_page";
  static final setProfileImagePage="/setProfilePage";
  static final myProfilePage="/myProfilePage";

  static Map<String, WidgetBuilder> getRoutes() => {
    signUp: (context) => SignUpPage(),
    login: (context) => LoginPage(),
    allMessagePage:(_)=>AllMessagePage(),
    splash:(_)=>SplashPage(),
    allContactsPage:(_)=>AllContactPage(),
    chatPage:(_)=>ChatPage(),
    setProfileImagePage:(_)=>SetProfilePage(),
    myProfilePage:(_)=>MyProfilePage()

  };
}
