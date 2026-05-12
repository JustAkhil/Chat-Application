import 'dart:io';
import 'dart:ui';

import 'package:chat_application/data/remote/firebase_repository.dart';
import 'package:chat_application/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  FirebaseRepository firebaseRepository = FirebaseRepository.getInstance();

  String? fromId;
  Future<dynamic>? userFuture;

  bool isEditName = false;
  bool isUploadingImage = false;

  TextEditingController nameController = TextEditingController();

  String currentName = "";
  String currentProfilePic = "";
  String currentEmail = "";
  String currentPhone = "";
  String currentUserId = "";

  File? selectedImage;

  @override
  void initState() {
    super.initState();
    getFromId();
  }

  Future<void> getFromId() async {
    fromId = await firebaseRepository.getFromId();
    userFuture = firebaseRepository.getUserDetailByUserId(userId: fromId!);
    setState(() {});
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff071018),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.08),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
        title: const Text(
          "My Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 22,
            letterSpacing: 0.4,
          ),
        ),
      ),
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
              child: _glowCircle(const Color(0xff4FC3F7), 220),
            ),
            Positioned(
              top: 140,
              right: -60,
              child: _glowCircle(const Color(0xff7E57C2), 180),
            ),
            Positioned(
              bottom: -100,
              left: 20,
              child: _glowCircle(const Color(0xff26C6DA), 250),
            ),
            Positioned(
              bottom: 60,
              right: -50,
              child: _glowCircle(const Color(0xff5C6BC0), 170),
            ),
            fromId == null || userFuture == null
                ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xff8BE9FD),
              ),
            )
                : FutureBuilder(
              future: userFuture,
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.08),
                            Colors.white.withOpacity(0.04),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.16),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                          BoxShadow(
                            color: const Color(
                              0xff8BE9FD,
                            ).withOpacity(0.10),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 54,
                            width: 54,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xff8BE9FD),
                                  Color(0xff5C6BC0),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xff8BE9FD,
                                  ).withOpacity(0.28),
                                  blurRadius: 16,
                                ),
                              ],
                            ),
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.8,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Loading Data...",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.78),
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data?.data() == null) {
                  return const Center(
                    child: Text(
                      "User data not found",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                UserModel currUser = UserModel.fromDoc(
                  snapshot.data!.data()!,
                );

                if (currentUserId.isEmpty) {
                  currentUserId = currUser.userId ?? "";
                  currentName = currUser.name ?? "";
                  currentProfilePic = currUser.profilePic ?? "";
                  currentEmail = currUser.email ?? "";
                  currentPhone = currUser.mobNo ?? "";
                  nameController.text = currentName;
                }

                return Center(
                  child: SingleChildScrollView(
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
                          constraints: const BoxConstraints(
                            maxWidth: 430,
                          ),
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
                                color: const Color(
                                  0xff4FC3F7,
                                ).withOpacity(0.08),
                                blurRadius: 28,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        height: 124,
                                        width: 124,
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
                                          backgroundColor:
                                          const Color(0xff0A1622),
                                          backgroundImage: selectedImage !=
                                              null
                                              ? FileImage(selectedImage!)
                                              : (currentProfilePic
                                              .isNotEmpty
                                              ? NetworkImage(
                                            currentProfilePic,
                                          )
                                              : null),
                                          child: selectedImage == null &&
                                              currentProfilePic
                                                  .isEmpty
                                              ? const Icon(
                                            Icons.person,
                                            size: 58,
                                            color: Colors.white70,
                                          )
                                              : null,
                                        ),
                                      ),
                                      if (isUploadingImage)
                                        Container(
                                          height: 124,
                                          width: 124,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black
                                                .withOpacity(0.45),
                                          ),
                                          child: const Center(
                                            child:
                                            CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 3,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  Positioned(
                                    bottom: 4,
                                    right: 4,
                                    child: InkWell(
                                      onTap: () async {
                                        showModalBottomSheet(
                                          context: context,
                                          backgroundColor:
                                          Colors.transparent,
                                          builder: (context) {
                                            return Container(
                                              margin: const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 10,
                                              ),
                                              padding:
                                              const EdgeInsets.fromLTRB(
                                                20,
                                                14,
                                                20,
                                                24,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(
                                                  28,
                                                ),
                                                gradient: LinearGradient(
                                                  begin:
                                                  Alignment.topLeft,
                                                  end: Alignment
                                                      .bottomRight,
                                                  colors: [
                                                    Colors.white
                                                        .withOpacity(
                                                      0.10,
                                                    ),
                                                    Colors.white
                                                        .withOpacity(
                                                      0.05,
                                                    ),
                                                  ],
                                                ),
                                                border: Border.all(
                                                  color: Colors.white
                                                      .withOpacity(0.10),
                                                  width: 1.2,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(
                                                      0.25,
                                                    ),
                                                    blurRadius: 24,
                                                    offset: const Offset(
                                                      0,
                                                      10,
                                                    ),
                                                  ),
                                                  BoxShadow(
                                                    color: const Color(
                                                      0xff8BE9FD,
                                                    ).withOpacity(0.08),
                                                    blurRadius: 22,
                                                    spreadRadius: 1,
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                mainAxisSize:
                                                MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    width: 42,
                                                    height: 5,
                                                    margin:
                                                    const EdgeInsets.only(
                                                      bottom: 18,
                                                    ),
                                                    decoration:
                                                    BoxDecoration(
                                                      color: Colors
                                                          .white
                                                          .withOpacity(
                                                        0.22,
                                                      ),
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                        20,
                                                      ),
                                                    ),
                                                  ),
                                                  const Text(
                                                    "Choose Profile Photo",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 17,
                                                      fontWeight:
                                                      FontWeight.w700,
                                                      letterSpacing: 0.3,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 22,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                    children: [
                                                      _bottomSheetOption(
                                                        icon: Icons
                                                            .camera_alt_rounded,
                                                        label: "Camera",
                                                        onTap: () async {
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                          await pickCropUploadImage(
                                                            ImageSource
                                                                .camera,
                                                          );
                                                        },
                                                      ),
                                                      _bottomSheetOption(
                                                        icon: Icons
                                                            .photo_library_rounded,
                                                        label: "Gallery",
                                                        onTap: () async {
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                          await pickCropUploadImage(
                                                            ImageSource
                                                                .gallery,
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xff8BE9FD),
                                              Color(0xff5C6BC0),
                                            ],
                                          ),
                                          border: Border.all(
                                            color: const Color(
                                              0xff091520,
                                            ),
                                            width: 2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(
                                                0xff8BE9FD,
                                              ).withOpacity(0.4),
                                              blurRadius: 10,
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              Text(
                                currentName.isNotEmpty
                                    ? currentName
                                    : "No Name",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                currentEmail.isNotEmpty
                                    ? currentEmail
                                    : "No Email",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.68),
                                  fontSize: 14.5,
                                ),
                              ),
                              const SizedBox(height: 26),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.08),
                                      Colors.white.withOpacity(0.04),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.10),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 44,
                                      width: 44,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xff8BE9FD),
                                            Color(0xff5C6BC0),
                                          ],
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.person_outline_rounded,
                                        color: Colors.white,
                                        size: 21,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Name",
                                            style: TextStyle(
                                              color: Colors.white
                                                  .withOpacity(0.65),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          isEditName
                                              ? TextField(
                                            cursorColor:
                                            Colors.white,
                                            controller:
                                            nameController,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.5,
                                              fontWeight:
                                              FontWeight.w600,
                                            ),
                                            decoration:
                                            const InputDecoration(
                                              border:
                                              UnderlineInputBorder(
                                                borderSide:
                                                BorderSide(
                                                  color:
                                                  Colors.white,
                                                ),
                                              ),
                                              focusedBorder:
                                              UnderlineInputBorder(
                                                borderSide:
                                                BorderSide(
                                                  color:
                                                  Colors.white,
                                                ),
                                              ),
                                              enabledBorder:
                                              UnderlineInputBorder(
                                                borderSide:
                                                BorderSide(
                                                  color:
                                                  Colors.white54,
                                                ),
                                              ),
                                              hintText:
                                              "Enter name",
                                              hintStyle:
                                              TextStyle(
                                                color: Colors
                                                    .white54,
                                              ),
                                              isDense: true,
                                            ),
                                          )
                                              : Text(
                                            currentName.isNotEmpty
                                                ? currentName
                                                : "Not available",
                                            maxLines: 2,
                                            overflow: TextOverflow
                                                .ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.5,
                                              fontWeight:
                                              FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    InkWell(
                                      onTap: () async {
                                        if (isEditName) {
                                          String updatedName =
                                          nameController.text.trim();

                                          if (updatedName.isEmpty) {
                                            ScaffoldMessenger.of(context)
                                              ..hideCurrentSnackBar()
                                              ..showSnackBar(
                                                _customSnackBar(
                                                  message:
                                                  "Name cannot be empty",
                                                  icon: Icons
                                                      .error_rounded,
                                                  colors: const [
                                                    Color(0xffFF6B6B),
                                                    Color(0xffFF8E53),
                                                  ],
                                                  textColor: Colors.white,
                                                ),
                                              );
                                            return;
                                          }

                                          await firebaseRepository
                                              .updateFullProfile(
                                            userId: currentUserId,
                                            name: updatedName,
                                            profilePic:
                                            currentProfilePic,
                                          );

                                          setState(() {
                                            currentName = updatedName;
                                            isEditName = false;
                                          });
                                        } else {
                                          setState(() {
                                            isEditName = true;
                                          });
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white.withOpacity(
                                            0.08,
                                          ),
                                          border: Border.all(
                                            color: Colors.white
                                                .withOpacity(0.10),
                                          ),
                                        ),
                                        child: Icon(
                                          isEditName
                                              ? Icons.check
                                              : Icons.edit,
                                          color: const Color(0xff8BE9FD),
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.08),
                                      Colors.white.withOpacity(0.04),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.10),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 44,
                                      width: 44,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xff8BE9FD),
                                            Color(0xff5C6BC0),
                                          ],
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.mail_outline_rounded,
                                        color: Colors.white,
                                        size: 21,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Email",
                                            style: TextStyle(
                                              color: Colors.white
                                                  .withOpacity(0.65),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            currentEmail.isNotEmpty
                                                ? currentEmail
                                                : "Not available",
                                            maxLines: 2,
                                            overflow:
                                            TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.5,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.08),
                                      Colors.white.withOpacity(0.04),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.10),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 44,
                                      width: 44,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xff8BE9FD),
                                            Color(0xff5C6BC0),
                                          ],
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.badge_outlined,
                                        color: Colors.white,
                                        size: 21,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Phone Number",
                                            style: TextStyle(
                                              color: Colors.white
                                                  .withOpacity(0.65),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            currentPhone.isNotEmpty
                                                ? currentPhone
                                                : "Not available",
                                            maxLines: 2,
                                            overflow:
                                            TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.5,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
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

    setState(() {
      isUploadingImage = true;
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

      await firebaseRepository.updateFullProfile(
        userId: currentUserId,
        name: currentName,
        profilePic: url,
      );

      setState(() {
        currentProfilePic = url;
        isUploadingImage = false;
        selectedImage = null;
      });
    } catch (e) {
      setState(() {
        isUploadingImage = false;
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
  }

  Widget _bottomSheetOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        width: 130,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.08),
              Colors.white.withOpacity(0.04),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: Colors.white.withOpacity(0.10),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff8BE9FD),
                    Color(0xff5C6BC0),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff8BE9FD).withOpacity(0.25),
                    blurRadius: 14,
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.88),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
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
}