import 'dart:ui';

import 'package:chat_application/data/remote/firebase_repository.dart';
import 'package:chat_application/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/message_model.dart';

class ChatPage extends StatefulWidget {
  static DateFormat dtFormat = DateFormat.Hm();

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  FirebaseRepository firebaseRepository = FirebaseRepository.getInstance();
  List<MessageModel> listMsg = [];
  String fromId = "";
  final TextEditingController msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    initializeChatRoom();
  }

  @override
  void dispose() {
    msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  initializeChatRoom() async {
    fromId = await firebaseRepository.getFromId();
    setState(() {});
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
     UserModel? currModel = ModalRoute.of(context)!.settings.arguments as UserModel?;
     if(currModel==null){
       return Center(
         child: CircularProgressIndicator(),
       );
     }

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
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: -90,
                left: -70,
                child: _glowCircle(const Color(0xff4FC3F7), 220),
              ),
              Positioned(
                top: 130,
                right: -65,
                child: _glowCircle(const Color(0xff7E57C2), 190),
              ),
              Positioned(
                bottom: -90,
                left: 20,
                child: _glowCircle(const Color(0xff26C6DA), 240),
              ),
              Positioned(
                bottom: 90,
                right: -60,
                child: _glowCircle(const Color(0xff5C6BC0), 160),
              ),
              Column(
                children: [
                  ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(12, 8, 12, 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.10),
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
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 42,
                                  width: 42,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.08),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.all(2.5),
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
                                        .withOpacity(0.24),
                                    blurRadius: 12,
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 23,
                                backgroundColor: const Color(0xff132433),
                                backgroundImage: currModel!.profilePic != ""
                                    ? NetworkImage(currModel.profilePic!)
                                    : const AssetImage("assets/ic_user.png")
                                as ImageProvider,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currModel.name ?? "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.08),
                              ),
                              child: const Icon(
                                Icons.call_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.08),
                              ),
                              child: const Icon(
                                Icons.more_vert_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: firebaseRepository.getChatStream(
                        fromId: fromId,
                        toId: currModel.userId!,
                      ),
                      builder: (_, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xff8BE9FD),
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Container(
                              margin: const EdgeInsets.all(20),
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.06),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.redAccent.withOpacity(0.25),
                                ),
                              ),
                              child: Text(
                                snapshot.error.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }

                        if (!snapshot.hasData) {
                          return const SizedBox();
                        }

                        listMsg = List.generate(
                          snapshot.data!.docs.length,
                              (index) => MessageModel.fromDoc(
                            snapshot.data!.docs[index].data(),
                          ),
                        );

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _scrollToBottom();
                        });

                        if (snapshot.data!.docs.isNotEmpty) {
                          return ListView.builder(
                            controller: _scrollController,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
                            itemCount: listMsg.length,
                            itemBuilder: (_, index) {
                              return listMsg[index].fromId == fromId
                                  ? userChatBox(listMsg[index])
                                  : anotherUserChatBox(listMsg[index], index,currModel);
                            },
                          );
                        } else {
                          return Center(
                            child: Container(
                              margin: const EdgeInsets.all(24),
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.08),
                                    Colors.white.withOpacity(0.04),
                                  ],
                                ),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.08),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 72,
                                    width: 72,
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
                                              .withOpacity(0.25),
                                          blurRadius: 18,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.forum_rounded,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'No Messages yet!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Start the conversation today.',
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
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.10),
                          Colors.white.withOpacity(0.05),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.08),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.16),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 42,
                          width: 42,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.08),
                          ),
                          child: const Icon(
                            Icons.mic_rounded,
                            color: Color(0xff8BE9FD),
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: msgController,
                            enableSuggestions: true,
                            cursorColor: const Color(0xff8BE9FD),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText: "Write a message...",
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.50),
                                fontSize: 14,
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.06),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22),
                                borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.08),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22),
                                borderSide: const BorderSide(
                                  color: Color(0xff8BE9FD),
                                  width: 1.4,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              if (msgController.text.trim().isNotEmpty) {
                                firebaseRepository.sendTextMessage(
                                  toId: currModel.userId!,
                                  msg: msgController.text.trim(),
                                );
                                msgController.clear();

                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  _scrollToBottom();
                                });
                              }
                            },
                            child: Container(
                              height: 48,
                              width: 48,
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
                                    blurRadius: 14,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget userChatBox(MessageModel msgModel) {
    var time = ChatPage.dtFormat.format(
      DateTime.fromMillisecondsSinceEpoch(int.parse(msgModel.sentAt!)),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(width: MediaQuery.of(context).size.width * 0.16),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xff165460),
                  Color(0xff5C6BC0),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.10),
                width: 1.2,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(22),
                topRight: Radius.circular(22),
                bottomLeft: Radius.circular(22),
                bottomRight: Radius.circular(6),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff8BE9FD).withOpacity(0.18),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: msgModel.msgType == 0
                      ? Text(
                    msgModel.msg ?? "",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  )
                      : (msgModel.msg ?? "").isNotEmpty
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          msgModel.imgUrl ?? "",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        msgModel.msg ?? "",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                    ],
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      msgModel.imgUrl ?? "",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.done_all_rounded,
                      color: msgModel.readAt != ""
                          ? const Color(0xff8BE9FD)
                          : Colors.white.withOpacity(0.55),
                      size: 20,
                      shadows: msgModel.readAt != ""
                          ? [
                        Shadow(
                          color: const Color(0xff8BE9FD).withOpacity(0.45),
                          blurRadius: 6,
                        )
                      ]
                          : [],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.78),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget anotherUserChatBox(MessageModel msgModel, int index,UserModel currModel) {
    if (msgModel.readAt == "") {
      firebaseRepository.updateReadStatus(
        msgId: msgModel.msgId!,
        toId: currModel!.userId!,
        fromId: fromId,
      );
    }

    var time = ChatPage.dtFormat.format(
      DateTime.fromMillisecondsSinceEpoch(int.parse(msgModel.sentAt!)),
    );

    return Row(
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.11),
                  Colors.white.withOpacity(0.06),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.10),
                width: 1.2,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(22),
                topRight: Radius.circular(22),
                bottomLeft: Radius.circular(6),
                bottomRight: Radius.circular(22),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff8BE9FD),
                        Color(0xff5C6BC0),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: CircleAvatar(
                      backgroundColor: const Color(0xff132433),
                      backgroundImage: currModel.profilePic != ""
                          ? NetworkImage(currModel.profilePic!)
                          : const AssetImage("assets/ic_user.png")
                      as ImageProvider,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: msgModel.msgType == 0
                      ? Text(
                    msgModel.msg ?? "",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  )
                      : (msgModel.msg ?? "").isNotEmpty
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          msgModel.imgUrl ?? "",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        msgModel.msg ?? "",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                    ],
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      msgModel.imgUrl ?? "",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    time,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.65),
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(width: MediaQuery.of(context).size.width * 0.16),
      ],
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