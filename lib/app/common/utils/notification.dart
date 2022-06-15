import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mover/firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifications {
  static Notifications? _instance;

  factory Notifications() {
    if (_instance == null) {
      _instance = new Notifications._();
    }

    return _instance!;
  }

  Notifications._();

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  static Future<void> fcmBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.toMap()}");
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    print("Handling a background message: ${message.messageId}");
  }

  init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    final _token = await messaging.getToken();
    _saveToken(_token!);

    messaging.onTokenRefresh.listen((_token) => _saveToken).onError((err) {
      print("token err : $err");
    });

    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) => _onMessage);
    FirebaseMessaging.onBackgroundMessage(
      Notifications.firebaseMessagingBackgroundHandler,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> subscribe(String _topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(_topic);
  }

  Future<void> unsubscribe(String _topic) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(_topic);
  }

  _saveToken(String _token) {
    print("token : $_token");
  }

  _onMessage(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification!.android;

    // If `onMessage` is triggered with a notification, construct our own
    // local notification to show to users using the created channel.
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: android.smallIcon,
            // other properties...
          ),
        ),
      );
    }
  }
}
