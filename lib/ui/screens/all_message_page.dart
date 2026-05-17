import 'dart:ui';

import 'package:chat_application/data/remote/firebase_repository.dart';
import 'package:chat_application/models/message_model.dart';
import 'package:chat_application/ui/screens/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_routes/app_routes.dart';
import '../../models/user_model.dart';
import '../../utils/utils_helper.dart';

class AllMessagePage extends StatefulWidget {
  @override
  State<AllMessagePage> createState() => _AllMessagePageState();
}

class _AllMessagePageState extends State<AllMessagePage> {
  FirebaseRepository firebaseRepository = FirebaseRepository.getInstance();
  String fromId = "";
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
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 74,
        backgroundColor: Colors.transparent,
        titleSpacing: 18,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.08),
                    Colors.white.withOpacity(0.03),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Messages",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 22,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 2),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.08),
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
              ),
            ),
            child: PopupMenuButton(
              color: const Color(0xff122636),
              icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              itemBuilder: (_) {
                return [
                  PopupMenuItem(
                    onTap: () {
                      Future.delayed(Duration(milliseconds: 300), () {
                        Navigator.pushNamed(context, AppRoutes.myProfilePage);
                      });
                    },
                    child: const Text(
                      "My Profile",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () async {
                      SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                      prefs.setString(FirebaseRepository.PREFS_USER_ID_KEY, "");
                      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login,(routes)=>false);
                    },
                    child: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ];
              },
            ),
          ),
        ],
      ),
      body: Container(
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
            StreamBuilder(
              stream: firebaseRepository.getLiveChatContactStream(fromId: fromId),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
                            color: const Color(0xff8BE9FD).withOpacity(0.10),
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
                                  color: const Color(0xff8BE9FD).withOpacity(0.28),
                                  blurRadius: 16,
                                ),
                              ],
                            ),
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.8,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Loading chat...",
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
                    child: Container(
                      margin: const EdgeInsets.all(22),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.redAccent.withOpacity(0.28),
                        ),
                      ),
                      child: Text(
                        snapshot.error.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                if (snapshot.hasData) {
                  var listUserId = List.generate(
                    snapshot.data!.docs.length,
                        (index) {
                      var mData =
                      snapshot.data!.docs[index].get("ids") as List<dynamic>;
                      mData.removeWhere((element) {
                        return element == fromId;
                      });
                      return mData[0];
                    },
                  );

                  if (listUserId.isEmpty) {
                    return Center(
                      child: Container(
                        margin: const EdgeInsets.all(24),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 28,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
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
                              color: Colors.black.withOpacity(0.18),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 76,
                              width: 76,
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
                                    color: const Color(0xff8BE9FD)
                                        .withOpacity(0.28),
                                    blurRadius: 18,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.chat_bubble_outline_rounded,
                                color: Colors.white,
                                size: 34,
                              ),
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              "No conversations yet",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Tap the + button to start your first conversation.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.65),
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(14, 16, 14, 100),
                    itemCount: listUserId.length,
                    itemBuilder: (_, index) {
                      return StreamBuilder(
                        stream: firebaseRepository.getUserStreamByUserId(
                          userId: listUserId[index],
                        ),
                        builder: (_, userSnapShot) {
                          if(userSnapShot.hasError){
                            return SizedBox();
                          }
                          final userDoc = userSnapShot.data;
                          final userData = userDoc?.data();
                          if(userData == null){
                            return SizedBox();
                          }
                          if (userSnapShot.hasData) {
                            var currModel =
                            UserModel.fromDoc(userData);

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(26),
                                onTap: () {
                                  Future.delayed(Duration(milliseconds: 300), () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.chatPage,
                                      arguments: currModel,
                                    );
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(13),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(26),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white.withOpacity(0.09),
                                        Colors.white.withOpacity(0.05),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.10),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.14),
                                        blurRadius: 18,
                                        offset: const Offset(0, 8),
                                      ),
                                      BoxShadow(
                                        color: const Color(0xff8BE9FD)
                                            .withOpacity(0.04),
                                        blurRadius: 12,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(2.8),
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
                                              color: const Color(0xff8BE9FD)
                                                  .withOpacity(0.22),
                                              blurRadius: 12,
                                            ),
                                          ],
                                        ),
                                        child: CircleAvatar(
                                          radius: 29,
                                          backgroundColor: Color(0xff132433),
                                          backgroundImage:(currModel.profilePic != null &&
                                              currModel.profilePic!.isNotEmpty)
                                              ? NetworkImage(currModel.profilePic!)
                                              : const AssetImage("assets/ic_user.png") as ImageProvider,
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
                                            StreamBuilder(
                                              stream: firebaseRepository
                                                  .getLastMessage(
                                                toId: currModel.userId!,
                                                fromId: fromId,
                                              ),
                                              builder: (
                                                  _,
                                                  lastMessageSnapshot,
                                                  ) {
                                                if (lastMessageSnapshot
                                                    .hasData &&
                                                    lastMessageSnapshot
                                                        .data!
                                                        .docs
                                                        .isNotEmpty) {
                                                  var lastMsg =
                                                  MessageModel.fromDoc(
                                                    lastMessageSnapshot
                                                        .data!
                                                        .docs[0]
                                                        .data(),
                                                  );

                                                  if (lastMsg.fromId ==
                                                      fromId) {
                                                    return Row(
                                                      children: [
                                                        Icon(
                                                          Icons.done_all_rounded,
                                                          color: lastMsg.readAt !=
                                                              ""
                                                              ? AppColors
                                                              .secondaryBlueColor
                                                              : Colors.white54,
                                                          size: 16,
                                                        ),
                                                        const SizedBox(width: 5),
                                                        Expanded(
                                                          child: Text(
                                                            lastMsg.msg ?? "",
                                                            maxLines: 1,
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                              color: Colors.white
                                                                  .withOpacity(
                                                                  0.72),
                                                              fontSize: 13.5,
                                                              fontWeight:
                                                              FontWeight.w400,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }

                                                  return Text(
                                                    lastMsg.msg ?? "",
                                                    maxLines: 1,
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.72),
                                                      fontSize: 13.5,
                                                      fontWeight:
                                                      FontWeight.w400,
                                                    ),
                                                  );
                                                }

                                                return Text(
                                                  currModel.email ?? "",
                                                  maxLines: 1,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(0.50),
                                                    fontSize: 13.2,
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        children: [
                                          StreamBuilder(
                                            stream: firebaseRepository
                                                .getLastMessage(
                                              toId: currModel.userId!,
                                              fromId: fromId,
                                            ),
                                            builder: (
                                                _,
                                                lastMessageTimeSnap,
                                                ) {
                                              if (lastMessageTimeSnap.hasData &&
                                                  lastMessageTimeSnap
                                                      .data!
                                                      .docs
                                                      .isNotEmpty) {
                                                var lastMsg =
                                                MessageModel.fromDoc(
                                                  lastMessageTimeSnap
                                                      .data!
                                                      .docs[0]
                                                      .data(),
                                                );

                                                var time = ChatPage.dtFormat
                                                    .format(
                                                  DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                    int.parse(lastMsg.sentAt!),
                                                  ),
                                                );

                                                return Text(
                                                  time,
                                                  style: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(0.50),
                                                    fontSize: 11.5,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                );
                                              }
                                              return const SizedBox();
                                            },
                                          ),
                                          const SizedBox(height: 10),
                                          StreamBuilder(
                                            stream: firebaseRepository
                                                .getUnReadCountMsg(
                                              fromId: fromId,
                                              toId: currModel.userId!,
                                            ),
                                            builder: (
                                                _,
                                                unReadCoundSnapShot,
                                                ) {
                                              if (unReadCoundSnapShot.hasData &&
                                                  unReadCoundSnapShot
                                                      .data!
                                                      .docs
                                                      .isNotEmpty) {
                                                return Container(
                                                  constraints:
                                                  const BoxConstraints(
                                                    minWidth: 23,
                                                    minHeight: 23,
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 7,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        999),
                                                    gradient:
                                                    const LinearGradient(
                                                      colors: [
                                                        Color(0xff8BE9FD),
                                                        Color(0xff5C6BC0),
                                                      ],
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: const Color(
                                                            0xff8BE9FD)
                                                            .withOpacity(0.30),
                                                        blurRadius: 12,
                                                      ),
                                                    ],
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "${unReadCoundSnapShot.data!.docs.length}",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                        FontWeight.w700,
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                              return const SizedBox(
                                                width: 0,
                                                height: 0,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            height: 88,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: Colors.white.withOpacity(0.05),
                            ),
                          );
                        },
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
      floatingActionButton: Container(
        height: 62,
        width: 62,
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
              color: const Color(0xff8BE9FD).withOpacity(0.35),
              blurRadius: 18,
              spreadRadius: 1,
            ),
          ],
        ),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.transparent,
          onPressed: () {
            Future.delayed(Duration(milliseconds: 300,),(){
              Navigator.pushNamed(context, AppRoutes.allContactsPage);
            });

          },
          child: const Icon(
            Icons.add_rounded,
            color: Colors.white,
            size: 30,
          ),
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