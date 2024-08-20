import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String documentId;
  final Timestamp timestamp;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.documentId,
    required this.timestamp,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> data, String id) {
    return NotificationModel(
      id: id,
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      documentId: data['documentId'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'documentId': documentId,
      'timestamp': timestamp,
    };
  }
}
