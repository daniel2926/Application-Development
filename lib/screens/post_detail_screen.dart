import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pad_1/constants/app_theme.dart';
import 'package:flutter_pad_1/constants/urls.dart';
import 'package:flutter_pad_1/helpers/cloud_firestore_helper.dart';
import 'package:flutter_pad_1/models/post_model.dart';
import 'package:flutter_pad_1/providers/post_provider.dart';
import 'package:flutter_pad_1/providers/user_provider.dart';
import 'package:flutter_pad_1/screens/post_edit_screen.dart';
import 'package:flutter_pad_1/widgets/time_ago.dart';
import 'package:provider/provider.dart';

class PostDetailScreen extends StatelessWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  /// Fetch post stream from Firestore
  Stream<DocumentSnapshot<Map<String, dynamic>>> getOnePost(String postId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .snapshots();
  }

  void _showMoreOptions(
      BuildContext context, PostProvider provider, String postId, PostModel post) {
    CloudFirestoreHelper _cloudFirestoreHelper = CloudFirestoreHelper();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) => Wrap(
        children: [
          ListTile(
            title: const Text('Edit'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostEditScreen(post: post)),
              );
            },
          ),
          ListTile(
            title: const Text("Delete"),
            onTap: () async {
              bool? confirmDelete = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Confirm Deletion"),
                  content: const Text("Are you sure you want to delete this post?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Delete", style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );

              if (confirmDelete == true) {
                _cloudFirestoreHelper.deletePost(postId);
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Your post has been deleted"),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
          ),
          ListTile(
            title: const Text('Cancel'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  /// Start a chat between seller and buyer
  void _startChat(BuildContext context, String sellerId, String buyerId) async {
    final firestore = FirebaseFirestore.instance;

    try {
      final sellerDoc = await firestore.collection('users').doc(sellerId).get();
      final sellerName = sellerDoc.exists ? (sellerDoc.data() != null ? sellerDoc.data()!['name'] : "Unknown") : "Unknown";

      print("Chat started with Seller: $sellerName");

      // Navigate to the chat screen if necessary
      // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(chatId: chatId, title: sellerName)));
    } catch (error) {
      print('Error fetching seller data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: getOnePost(postId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(child: Text("Post not found")),
          );
        }

        final postData = snapshot.data!.data();
        final post = PostModel.fromMap(postData ?? {});
        String timeAgoText = timeAgo(post.createdAt);

        return Scaffold(
          appBar: AppBar(
            title: Image.network(logoUrl, height: 40),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  post.images.isNotEmpty ? post.images[0] : defalutImg,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                Text('\$${post.price}', style: priceText2),
                const SizedBox(height: 8),
                Text(timeAgoText, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const Divider(thickness: 1),
                Text(post.description, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
          bottomNavigationBar: Consumer2<UserProvider, PostProvider>(
            builder: (context, userProvider, postProvider, child) {
              final currentUser = userProvider.user;
              if (currentUser == null) {
                return const Center(child: CircularProgressIndicator());
              }

              final isSeller = currentUser.userId == post.sellerId;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (!isSeller)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: () => _startChat(context, post.sellerId, currentUser.userId),
                        child: const Text('Contact Seller', style: TextStyle(color: Colors.white, fontSize: 20)),
                      )
                    else
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: () => _startChat(context, post.sellerId, currentUser.userId),
                        child: const Text('Contact Buyer', style: TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
