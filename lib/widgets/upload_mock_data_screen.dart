import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pad_1/providers/auth_provider.dart';
import 'package:flutter_pad_1/widgets/generate_mock_datas.dart';
import 'package:provider/provider.dart';

class UploadMockDataScreen extends StatelessWidget {
  const UploadMockDataScreen({super.key});

  Future<void> uploadMockData(String uid) async {
    final firestore = FirebaseFirestore.instance;

    // Generate Mock Data
    final reviews = generateMockReviews(uid);
    final posts = generateMockPosts(uid);
    final chats = generateMockChatModels(uid);
    final messages = generateMockMessages(uid);
    final users = generateMockUsers();

    // Upload Users
    for (var user in users) {
      await firestore.collection('users').doc(user.userId).set(user.toJson());
    }

    // Upload Reviews (as subcollections of the logged-in user)
    for (var review in reviews) {
      await firestore
          .collection('users')
          .doc(uid)
          .collection('reviews')
          .add(review.toMap());
    }

    // Upload Posts
    for (var post in posts) {
      await firestore.collection('posts').doc(post.postId).set(post.toMap());
    }

    // Upload Chats
    for (var chat in chats) {
      final chatDoc = firestore.collection('chats').doc(chat.id);
      await chatDoc.set(chat.toMap());

      // Upload Messages for each Chat
      if (messages.containsKey(chat.id)) {
        for (var message in messages[chat.id]!) {
          await chatDoc.collection('messages').add(message.toMap());
        }
      }
    }

    print('Mock data uploaded successfully!');
  }

  @override
  Widget build(BuildContext context) {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);

    return Center(
      child: ElevatedButton(
        onPressed: () {
          if (authProvider.user != null) {
            uploadMockData(authProvider.user!.uid);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mock data uploaded successfully!')),
        );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('You need to log in to upload mock data.'),
              ),
            );
          }
        },
        child: const Text('Upload Mock Data'),
      ),
    );
  }
}