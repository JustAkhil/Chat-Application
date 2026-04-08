import 'package:chat_application/constants/app_routes/app_routes.dart';
import 'package:chat_application/on_boarding/login/login_cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_cubit/login_state.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController passController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isPassHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Welcome Back.."),
                  SizedBox(height: 15),
                  TextFormField(
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return "Enter Your Email";
                      } else {
                        return null;
                      }
                    },
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(21),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    obscureText: isPassHidden,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter a password";
                      } else {
                        return null;
                      }
                    },
                    controller: passController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isPassHidden = !isPassHidden;
                          });
                        },icon: Icon(isPassHidden?Icons.visibility:Icons.visibility_off),),
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(21),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  BlocConsumer<LoginCubit,LoginState>(builder: (_,state){
                    if(state is LoginLoadingState){
                      return SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (){},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(21),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(width: 10,),
                              Text("Login"),
                            ],
                          ),
                        ),
                      );
                    }
                    return SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<LoginCubit>().loginUser(
                              email: emailController.text,
                              pass: passController.text,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(21),
                          ),
                        ),
                        child: Text("Login"),
                      ),
                    );
                  }, listener: (_,state){
                    if(state is LoginSuccessState){
                      Navigator.pushReplacementNamed(context,AppRoutes.allMessagePage);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.black12,
                          content: Text("Login Successfully"),
                        ),
                      );
                    }else if(state is LoginFailureState){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.black12,
                          content: Text(state.errMsg),
                        ),
                      );
                    }
                  }),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.signUp);
                        },
                        child: Text("Sign Up"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
