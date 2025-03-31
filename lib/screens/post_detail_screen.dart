import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pad_1/constants/app_theme.dart';
import 'package:flutter_pad_1/constants/urls.dart';
import 'package:flutter_pad_1/helpers/cloud_firestore_helper.dart';
import 'package:flutter_pad_1/models/post_model.dart';
import 'package:flutter_pad_1/providers/post_provider.dart';
import 'package:flutter_pad_1/providers/user_provider.dart';
import 'package:flutter_pad_1/screens/chat_detail_screen.dart';
import 'package:flutter_pad_1/screens/post_edit_screen.dart';
import 'package:flutter_pad_1/widgets/get_address.dart';
import 'package:flutter_pad_1/widgets/map_preview.dart';
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

  void _showMoreOptions(BuildContext context, PostProvider provider,
      String postId, PostModel post) {
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
                  MaterialPageRoute(
                      builder: (context) => PostEditScreen(post: post)));
            },
          ),
          ListTile(
            title: const Text("Delete"),
            onTap: () async {
              bool? confirmDelete = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Confirm Deletion"),
                  content:
                      const Text("Are you sure you want to delete this post?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Delete",
                          style: TextStyle(color: Colors.red)),
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

  /// _startChat method for initializing chat with the seller
  void _startChat(BuildContext context, String sellerId, String buyerId,
      String postId) async {
    try {
      // Ambil data seller dari koleksi "users" bukan "posts"
      DocumentSnapshot<Map<String, dynamic>> sellerSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(sellerId)
              .get();

      String sellerName = sellerSnapshot.exists
          ? (sellerSnapshot.data()?['name'] ??
              "Unknown") // Sesuaikan dengan field nama seller di Firestore
          : "Unknown";

      print("ini seller name nya : ${sellerName}");

      // Get or create chat room
      String chatId = await CloudFirestoreHelper().getOrCreateChatRoom(
        sellerId: sellerId,
        sellerName: sellerName,
        buyerId: buyerId,
        postId: postId,
      );

      // Navigate to ChatDetailScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            chatId: chatId,
            title: sellerName,
            postId: postId,
            otherParticipantId: sellerId,
          ),
        ),
      );
    } catch (e) {
      print("Error starting chat: $e");
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

        if (!snapshot.hasData ||
            snapshot.data == null ||
            !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(child: Text("Post not found")),
          );
        }

        // Convert Firestore document to PostModel
        final postData = snapshot.data!.data();
        final post = PostModel.fromMap(postData ?? {});
        String timeAgoText = timeAgo(post.createdAt);

        String locationText = "Unknown Location";
        if (post.location != null && post.location is GeoPoint) {
          GeoPoint geoPoint = post.location as GeoPoint;
          locationText =
              "Lat: ${geoPoint.latitude}, Lng: ${geoPoint.longitude}";
        }

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
                /// Post Image
                Image.network(
                  post.images.isNotEmpty ? post.images[0] : defalutImg,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),

                /// Availability Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: post.isAvailable ? active : inActive,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    post.isAvailable ? 'For Sale' : 'Sold Out',
                    style: badgetText,
                  ),
                ),
                const SizedBox(height: 10),

                /// Price and Timestamp
                Text('\$${post.price}', style: priceText2),
                const SizedBox(height: 8),
                Text(timeAgoText,
                    style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const Divider(thickness: 1),

                /// Preferred Location Section
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FutureBuilder<String>(
                        future: getAddress(
                            post.location.latitude, post.location.longitude),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text("Loading...",
                                style: TextStyle(
                                    fontSize: 16, fontStyle: FontStyle.italic));
                          } else if (snapshot.hasError) {
                            return const Text("Failed to load address",
                                style:
                                    TextStyle(fontSize: 16, color: Colors.red));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Text("Unknown location",
                                style: TextStyle(fontSize: 16));
                          }
                          return Text(snapshot.data!,
                              style: const TextStyle(fontSize: 16));
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                MapPreview(location: post.location),
                const Divider(thickness: 1),

                /// Seller Information
                Row(
                  children: [
                    const Icon(Icons.person_outline,
                        size: 40, color: Colors.grey),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Text(post.sellerId,
                            style: const TextStyle(fontSize: 16))),
                    IconButton(
                      icon: const Icon(Icons.navigate_next),
                      onPressed: () {
                        Navigator.pushNamed(context, '/sellerProfile',
                            arguments: post.sellerId);
                      },
                    ),
                  ],
                ),
                const Divider(thickness: 1),

                /// Post Description
                Text(post.description, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),

          /// Bottom Navigation Bar
          bottomNavigationBar: Consumer2<UserProvider, PostProvider>(
            builder: (context, userProvider, postProvider, child) {
              final currentUser = userProvider.user;

              if (currentUser == null) {
                return const SizedBox(
                    height: 60,
                    child: Center(child: CircularProgressIndicator()));
              }

              final isSeller = currentUser.userId == post.sellerId;
              final isFavorite = (currentUser.favorites ?? []).contains(postId);

              void toggleFavorite(String postId) {
                if (isFavorite) {
                  userProvider.removeFavorite(postId);
                } else {
                  userProvider.addFavorite(postId);
                }
              }

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Divider(thickness: 1, color: Colors.grey),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (!isSeller) ...[
                          /// Favorite Button
                          Container(
                            decoration: BoxDecoration(
                              color: isFavorite ? activeOpacity : background,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.favorite,
                                color: isFavorite ? active : inActive,
                              ),
                              onPressed: () {
                                toggleFavorite(postId);
                              },
                            ),
                          ),
                          const SizedBox(width: 16),

                          /// Contact Seller Button
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                              ),
                              onPressed: () {
                                _startChat(context, post.sellerId,
                                    currentUser.userId, postId);
                              },
                              child: const Text(
                                'Contact Seller',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                        ] else ...[
                          /// More Options for Seller
                          IconButton(
                            icon:
                                const Icon(Icons.more_vert, color: Colors.grey),
                            onPressed: () {
                              _showMoreOptions(
                                  context, postProvider, postId, post);
                            },
                          ),
                          const SizedBox(width: 16),

                          /// Contact Buyer Button
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                              ),
                              onPressed: () {},
                              child: const Text(
                                'Contact Buyer',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ],
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
