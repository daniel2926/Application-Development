import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String reviewerId;
  final String reviewerName; 
  final double rating;
  final String comment;
  final Timestamp timestamp;

  ReviewModel({
    required this.reviewerId,
    required this.reviewerName,
    required this.rating,
    required this.comment,
    required this.timestamp,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> data) {
    return ReviewModel(
      reviewerId: data['reviewerId'] ?? '',
      reviewerName: data['reviewerName'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      comment: data['comment'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  /// ReviewModel 객체를 Firestore에 저장할 Map 형태로 변환
  Map<String, dynamic> toMap() {
    return {
      'reviewerId': reviewerId,
      'reviewerName': reviewerName,
      'rating': rating,
      'comment': comment,
      'timestamp': timestamp,
    };
  }
}