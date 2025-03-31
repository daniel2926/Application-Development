import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String content;
  final Timestamp timestamp;

  MessageModel({
    required this.senderId,
    required this.content,
    required this.timestamp,
  });

  // Factory constructor untuk membuat objek dari Map dengan validasi
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    try {
      return MessageModel(
        senderId: map['senderId'] as String? ?? '',
        content: map['content'] as String? ?? '',
        timestamp: map['timestamp'] is Timestamp
            ? map['timestamp'] as Timestamp
            : Timestamp.now(),
      );
    } catch (e) {
      print("Error parsing MessageModel: $e");
      return MessageModel(
        senderId: '',
        content: '',
        timestamp: Timestamp.now(),
      );
    }
  }

  // Konversi objek menjadi Map untuk disimpan ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'content': content,
      'timestamp': timestamp,
    };
  }

  // Method copyWith untuk update parsial pada objek MessageModel
  MessageModel copyWith({
    String? senderId,
    String? content,
    Timestamp? timestamp,
  }) {
    return MessageModel(
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
