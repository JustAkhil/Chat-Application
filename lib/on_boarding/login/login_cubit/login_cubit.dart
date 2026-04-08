import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/remote/firebase_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState>{
  FirebaseRepository firebaseRepository;
  LoginCubit({required this.firebaseRepository}) : super(LoginInitialState());
  void loginUser({required String email,required String pass})async{
    emit(LoginLoadingState());
    try{
      await firebaseRepository.loginUser(email: email, pass: pass);
      emit(LoginSuccessState());
    }catch(e){
      emit(LoginFailureState(errMsg: e.toString()));
    }
  }
}