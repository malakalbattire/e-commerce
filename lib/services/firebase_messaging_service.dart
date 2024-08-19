import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseNotifications {
  final _firebaseMessaging = FirebaseMessaging.instance;
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

  Future<void> initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _localNotifications.initialize(initializationSettings);
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    initFirestoreListeners();
  }

  Future<void> initFirestoreListeners() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> addedProductIds = prefs.getStringList('addedProductIds') ?? [];

    FirebaseFirestore.instance
        .collection('products')
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added &&
            !addedProductIds.contains(change.doc.id)) {
          addedProductIds.add(change.doc.id);
          prefs.setStringList('addedProductIds', addedProductIds);
          _showLocalNotification(
            change.doc,
            'New Product Added',
            'A new product has been added! Check it out.',
          );
        } else if (change.type == DocumentChangeType.modified &&
            addedProductIds.contains(change.doc.id)) {
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
      DocumentSnapshot doc, String title, String body) async {
    final data = doc.data() as Map<String, dynamic>;
    final documentTitle = data['title'] ?? 'Unknown title';

    await _storeNotificationToFirestore(title, body, doc.id);

    _localNotifications.show(
      doc.hashCode,
      title,
      "$body Product: $documentTitle",
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          icon: '@drawable/ic_launcher',
        ),
      ),
      payload: jsonEncode({'documentId': doc.id}),
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
  }
}
