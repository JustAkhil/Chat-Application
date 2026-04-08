import 'package:chat_application/constants/app_routes/app_routes.dart';
import 'package:chat_application/on_boarding/signup/signup_cubit/sign_up_cubit.dart';
import 'package:chat_application/on_boarding/signup/signup_cubit/sign_up_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user_model.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  bool isHidden = true;
  bool isConfirmPass = true;

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
                      if (value == null || value.isEmpty) {
                        return "Enter Your Name";
                      } else {
                        return null;
                      }
                    },
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(21),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Your Mobile Number";
                      } else if (value.length < 10) {
                        return "Enter a Valid Mobile Number";
                      } else {
                        return null;
                      }
                    },
                    controller: mobController,
                    decoration: InputDecoration(
                      hintText: "Mobile Number",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(21),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    validator: (value) {
                      RegExp emailReg = RegExp(
                        r'^[a-zA-Z0-9]+([._%+-]?[a-zA-Z0-9]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z]{2,})+$',
                      );
                      if (value == null || value.isEmpty) {
                        return "Enter Your Email";
                      } else if (!emailReg.hasMatch(value)) {
                        return "Enter a Valid Email";
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
                    obscureText: isHidden,
                    validator: (value) {
                      RegExp passReg = RegExp(
                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                      );
                      if (value == null || value.isEmpty) {
                        return "Enter a password";
                      } else if (!passReg.hasMatch(value)) {
                        return "Weak Password";
                      } else {
                        return null;
                      }
                    },
                    controller: passController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isHidden = !isHidden;
                          });
                        },
                        icon: Icon(
                          isHidden ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(21),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    obscureText: isConfirmPass,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Confirm Password";
                      } else if (value != passController.text) {
                        return "Password Does Not Match";
                      } else {
                        return null;
                      }
                    },
                    controller: confirmPassController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isConfirmPass = !isConfirmPass;
                          });
                        },
                        icon: Icon(
                          isConfirmPass
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(21),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  BlocConsumer<SignUpCubit,SignUpState>(
                    listener: (_, state) {
                      if (state is SignUpSuccessState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.black12,
                            content: Text("User Created Successfully"),
                          ),
                        );
                        Navigator.pop(context);
                      }else if(state is SignUpFailureState){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.black12,
                            content: Text(state.errMsg),
                          ),
                        );
                      }
                    },
                    builder: (_, state) {
                      if (state is SignUpLoadingState) {
                        return SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(21),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(width: 10),
                                Text("Creating User..."),
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
                              UserModel user = UserModel(
                                name: nameController.text,
                                email: emailController.text,
                                mobNo: mobController.text,
                                gender: "",
                                createdAt: DateTime.now().microsecondsSinceEpoch
                                    .toString(),
                                isOnline: false,
                                status: 1,
                                profilePic: "",
                                profileStatus: 1,
                              );
                              context.read<SignUpCubit>().signUpUser(
                                user: user,
                                pass: passController.text,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(21),
                            ),
                          ),
                          child: Text("Sign Up"),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.login);
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
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
