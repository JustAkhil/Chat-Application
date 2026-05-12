import 'package:chat_application/models/message_model.dart';
import 'package:chat_application/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseRepository {
  FirebaseRepository._();

  static FirebaseRepository getInstance() => FirebaseRepository._();

  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static const String COLLECTION_USERS = "users";
  static const String COLLECTION_CHATROOM = "chatroom";
  static const String COLLECTION_MESSAGES = "messages";
  static const String PREFS_USER_ID_KEY = "userId";

  Future<void> createUser({
    required UserModel user,
    required String pass,
  }) async {
    try {
      UserCredential userCred = await firebaseAuth
          .createUserWithEmailAndPassword(email: user.email!, password: pass);
      if (userCred.user != null) {
        user.userId = userCred.user!.uid;
        await firestore
            .collection(COLLECTION_USERS)
            .doc(userCred.user!.uid)
            .set(user.toDoc())
            .catchError((error) {
              throw (Exception("Error:$error"));
            });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw "Password is too weak";
      } else if (e.code == 'email-already-in-use') {
        throw "Email already exists";
      } else if (e.code == 'invalid-email') {
        throw "Invalid Email";
      } else {
        throw e.message ?? "Signup failed";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> loginUser({required String email, required String pass}) async {
    try {
      UserCredential userCred = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      if (userCred.user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(PREFS_USER_ID_KEY, userCred.user!.uid);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        throw "Invalid email or password";
      } else if (e.code == 'invalid-email') {
        throw "Invalid email format";
      } else if (e.code == 'user-disabled') {
        throw "Account disabled";
      } else if (e.code == 'too-many-requests') {
        throw "Too many attempts. Try later";
      } else {
        throw "Login failed. Try again";
      }
    } catch (e) {
      throw "Something went wrong";
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllContacts() {
    return firestore.collection(COLLECTION_USERS).get();
  }

  Future<String> getFromId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(PREFS_USER_ID_KEY)!;
  }

  String getChatId({required String toId, required String fromId}) {
    if (toId.hashCode <= fromId.hashCode) {
      return "${toId}_$fromId";
    } else {
      return "${fromId}_$toId";
    }
  }

  sendTextMessage({required String toId, required String msg}) async {
    String fromId = await getFromId();
    String chatId = getChatId(fromId: fromId, toId: toId);
    var currTime = DateTime.now().millisecondsSinceEpoch.toString();
    var msgModel = MessageModel(
      msgId: currTime,
      msg: msg,
      sentAt: currTime,
      fromId: fromId,
      toId: toId,
    );
    firestore.collection(COLLECTION_CHATROOM).doc(chatId).get().then((value) {
      if (value.exists) {
        firestore
            .collection(COLLECTION_CHATROOM)
            .doc(chatId)
            .collection(COLLECTION_MESSAGES)
            .doc(currTime)
            .set(msgModel.toDoc());
      } else {
        firestore
            .collection(COLLECTION_CHATROOM)
            .doc(chatId)
            .set({
              'ids': [fromId, toId],
            })
            .then(
              (value) => firestore
                  .collection(COLLECTION_CHATROOM)
                  .doc(chatId)
                  .collection(COLLECTION_MESSAGES)
                  .doc(currTime)
                  .set(msgModel.toDoc()),
            );
      }
    });
  }

  sendImgMessage({required String toId, required String imgUrl}) async {
    String fromId = await getFromId();
    String chatId = getChatId(fromId: fromId, toId: toId);
    var currTime = DateTime.now().microsecondsSinceEpoch.toString();
    var msgModel = MessageModel(
      msgId: currTime,
      msg: "",
      sentAt: currTime,
      fromId: fromId,
      toId: toId,
      imgUrl: imgUrl,
      msgType: 1,
    );
    await firestore
        .collection(COLLECTION_CHATROOM)
        .doc(chatId)
        .collection(COLLECTION_MESSAGES)
        .doc(currTime)
        .set(msgModel.toDoc());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatStream({
    required String toId,
    required String fromId,
  }) {
    String chatId = getChatId(toId: toId, fromId: fromId);
    return firestore
        .collection(COLLECTION_CHATROOM)
        .doc(chatId)
        .collection(COLLECTION_MESSAGES)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getLiveChatContactStream({
    required String fromId,
  }) {
    return firestore
        .collection(COLLECTION_CHATROOM)
        .where("ids", arrayContains: fromId)
        .snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetailByUserId({
    required String userId,
  }) {
    return firestore.collection(COLLECTION_USERS).doc(userId).get();
  }

  void updateReadStatus({
    required String msgId,
    required String toId,
    required String fromId,
  }) {
    var currTime = DateTime.now().microsecondsSinceEpoch.toString();
    var chatId = getChatId(fromId: fromId, toId: toId);
    firestore
        .collection(COLLECTION_CHATROOM)
        .doc(chatId)
        .collection(COLLECTION_MESSAGES)
        .doc(msgId)
        .update({"readAt": currTime});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage({
    required String toId,
    required String fromId,
  }) {
    var chatId = getChatId(fromId: fromId, toId: toId);
    return firestore
        .collection(COLLECTION_CHATROOM)
        .doc(chatId)
        .collection(COLLECTION_MESSAGES)
        .orderBy("sentAt", descending: true)
        .limit(1)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUnReadCountMsg({
    required String fromId,
    required String toId,
  }) {
    var chatId = getChatId(fromId: fromId, toId: toId);
    return firestore
        .collection(COLLECTION_CHATROOM)
        .doc(chatId)
        .collection(COLLECTION_MESSAGES)
        .where("readAt", isEqualTo: "")
        .where("fromId", isEqualTo: toId)
        .snapshots();
  }

  Future<void> addProfileImg({
    required String imgUrl,
    required   String userId,
  }) async {
    try {
      await firestore.collection(COLLECTION_USERS).doc(userId).update({
        "profilePic": imgUrl,
      });
    }catch(e){
      throw "Error:failed to update profile image";
    }
  }
  Future<void> updateFullProfile({
    required String userId,
    required String name,
    required String profilePic,
  }) async {
    await firestore.collection(COLLECTION_USERS).doc(userId).update({
      "name": name,
      "profilePic": profilePic,
    });
  }
  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStreamByUserId({
    required String userId,
  }) {
    return firestore.collection(COLLECTION_USERS).doc(userId).snapshots();
  }
}
