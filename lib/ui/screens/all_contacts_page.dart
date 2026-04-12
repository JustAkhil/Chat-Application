import 'dart:ui';

import 'package:chat_application/constants/app_routes/app_routes.dart';
import 'package:chat_application/data/remote/firebase_repository.dart';
import 'package:chat_application/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllContactPage extends StatefulWidget {
  String fromId = "";

  @override
  State<AllContactPage> createState() => _AllContactPageState();
}

class _AllContactPageState extends State<AllContactPage> {
  FirebaseRepository firebaseRepository = FirebaseRepository.getInstance();

  @override
  void initState() {
    super.initState();
    getFromId();
  }

  getFromId() async {
    widget.fromId = await firebaseRepository.getFromId();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff07111A),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.08),
                    Colors.white.withOpacity(0.04),
                  ],
                ),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
              ),
            ),
          ),
        ),
        title: const Text(
          "Contacts",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff07111A),
              Color(0xff0B1F2E),
              Color(0xff102B3F),
              Color(0xff071822),
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
              child: _glowCircle(const Color(0xff00E5FF)),
            ),
            Positioned(
              top: 140,
              right: -60,
              child: _glowCircle(const Color(0xff7C4DFF)),
            ),
            Positioned(
              bottom: -100,
              left: 20,
              child: _glowCircle(const Color(0xff00B0FF)),
            ),
            FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: firebaseRepository.getAllContacts(),
              builder: (_, snapshots) {
                if (snapshots.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.cyanAccent,
                    ),
                  );
                }

                if (snapshots.hasError) {
                  return Center(
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.redAccent.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        snapshots.error.toString(),
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                if (snapshots.hasData) {
                  var listContact = List.generate(snapshots.data!.docs.length, (
                      index,
                      ) {
                    return UserModel.fromDoc(snapshots.data!.docs[index].data());
                  });

                  listContact.removeWhere((element) {
                    return element.userId == widget.fromId;
                  });

                  if (listContact.isEmpty) {
                    return Center(
                      child: Container(
                        margin: const EdgeInsets.all(24),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          color: Colors.white.withOpacity(0.06),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.people_alt_outlined,
                              size: 54,
                              color: Colors.cyanAccent.withOpacity(0.9),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              "No contacts found",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Your contact universe is empty right now.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.68),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(14, 16, 14, 20),
                    itemCount: listContact.length,
                    itemBuilder: (_, index) {
                      UserModel currModel = listContact[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.chatPage,
                              arguments: currModel,
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: Colors.white.withOpacity(0.07),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.10),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.cyanAccent.withOpacity(0.06),
                                  blurRadius: 16,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(2.5),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xff00E5FF),
                                          Color(0xff2979FF),
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.cyanAccent.withOpacity(
                                            0.25,
                                          ),
                                          blurRadius: 12,
                                        ),
                                      ],
                                    ),
                                    child: const CircleAvatar(
                                      radius: 28,
                                      backgroundColor: Color(0xff122636),
                                      backgroundImage: AssetImage(
                                        "assets/ic_user.png",
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          currModel.name ?? "",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          currModel.email ?? "",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(
                                              0.68,
                                            ),
                                            fontSize: 13.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    height: 42,
                                    width: 42,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(0.06),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.08),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.chat_bubble_outline_rounded,
                                      color: Colors.cyanAccent,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _glowCircle(Color color) {
    return Container(
      height: 220,
      width: 220,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.18),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.45),
            blurRadius: 100,
            spreadRadius: 18,
          ),
        ],
      ),
    );
  }
}