import 'package:chat_application/data/remote/firebase_repository.dart';
import 'package:chat_application/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/message_model.dart';
import '../../utils/utils_helper.dart';

class ChatPage extends StatefulWidget {
  static DateFormat dtFormat = DateFormat.Hm();

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  FirebaseRepository firebaseRepository = FirebaseRepository.getInstance();
  List<MessageModel> listMsg = [];
  String fromId = "";
  var msgController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeChatRoom();
  }
  initializeChatRoom() async {
    fromId = await firebaseRepository.getFromId();
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    UserModel currModel =
        ModalRoute.of(context)!.settings.arguments as UserModel;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.mainBlack,
        body: Column(
          children: [
            Container(
              color: AppColors.semiBlack,
              child: Padding(
                padding: const EdgeInsets.all(11.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios_sharp),
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 25,
                      height: 25,
                      child: CircleAvatar(
                        backgroundColor: AppColors.secondaryYellowColor,
                        backgroundImage: currModel.profilePic != ""
                            ? NetworkImage(currModel.profilePic!)
                            : AssetImage("assets/ic_user.png"),
                        radius: 25,
                      ),
                    ),
                    SizedBox(width: 11),
                    Text(
                      currModel.name!,
                      style: mTextStyle16(mColor: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: firebaseRepository.getChatStream(
                      fromId: fromId, toId: currModel.userId!),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    listMsg = List.generate(
                        snapshot.data!.docs.length,
                            (index) => MessageModel.fromDoc(
                            snapshot.data!.docs[index].data()));

                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      return ListView.builder(
                          itemCount: listMsg.length,
                          itemBuilder: (_, index) {
                            return listMsg[index].fromId == fromId
                                ? userChatBox(listMsg[index])
                                : anotherUserChatBox(listMsg[index], index);
                          });
                    } else {
                      return Center(
                        child: Text(
                          'No Messages yet!,\nstart the conversation today..',
                          style: mTextStyle16(mColor: AppColors.semiBlack),
                        ),
                      );
                    }
                  },
                )),
            SizedBox(height: 7),
            TextField(
              controller: msgController,
              enableSuggestions: true,
              style: mTextStyle16(mColor: Colors.grey),
              decoration: InputDecoration(
                suffixIcon: InkWell(
                  onTap: () {
                    firebaseRepository.sendTextMessage(
                      toId: currModel.userId!,
                      msg: msgController.text,
                    );
                    msgController.clear();
                  },
                  child: Icon(Icons.send_rounded, color: Colors.grey),
                ),
                prefixIcon: Icon(Icons.mic, color: Colors.grey),
                fillColor: AppColors.semiBlack,
                filled: true,
                hintText: "Write a message!",
                hintStyle: mTextStyle16(mColor: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(21),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///rightSideBox
  Widget userChatBox(MessageModel msgModel) {
    var time = ChatPage.dtFormat.format(
      DateTime.fromMillisecondsSinceEpoch(int.parse(msgModel.sentAt!)),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.ideographic,
      children: [
        Container(width: MediaQuery.of(context).size.width * 0.15),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(11),
            margin: EdgeInsets.all(7),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 2,
              ),
              color: AppColors.mediumBlack,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(21),
                topRight: Radius.circular(21),
                bottomLeft: Radius.circular(21),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: msgModel.msgType == 0
                      ? Text(
                          msgModel.msg!,
                          style: mTextStyle16(mColor: Colors.white),
                        )
                      : msgModel.msg != ""
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(msgModel.imgUrl!),
                            SizedBox(height: 5),
                            Text(
                              msgModel.msg!,
                              style: mTextStyle16(mColor: Colors.white),
                            ),
                          ],
                        )
                      : Image.network(msgModel.imgUrl!),
                ),
                SizedBox(width: 11),
                Icon(
                  Icons.done_all_rounded,
                  color: msgModel.readAt != ""
                      ? AppColors.secondaryBlueColor
                      : Colors.white.withOpacity(0.5),
                  size: 14,
                ),
                SizedBox(width: 5),
                Flexible(
                  child: Text(time, style: mTextStyle10(mColor: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  ///leftSideBox
  Widget anotherUserChatBox(MessageModel msgModel, int index) {

    var time = ChatPage.dtFormat.format(
      DateTime.fromMillisecondsSinceEpoch(int.parse(msgModel.sentAt!)),
    );

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(11),
            margin: EdgeInsets.all(7),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.secondaryDarkBlueColor.withOpacity(0.5),
                width: 2,
              ),
              color: AppColors.secondaryBlueColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(21),
                topRight: Radius.circular(21),
                bottomRight: Radius.circular(21),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7.0),
                    child: msgModel.msgType == 0
                        ? Text(
                            msgModel.msg!,
                            style: mTextStyle16(mColor: Colors.black),
                          )
                        : Image.network(msgModel.imgUrl!),
                  ),
                ),
                Flexible(
                  child: Text(time, style: mTextStyle10(mColor: Colors.black)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
