import 'package:chat_application/data/remote/firebase_repository.dart';
import 'package:chat_application/models/user_model.dart';
import 'package:chat_application/on_boarding/signup/signup_cubit/sign_up_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpCubit extends Cubit<SignUpState>{
  FirebaseRepository firebaseRepository;
  SignUpCubit({required this.firebaseRepository}) : super(SignUpInitialState());
  void signUpUser({required UserModel user,required String pass})async{
    emit(SignUpLoadingState());
    try{
      await firebaseRepository.createUser(user: user, pass: pass);
      emit(SignUpSuccessState());
    }catch(e){
      emit(SignUpFailureState(errMsg: e.toString()));
    }
  }
}