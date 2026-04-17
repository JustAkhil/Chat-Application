import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/remote/firebase_repository.dart';
import '../../../models/user_model.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  FirebaseRepository firebaseRepository;

  LoginCubit({required this.firebaseRepository})
      : super(LoginInitialState());

  Future<void> loginUser({
    required String email,
    required String pass,
  }) async {
    emit(LoginLoadingState());

    try {
      await firebaseRepository.loginUser(email: email, pass: pass);

      String userId = await firebaseRepository.getFromId();

      final userDoc = await firebaseRepository.getUsersByUserId(userId: userId);

      UserModel user = UserModel.fromDoc(userDoc.data()!);

      emit(LoginSuccessState(user: user));
    } catch (e) {
      emit(LoginFailureState(errMsg: e.toString()));
    }
  }
}