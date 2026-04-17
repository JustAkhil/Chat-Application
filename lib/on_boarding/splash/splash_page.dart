import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/remote/firebase_repository.dart';
import '../../ui/screens/all_message_page.dart';
import '../../ui/screens/set_profile.dart';
import '../login/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  FirebaseRepository firebaseRepository = FirebaseRepository.getInstance();

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () async {
      var prefs = await SharedPreferences.getInstance();
      String? value = prefs.getString(FirebaseRepository.PREFS_USER_ID_KEY);

      Widget nextPage = LoginPage();

      if (value != null && value.isNotEmpty) {

        final userDoc = await firebaseRepository.getUsersByUserId(userId: value);
        final data = userDoc.data();

        if (data != null) {
          String? profilePic = data["profilePic"];

          if (profilePic == null || profilePic.isEmpty) {
            nextPage = SetProfilePage();
          } else {
            nextPage = AllMessagePage();
          }
        }
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => nextPage,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff071018),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff06131D),
              Color(0xff0A1D2C),
              Color(0xff0D2436),
              Color(0xff091520),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -90,
              left: -70,
              child: _glowCircle(
                const Color(0xff4FC3F7),
                220,
              ),
            ),
            Positioned(
              top: 120,
              right: -70,
              child: _glowCircle(
                const Color(0xff7E57C2),
                190,
              ),
            ),
            Positioned(
              bottom: -100,
              left: 20,
              child: _glowCircle(
                const Color(0xff26C6DA),
                250,
              ),
            ),
            Positioned(
              bottom: 80,
              right: -60,
              child: _glowCircle(
                const Color(0xff5C6BC0),
                170,
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(34),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Container(
                        height: 150,
                        width: 150,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(34),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.12),
                              Colors.white.withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.18),
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            ),
                            BoxShadow(
                              color: const Color(0xff8BE9FD).withOpacity(0.10),
                              blurRadius: 24,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xff8BE9FD),
                                Color(0xff5C6BC0),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xff8BE9FD).withOpacity(0.28),
                                blurRadius: 20,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            backgroundColor:Color(0xff8BE9FD) ,
                            backgroundImage: AssetImage(
                              'assets/Gemini_Generated_Image_70hf0x70hf0x70hf.png',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  const Text(
                    "Chat Application",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 26),
                  Container(
                    width: 44,
                    height: 44,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.08),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.10),
                      ),
                    ),
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.6,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xff8BE9FD),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glowCircle(Color color, double size) {
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