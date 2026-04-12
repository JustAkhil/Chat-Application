import 'dart:ui';
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
  void dispose() {
    emailController.dispose();
    passController.dispose();
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
                                    Icons.chat_bubble_rounded,
                                    color: Colors.white,
                                    size: 38,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "Welcome Back..",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 29,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Sign in to continue your conversations",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.68),
                                    fontSize: 14.5,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 28),
                                TextFormField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  validator: (value) {
                                    if (value != null && value.isEmpty) {
                                      return "Enter Your Email";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: _inputDecoration(
                                    hint: "Email",
                                    icon: Icons.mail_outline_rounded,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: isPassHidden,
                                  controller: passController,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Enter a password";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: _inputDecoration(
                                    hint: "Password",
                                    icon: Icons.lock_outline_rounded,
                                    suffix: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isPassHidden = !isPassHidden;
                                        });
                                      },
                                      icon: Icon(
                                        isPassHidden
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 22),
                                BlocConsumer<LoginCubit, LoginState>(
                                  builder: (_, state) {
                                    if (state is LoginLoadingState) {
                                      return SizedBox(
                                        height: 58,
                                        width: double.infinity,
                                        child: _buildButton(
                                          onTap: () {},
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: const [
                                              SizedBox(
                                                height: 22,
                                                width: 22,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2.4,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(width: 12),
                                              Text("Login"),
                                            ],
                                          ),
                                        ),
                                      );
                                    }

                                    return SizedBox(
                                      height: 58,
                                      width: double.infinity,
                                      child: _buildButton(
                                        onTap: () {
                                          if (formKey.currentState!.validate()) {
                                            context.read<LoginCubit>().loginUser(
                                              email: emailController.text,
                                              pass: passController.text,
                                            );
                                          }
                                        },
                                        child: const Text("Login"),
                                      ),
                                    );
                                  },
                                  listener: (_, state) {
                                    if (state is LoginSuccessState) {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        AppRoutes.allMessagePage,
                                      );
                                      ScaffoldMessenger.of(context)
                                        ..hideCurrentSnackBar()
                                        ..showSnackBar(
                                          _customSnackBar(
                                            message: "Login Successfully",
                                            icon: Icons.check_circle_rounded,
                                            colors: const [
                                              Color(0xff7EE8FA),
                                              Color(0xff80D0C7),
                                            ],
                                            textColor: Colors.black,
                                          ),
                                        );
                                    } else if (state is LoginFailureState) {
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
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't have an account?",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.72),
                                        fontSize: 14,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, AppRoutes.signUp);
                                      },
                                      child: const Text(
                                        "Sign Up",
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