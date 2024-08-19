// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class FirebaseMessagingService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final AndroidNotificationChannel _androidChannel =
//       const AndroidNotificationChannel(
//     'high_importance_channel',
//     'High Importance Notifications',
//     description: 'This channel is used for important notifications.',
//     importance: Importance.high,
//   );
//   final FlutterLocalNotificationsPlugin _localNotifications =
//       FlutterLocalNotificationsPlugin();
//
//   FirebaseMessagingService() {
//     initializeLocalNotifications();
//   }
//
//   Future<void> initializeLocalNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@drawable/ic_launcher');
//
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//     );
//
//     await _localNotifications.initialize(initializationSettings);
//   }
//
//   Future<void> initNotifications() async {
//     await _firebaseMessaging.requestPermission();
//
//     // Fetch and print the FCM token
//     await _printFCMToken();
//
//     initFirestoreListeners();
//   }
//
//   Future<void> _printFCMToken() async {
//     final token = await _firebaseMessaging.getToken();
//     print('FCM Token: $token');
//   }
//
//   Future<void> initFirestoreListeners() async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String> addedTripIds = prefs.getStringList('addedTripIds') ?? [];
//
//     FirebaseFirestore.instance
//         .collection('trips')
//         .snapshots()
//         .listen((snapshot) {
//       for (var change in snapshot.docChanges) {
//         if (change.type == DocumentChangeType.added &&
//             !addedTripIds.contains(change.doc.id)) {
//           addedTripIds.add(change.doc.id);
//           prefs.setStringList('addedTripIds', addedTripIds);
//           _showLocalNotification(
//             change.doc,
//             'New Trip Added',
//             'A new trip has been added! Check it out.',
//           );
//         } else if (change.type == DocumentChangeType.modified &&
//             addedTripIds.contains(change.doc.id)) {
//           _showLocalNotification(
//             change.doc,
//             'Trip Updated',
//             'An existing trip has been updated. See what\'s new!',
//           );
//         }
//       }
//     });
//
//     // Add listener for orders collection
//     FirebaseFirestore.instance
//         .collection('orders')
//         .snapshots()
//         .listen((snapshot) {
//       for (var change in snapshot.docChanges) {
//         if (change.type == DocumentChangeType.modified) {
//           final data = change.doc.data() as Map<String, dynamic>;
//           final status = data['status'] as String;
//
//           // Assuming 'status' is a field in your order documents
//           _showLocalNotification(
//             change.doc,
//             'Order Status Updated',
//             'Your order status has been updated to: $status',
//           );
//         }
//       }
//     });
//   }
//
//   void _showLocalNotification(
//       DocumentSnapshot doc, String title, String body) async {
//     final data = doc.data() as Map<String, dynamic>;
//     final documentTitle = data['title'] ?? 'Unknown title';
//
//     await _storeNotificationToFirestore(title, body, doc.id);
//
//     _localNotifications.show(
//       doc.hashCode,
//       title,
//       "$body Order: $documentTitle",
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           _androidChannel.id,
//           _androidChannel.name,
//           channelDescription: _androidChannel.description,
//           icon: '@drawable/ic_launcher',
//         ),
//       ),
//       payload: jsonEncode({'documentId': doc.id}),
//     );
//   }
//
//   Future<void> _storeNotificationToFirestore(
//       String title, String body, String documentId) async {
//     await FirebaseFirestore.instance.collection('notifications').add({
//       'title': title,
//       'body': body,
//       'documentId': documentId,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }
// }

import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('=============${fCMToken}==========');
  }
}
