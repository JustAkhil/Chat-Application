abstract class SignUpState{}
class SignUpInitialState extends SignUpState{}
class SignUpLoadingState extends SignUpState{}
class SignUpSuccessState extends SignUpState{}
class SignUpFailureState extends SignUpState{
  String errMsg;
  SignUpFailureState({required this.errMsg});

}