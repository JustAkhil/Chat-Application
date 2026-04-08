import 'package:chat_application/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseRepository {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static const String COLLECTION_USERS = "users";
  static const String COLLECTION_CHATROOM = "chatroom";
  static const String PREFS_USER_ID_KEY = "userId";

  Future<void> createUser({
    required UserModel user,
    required String pass,
  }) async {
    try {
      UserCredential userCred = await firebaseAuth
          .createUserWithEmailAndPassword(email: user.email!, password: pass);
      if (userCred.user != null) {
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

      /// 🔐 Secure + Clean handling
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
  }
