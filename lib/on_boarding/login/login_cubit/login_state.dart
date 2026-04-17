import 'package:chat_application/models/user_model.dart';

abstract class LoginState{}
class LoginInitialState extends LoginState{}
class LoginLoadingState extends LoginState{}
class LoginSuccessState extends LoginState{
  UserModel user;
  LoginSuccessState({required this.user});
}
class LoginFailureState extends LoginState{
  String errMsg;
  LoginFailureState({required this.errMsg});

}