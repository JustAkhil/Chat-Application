import 'package:chat_application/constants/app_routes/app_routes.dart';
import 'package:chat_application/data/remote/firebase_repository.dart';
import 'package:chat_application/firebase_options.dart';
import 'package:chat_application/on_boarding/signup/signup_cubit/sign_up_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'on_boarding/login/login_cubit/login_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              SignUpCubit(firebaseRepository: FirebaseRepository.getInstance()),
        ),
        BlocProvider(
          create: (_) =>
              LoginCubit(firebaseRepository: FirebaseRepository.getInstance()),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.getRoutes(),
    );
  }
}
