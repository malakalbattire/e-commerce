import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseNotifications {
  final AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('app_icon');

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.defaultImportance,
  );
  final _localNotifications = FlutterLocalNotificationsPlugin();

  FirebaseNotifications() {
    initializeLocalNotifications();
  }

  Future<void> initNotifications() async {
    await FirebaseMessaging.instance
        .requestPermission(
      alert: true,
      badge: true,
      sound: true,
    )
        .then((settings) {
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');
      } else {
        print('User declined or has not accepted permission');
      }
    });

    await initFirestoreListeners();
  }

  Future<void> initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _localNotifications.initialize(initializationSettings);
  }

  Future<void> initFirestoreListeners() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> seenProductIds = prefs.getStringList('seenProductIds') ?? [];
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      prefs.setBool('isFirstLaunch', false);
    }

    FirebaseFirestore.instance
        .collection('products')
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        final product = ProductItemModel.fromMap(
            change.doc.data() as Map<String, dynamic>, change.doc.id);

        if (change.type == DocumentChangeType.added &&
            !seenProductIds.contains(product.id)) {
          seenProductIds.add(product.id);
          prefs.setStringList('seenProductIds', seenProductIds);
          if (!isFirstLaunch) {
            _showLocalNotification(
              change.doc,
              'New Product Added',
              'A new product has been added! Check it out.',
            );
          }
        } else if (change.type == DocumentChangeType.modified &&
            seenProductIds.contains(product.id)) {
          _showLocalNotification(
            change.doc,
            'Product Updated',
            'An existing product has been updated. See what\'s new!',
          );
        }
      }
    });
  }

  void _showLocalNotification(
      DocumentSnapshot docSnapshot, String title, String body) async {
    final data = docSnapshot.data() as Map<String, dynamic>;

    String productName = data['name'] ?? 'Unknown Product';

    await _storeNotificationToFirestore(
        title, "$body Product: $productName", docSnapshot.id);

    _localNotifications.show(
      docSnapshot.id.hashCode,
      title,
      "$body Product: $productName",
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          icon: '@drawable/ic_launcher',
        ),
      ),
      payload: jsonEncode({'documentId': docSnapshot.id}),
    );
  }

  Future<void> _storeNotificationToFirestore(
      String title, String body, String documentId) async {
    await FirebaseFirestore.instance.collection('notifications').add({
      'title': title,
      'body': body,
      'documentId': documentId,
      'timestamp': FieldValue.serverTimestamp(),
    });
    print('Notification stored to Firestore for doc ID: $documentId');
  }
}
