import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pad_1/models/message_model.dart';
import 'package:flutter_pad_1/models/post_model.dart';
import 'package:flutter_pad_1/models/review_model.dart';

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
      return snapshot.docs
          .map((doc) => MessageModel.fromMap(doc.data()))
          .toList();
    });
  }

  Future<void> sendMessage(String chatId, MessageModel message) async {
    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(message.toMap());
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  Future<String> getOrCreateChatRoom({
    required String sellerId,
    required String sellerName,
    required String buyerId,
    required String postId,
  }) async {
    final firestore = FirebaseFirestore.instance;
    String chatId = '';

    try {
      // Check if chat room already exists between the seller and buyer
      final existingChats = await firestore
          .collection('chats')
          .where('participants', arrayContainsAny: [sellerId, buyerId]).get();

      if (existingChats.docs.isNotEmpty) {
        // If there's an existing chat, retrieve its ID
        for (var doc in existingChats.docs) {
          List participants = doc['participants'];
          if (participants.contains(sellerId) &&
              participants.contains(buyerId)) {
            chatId = doc.id;
            break;
          }
        }
      }

      if (chatId.isEmpty) {
        // Create a new chat room
        final newChat = await firestore.collection('chats').add({
          'title': sellerName,
          'participants': [sellerId, buyerId],
          'postId': postId,
          'transactionStatus': 'pending',
          'lastMessage': null,
        });

        chatId = newChat.id;
      }
    } catch (e) {
      print('Error getting or creating chat room: $e');
    }

    return chatId;
  }
  Future<Map<String, dynamic>?> fetchPostData(String postId) async {
  try {
    print('Fetching data for postId: $postId'); // Debugging print
    final postSnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .get();

    if (postSnapshot.exists) {
      print('Post data found: ${postSnapshot.data()}'); // Debugging print
      return postSnapshot.data() as Map<String, dynamic>;
    } else {
      print('Post with postId $postId not found');
      return null;
    }
  } catch (error) {
    print('Error fetching post data: $error');
    return null;
  }
}

Future<void> addReview({
  required String sellerId,
  required String reviewerId,
  required String reviewerName,
  required double rating,
  required String comment,
}) async {
  try {
    final reviewData = ReviewModel(
      reviewerId: reviewerId,
      reviewerName: reviewerName,
      rating: rating,
      comment: comment,
      timestamp: Timestamp.now(),
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(sellerId)
        .collection('reviews')
        .add(reviewData.toMap());

    print("Review added successfully.");
  } catch (e) {
    print("Error adding review: $e");
  }
}
Future<List<Map<String, dynamic>>> fetchUserReviews(String userId) async {
  try {
    // Reference to the reviews subcollection for the specified userId
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('reviews')
        .orderBy('timestamp', descending: true)
        .get();

    // Convert each document to a Map<String, dynamic>
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  } catch (e) {
    print('Error fetching user reviews: $e');
    return [];
  }
}
Future<double> fetchAverageRating(String userId) async {
  try {
    // Reference to the reviews subcollection for the specified userId
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('reviews')
        .get();

    final reviews = querySnapshot.docs;

    // If there are no reviews, return 0.0
    if (reviews.isEmpty) return 0.0;

    // Sum the rating values from the retrieved documents
    double totalRating = reviews.fold(0.0, (sum, doc) {
      return sum + (doc['rating'] as double);
    });

    // Calculate and return the average rating
    return totalRating / reviews.length;
  } catch (e) {
    print('Error fetching average rating: $e');
    return 0.0;
  }
}

}
