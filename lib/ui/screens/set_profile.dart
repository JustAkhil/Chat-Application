import 'dart:io';
import 'dart:ui';
import 'package:chat_application/data/remote/firebase_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/app_routes/app_routes.dart';

class SetProfilePage extends StatefulWidget {
  @override
  State<SetProfilePage> createState() => _SetProfilePageState();
}

class _SetProfilePageState extends State<SetProfilePage> {
  File? selectedImage;
  FirebaseRepository firebaseRepository = FirebaseRepository.getInstance();
  String? fromId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getFromId();
  }

  getFromId() async {
    fromId = await firebaseRepository.getFromId();
    setState(() {});
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
              child: _glowCircle(color: const Color(0xff4FC3F7), size: 220),
            ),
            Positioned(
              top: 120,
              right: -70,
              child: _glowCircle(color: const Color(0xff7E57C2), size: 180),
            ),
            Positioned(
              bottom: -100,
              left: 30,
              child: _glowCircle(color: const Color(0xff26C6DA), size: 260),
            ),
            Positioned(
              bottom: 80,
              right: -50,
              child: _glowCircle(color: const Color(0xff5C6BC0), size: 170),
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
                                    color: const Color(
                                      0xff8BE9FD,
                                    ).withOpacity(0.35),
                                    blurRadius: 24,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.person_rounded,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Set Profile Image",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Choose a profile picture to continue",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.68),
                                fontSize: 14.5,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 28),

                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  height: 140,
                                  width: 140,
                                  padding: const EdgeInsets.all(4),
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
                                        color: const Color(
                                          0xff8BE9FD,
                                        ).withOpacity(0.30),
                                        blurRadius: 24,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: const Color(0xff0A1622),
                                    backgroundImage: selectedImage != null
                                        ? FileImage(selectedImage!)
                                        : null,
                                    child: selectedImage == null
                                        ? const Icon(
                                            Icons.person,
                                            size: 65,
                                            color: Colors.white70,
                                          )
                                        : null,
                                  ),
                                ),
                                Container(
                                  height: 42,
                                  width: 42,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xff8BE9FD),
                                        Color(0xff5C6BC0),
                                      ],
                                    ),
                                    border: Border.all(
                                      color: const Color(0xff071018),
                                      width: 3,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xff8BE9FD,
                                        ).withOpacity(0.25),
                                        blurRadius: 16,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    onPressed: () async {
                                      await pickCropUploadImage(
                                        ImageSource.camera,
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            TextButton.icon(
                              onPressed: () async {
                                await pickCropUploadImage(ImageSource.gallery);
                              },
                              icon: const Icon(
                                Icons.photo_library_outlined,
                                color: Color(0xff8BE9FD),
                              ),
                              label: const Text(
                                "Choose Image",
                                style: TextStyle(
                                  color: Color(0xff8BE9FD),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            SizedBox(
                              height: 58,
                              width: double.infinity,
                              child: _buildButton(
                                onTap: () async {
                                  if (selectedImage == null) {
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        _customSnackBar(
                                          message: "Please Select Image",
                                          icon: Icons.error_rounded,
                                          colors: const [
                                            Color(0xffFF6B6B),
                                            Color(0xffFF8E53),
                                          ],
                                          textColor: Colors.white,
                                        ),
                                      );
                                    return;
                                  }

                                  if (fromId == null || fromId!.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("User not found")),
                                    );
                                    return;
                                  }

                                  setState(() {
                                    isLoading = true;
                                  });

                                  try {
                                    FirebaseStorage storage = FirebaseStorage.instance;

                                    Reference imgRef = storage
                                        .ref("profile_img")
                                        .child(fromId!)
                                        .child("${DateTime.now().millisecondsSinceEpoch}.jpg");

                                    var imgByte = await selectedImage!.readAsBytes();

                                    UploadTask uploadTask = imgRef.putData(imgByte);

                                    await uploadTask;

                                    String url = await imgRef.getDownloadURL();

                                    await firebaseRepository.addProfileImg(
                                      imgUrl: url,
                                      userId: fromId!,
                                    );

                                    if (!mounted) return;

                                    setState(() {
                                      isLoading = false;
                                    });

                                    Navigator.pushReplacementNamed(
                                      context,
                                      AppRoutes.allMessagePage,
                                    );
                                  } catch (e) {
                                    if (!mounted) return;

                                    setState(() {
                                      isLoading = false;
                                    });

                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        _customSnackBar(
                                          message: e.toString(),
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
                                child: isLoading
                                    ? CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text("Save Profile"),
                              ),
                            ),

                            const SizedBox(height: 14),
                          ],
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
    );
  }

  Widget _buildButton({required Widget child, required VoidCallback onTap}) {
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
              colors: [Color(0xff8BE9FD), Color(0xff5C6BC0)],
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

  Widget _glowCircle({required Color color, required double size}) {
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

  Future<void> pickCropUploadImage(ImageSource source) async {
    XFile? pickedImage = await ImagePicker().pickImage(
      source: source,
      imageQuality: 70,
    );

    if (pickedImage == null) return;

    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: pickedImage.path,
      uiSettings: [
        AndroidUiSettings(
          cropFrameColor: Colors.transparent,
          cropStyle: CropStyle.circle,
          lockAspectRatio: true,
          initAspectRatio: CropAspectRatioPreset.square,
          backgroundColor: Colors.black,
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
        ),
        IOSUiSettings(cropStyle: CropStyle.circle),
      ],
    );

    if (croppedImage == null) return;

    selectedImage = File(croppedImage.path);
    setState(() {});
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
}
