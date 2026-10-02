import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Top-level background message handler
Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // 1. Request notification permission
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    }

    // 2. Background message handler
    FirebaseMessaging.onBackgroundMessage(
      _firebaseMessagingBackgroundHandler,
    );

    // 3. Android notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'chat_messages',
      'Chat Messages',
      description: 'This channel is used for important chat notifications.',
      importance: Importance.max,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // 4. Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _localNotificationsPlugin.show(
          id: notification.hashCode,
          title: notification.title,
          body: notification.body,
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });

    // 5. Notification clicked
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        print(
          "Notification clicked! Navigate to chat screen using: ${message.data}",
        );
      },
    );

    // 6. FCM token refresh listener
    _fcm.onTokenRefresh.listen((newToken) {
      saveDeviceToken(tokenOverride: newToken);
    });

    // 7. Auth state change listener - automatically saves FCM token on user login/restore
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        saveDeviceToken();
      }
    });

    // 8. Save FCM token
    await saveDeviceToken();
  }

  // Get FCM token
  Future<String?> getDeviceToken() async {
    return await _fcm.getToken();
  }

  // Save FCM token to Firestore
  Future<void> saveDeviceToken({String? tokenOverride}) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("No authenticated user found for FCM token save");
      return;
    }

    final token = tokenOverride ?? await _fcm.getToken();

    if (token == null) {
      print("FCM token is null");
      return;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set(
      {
        'fcmToken': token,
      },
      SetOptions(merge: true),
    );

    print("FCM token saved for user ${user.uid}: $token");
  }
}