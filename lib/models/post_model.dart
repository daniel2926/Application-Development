import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String title;
  final String description;
  final num price;
  final List<String> images;
  final String sellerId;
  final String sellerName;
  final GeoPoint location;
  final bool isAvailable;
  final Timestamp createdAt;

  PostModel({
    required this.postId,
    required this.title,
    required this.description,
    required this.price,
    required this.images,
    required this.sellerId,
    required this.sellerName,
    required this.location,
    required this.isAvailable,
    required this.createdAt,
  });

  // ✅ Convert Firestore JSON to PostModel
factory PostModel.fromMap(Map<String, dynamic> map) { // Debugging

  return PostModel(
    postId: map['postId'] ?? '',
    title: map['title'] ?? '',
    description: map['description'] ?? '',
    price: map['price'] ?? 0,
    images: List<String>.from(map['images'] ?? []),
    sellerId: map['sellerId'] ?? '',
    sellerName: map['sellerName'] ?? '',
    
    // 🔹 Fix: Ensure GeoPoint conversion
    location: map['location'] is GeoPoint
        ? map['location'] as GeoPoint
        : (map['location'] is Map<String, dynamic> 
            ? GeoPoint(map['location']['latitude'] ?? 0.0, map['location']['longitude'] ?? 0.0)
            : GeoPoint(0.0, 0.0)),

    isAvailable: map['isAvailable'] ?? true,

    // ✅ Fix: Ensure `createdAt` is always a Timestamp
    createdAt: map['createdAt'] is Timestamp 
        ? (map['createdAt'] as Timestamp) 
        : Timestamp.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
  );
}




  // ✅ Convert PostModel to Firestore JSON
  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'title': title,
      'description': description,
      'price': price,
      'images': images,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'location': location,
      'isAvailable': isAvailable,
      'createdAt': createdAt,
    };
  }

  // ✅ Convert PostModel to a Map
  
Map<String, dynamic> toMap() {
  return {
    'postId': postId,
    'title': title,
    'description': description,
    'price': price,
    'images': images,
    'sellerId': sellerId,
    'sellerName': sellerName,
    'location': location,
    'isAvailable': isAvailable,
    'createdAt': createdAt,
  };
}
}

