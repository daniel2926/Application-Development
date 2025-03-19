import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pad_1/models/message_model.dart';
import 'package:flutter_pad_1/models/post_model.dart';

class CloudFirestoreHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getPostsStream() {
    return _firestore.collection('posts').snapshots();
  }
  Stream<DocumentSnapshot<Map<String, dynamic>>> getOnePost(String postId) {
    return _firestore.collection('posts').doc(postId).snapshots();
  }
  Future<void> uploadPost(PostModel post) async {
  try {
    await _firestore.collection('posts').doc(post.postId).set({
  'postId': post.postId,
  'title': post.title,
  'description': post.description,
  'price': post.price,
  'images': post.images,
  'sellerId': post.sellerId,
  'sellerName': post.sellerName,
  'location': GeoPoint(
    post.location.latitude,
    post.location.longitude,
  ),
  'isAvailable': post.isAvailable,
  'createdAt': post.createdAt,
});
  } catch (e) {
    throw Exception('Error uploading post: $e');
  }
}
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
      print('Post with ID $postId has been successfully deleted.');
    } catch (e) {
      print('Error deleting post: $e');
      // Handle errors appropriately in your application
    }
  }
   Future<void> updatePost({
    required String postId,
    required String title,
    required String description,
    required double price,
    required List<String> images,
  }) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'title': title,
        'description': description,
        'price': price,
        'images': images,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      print('Post updated successfully.');
    } catch (e) {
      print('Error updating post: $e');
    }
  }
Stream<QuerySnapshot<Map<String, dynamic>>> getChatsStream(String userId) {
  return FirebaseFirestore.instance
      .collection('chats')
      .where('participants', arrayContains: userId)
      .snapshots();
}
// Stream<List<MessageModel>> getMessagesStream(String chatId) {
//   return FirebaseFirestore.instance
//       .collection('Chats')
//       .doc(chatId)
//       .collection('messages')
//       .orderBy('timestamp', descending: true) // Or  der messages by timestamp
//       .snapshots()
//       .map((snapshot) => snapshot.docs
//           .map((doc) => MessageModel.fromMap(doc.data()))
//           .toList());
// }
 Stream<List<MessageModel>> getMessagesStream(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages') // Subkoleksi
        .orderBy('timestamp', descending: true) // Urutkan berdasarkan timestamp
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => MessageModel.fromMap(doc.data())).toList();
        });
  }
Future<void> sendMessage(String chatId, MessageModel message) async {
  try {
    await FirebaseFirestore.instance
        .collection('Chats')
        .doc(chatId)
        .collection('messages')
        .add(message.toMap());
  } catch (e) {
    print('Error sending message: $e');
  }
}




}
