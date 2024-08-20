import 'package:e_commerce_app_flutter/models/notification_model.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationProvider with ChangeNotifier {
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  NotificationProvider() {
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .get();

      _notifications = snapshot.docs
          .map((doc) => NotificationModel.fromMap(doc.data(), doc.id))
          .toList();

      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  Future<void> addNotification(NotificationModel notification) async {
    try {
      final docRef = await FirebaseFirestore.instance
          .collection('notifications')
          .add(notification.toMap());

      _notifications.add(NotificationModel(
        id: docRef.id,
        title: notification.title,
        body: notification.body,
        documentId: notification.documentId,
        timestamp: notification.timestamp,
      ));
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(id)
          .delete();
      _notifications.removeWhere((notification) => notification.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> clearAllNotifications() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('notifications').get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      _notifications.clear();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
