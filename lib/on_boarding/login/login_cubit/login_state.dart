abstract class LoginState{}
class LoginInitialState extends LoginState{}
class LoginLoadingState extends LoginState{}
class LoginSuccessState extends LoginState{}
class LoginFailureState extends LoginState{
  String errMsg;
  LoginFailureState({required this.errMsg});

}