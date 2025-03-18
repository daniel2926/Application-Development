import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String name;
  final String nickname;
  final String email;
  final String profileImage;
  final Timestamp joinedDate;
  final List<String> favorites;

  UserModel({
    required this.userId,
    required this.name,
    required this.nickname,
    required this.email,
    required this.profileImage,
    required this.joinedDate,
    required this.favorites,
  });

  // Factory constructor to handle missing fields properly
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] ?? '',
      name: json['name'] ?? 'Unknown User',
      nickname: json['nickname'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'] ?? '',
      joinedDate: json['joinedDate'] ?? Timestamp.now(),
      favorites: List<String>.from(json['favorites'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'nickname': nickname,
      'email': email,
      'profileImage': profileImage,
      'joinedDate': joinedDate,
      'favorites': favorites,
    };
  }
}
