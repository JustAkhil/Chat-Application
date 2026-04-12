import 'dart:ui';

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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isHidden = true;
  bool isConfirmPass = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    mobController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xff8BE9FD),
          selectionColor: Color(0x558BE9FD),
          selectionHandleColor: Color(0xff8BE9FD),
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xff071018),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xff06131D),
                Color(0xff0A1D2C),
                Color(0xff0D2436),
                Color(0xff091520),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -80,
                left: -60,
                child: _glowCircle(
                  color: const Color(0xff4FC3F7),
                  size: 220,
                ),
              ),
              Positioned(
                top: 120,
                right: -70,
                child: _glowCircle(
                  color: const Color(0xff7E57C2),
                  size: 180,
                ),
              ),
              Positioned(
                bottom: -100,
                left: 30,
                child: _glowCircle(
                  color: const Color(0xff26C6DA),
                  size: 260,
                ),
              ),
              Positioned(
                bottom: 80,
                right: -50,
                child: _glowCircle(
                  color: const Color(0xff5C6BC0),
                  size: 170,
                ),
              ),
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 20,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 430),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 28,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.12),
                                Colors.white.withOpacity(0.05),
                              ],
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.14),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.22),
                                blurRadius: 32,
                                spreadRadius: 2,
                                offset: const Offset(0, 12),
                              ),
                              BoxShadow(
                                color: const Color(0xff4FC3F7).withOpacity(0.08),
                                blurRadius: 28,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 82,
                                  width: 82,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xff8BE9FD),
                                        Color(0xff5C6BC0),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xff8BE9FD).withOpacity(0.35),
                                        blurRadius: 24,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.person_add_alt_1_rounded,
                                    color: Colors.white,
                                    size: 38,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "Create Account",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 29,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Join now and start your conversations",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.68),
                                    fontSize: 14.5,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: nameController,
                                  cursorColor: const Color(0xff8BE9FD),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "Enter Your Name";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: _inputDecoration(
                                    hint: "Enter your full name",
                                    icon: Icons.person_outline_rounded,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: mobController,
                                  cursorColor: const Color(0xff8BE9FD),
                                  keyboardType: TextInputType.phone,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Enter Your Mobile Number";
                                    } else if (value.length < 10) {
                                      return "Enter a Valid Mobile Number";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: _inputDecoration(
                                    hint: "Enter your mobile number",
                                    icon: Icons.phone_android_rounded,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: emailController,
                                  cursorColor: const Color(0xff8BE9FD),
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
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
                                  decoration: _inputDecoration(
                                    hint: "Enter your email",
                                    icon: Icons.mail_outline_rounded,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: passController,
                                  obscureText: isHidden,
                                  cursorColor: const Color(0xff8BE9FD),
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
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
                                  decoration: _inputDecoration(
                                    hint: "Enter your password",
                                    icon: Icons.lock_outline_rounded,
                                    suffix: IconButton(
                                      splashRadius: 22,
                                      onPressed: () {
                                        setState(() {
                                          isHidden = !isHidden;
                                        });
                                      },
                                      icon: Icon(
                                        isHidden
                                            ? Icons.visibility_rounded
                                            : Icons.visibility_off_rounded,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: confirmPassController,
                                  obscureText: isConfirmPass,
                                  cursorColor: const Color(0xff8BE9FD),
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Confirm Password";
                                    } else if (value != passController.text) {
                                      return "Password Does Not Match";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: _inputDecoration(
                                    hint: "Re-enter your password",
                                    icon: Icons.verified_user_outlined,
                                    suffix: IconButton(
                                      splashRadius: 22,
                                      onPressed: () {
                                        setState(() {
                                          isConfirmPass = !isConfirmPass;
                                        });
                                      },
                                      icon: Icon(
                                        isConfirmPass
                                            ? Icons.visibility_rounded
                                            : Icons.visibility_off_rounded,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 26),

                                BlocConsumer<SignUpCubit, SignUpState>(
                                  listener: (_, state) {
                                    if (state is SignUpSuccessState) {
                                      ScaffoldMessenger.of(context)
                                        ..hideCurrentSnackBar()
                                        ..showSnackBar(
                                          _customSnackBar(
                                            message: "User Created Successfully",
                                            icon: Icons.check_circle_rounded,
                                            colors: const [
                                              Color(0xff7EE8FA),
                                              Color(0xff80D0C7),
                                            ],
                                            textColor: Colors.black,
                                          ),
                                        );
                                      Navigator.pop(context);
                                    } else if (state is SignUpFailureState) {
                                      ScaffoldMessenger.of(context)
                                        ..hideCurrentSnackBar()
                                        ..showSnackBar(
                                          _customSnackBar(
                                            message: state.errMsg,
                                            icon: Icons.error_rounded,
                                            colors: const [
                                              Color(0xffFF6B6B),
                                              Color(0xffFF8E53),
                                            ],
                                            textColor: Colors.white,
                                          ),
                                        );
                                    }
                                  },
                                  builder: (_, state) {
                                    if (state is SignUpLoadingState) {
                                      return AnimatedOpacity(
                                        duration: const Duration(milliseconds: 250),
                                        opacity: 0.92,
                                        child: _buildButton(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: const [
                                              SizedBox(
                                                height: 22,
                                                width: 22,
                                                child: CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2.3,
                                                ),
                                              ),
                                              SizedBox(width: 12),
                                              Text("Creating User..."),
                                            ],
                                          ),
                                          onTap: () {},
                                        ),
                                      );
                                    }

                                    return _buildButton(
                                      child: const Text("SIGN UP"),
                                      onTap: () {
                                        if (formKey.currentState!.validate()) {
                                          UserModel user = UserModel(
                                            name: nameController.text,
                                            email: emailController.text,
                                            mobNo: mobController.text,
                                            gender: "",
                                            createdAt: DateTime.now()
                                                .microsecondsSinceEpoch
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
                                    );
                                  },
                                ),

                                const SizedBox(height: 24),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: Colors.white.withOpacity(0.12),
                                        thickness: 1,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      child: Text(
                                        "OR",
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.55),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: Colors.white.withOpacity(0.12),
                                        thickness: 1,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Already have an account?",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.72),
                                        fontSize: 14,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          AppRoutes.login,
                                        );
                                      },
                                      child: const Text(
                                        "Login",
                                        style: TextStyle(
                                          color: Color(0xff8BE9FD),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
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
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white.withOpacity(0.88),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.white.withOpacity(0.38),
        fontSize: 14,
      ),
      prefixIcon: Container(
        margin: const EdgeInsets.only(left: 10, right: 8),
        child: Icon(
          icon,
          color: const Color(0xff8BE9FD),
          size: 21,
        ),
      ),
      prefixIconConstraints: const BoxConstraints(
        minWidth: 45,
        minHeight: 45,
      ),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white.withOpacity(0.07),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.10),
          width: 1.1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Color(0xff8BE9FD),
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.2,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.5,
        ),
      ),
    );
  }

  Widget _buildButton({
    required Widget child,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          height: 58,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xff8BE9FD),
                Color(0xff5C6BC0),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff8BE9FD).withOpacity(0.25),
                blurRadius: 18,
                spreadRadius: 1,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: DefaultTextStyle(
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15.5,
                letterSpacing: 0.8,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  SnackBar _customSnackBar({
    required String message,
    required IconData icon,
    required List<Color> colors,
    required Color textColor,
  }) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(colors: colors),
          boxShadow: [
            BoxShadow(
              color: colors.first.withOpacity(0.28),
              blurRadius: 16,
              spreadRadius: 1,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: textColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glowCircle({
    required Color color,
    required double size,
  }) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.10),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.25),
            blurRadius: 90,
            spreadRadius: 18,
          ),
        ],
      ),
    );
  }
}