import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pad_1/helpers/cloud_firestore_helper.dart';
import 'package:flutter_pad_1/models/post_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_pad_1/providers/user_provider.dart';
import 'package:flutter_pad_1/datas/mock_posts.dart';
import 'package:flutter_pad_1/widgets/post_grid_view.dart';

class MySalesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String userId = userProvider.user?.userId ?? '';

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .where('sellerId', isEqualTo: userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // 🔹 Correct way to extract documents from Firestore
        final posts = snapshot.data?.docs.map((doc) {
          try {
            return PostModel.fromMap(doc.data() as Map<String, dynamic>);
          } catch (e) {
            debugPrint('Error parsing post: $e');
            return null;
          }
        }).whereType<PostModel>().toList();

        if (posts == null || posts.isEmpty) {
          return const Center(
            child: Text(
              'Belum ada postingan',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return PostGridView(posts: posts);
      },
    );
  }
}


class FavoritesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;

    if (user == null || user.favorites.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada favorit',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .where('postId', whereIn: user.favorites)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final posts = snapshot.data?.docs.map((doc) {
          try {
            return PostModel.fromMap(doc.data() as Map<String, dynamic>);
          } catch (e) {
            debugPrint('Error parsing post: $e');
            return null;
          }
        }).whereType<PostModel>().toList();

        if (posts == null || posts.isEmpty) {
          return const Center(
            child: Text(
              'Belum ada favorit',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return PostGridView(posts: posts);
      },
    );
  }
}

 // Adjust based on your file structure

class ReviewsTab extends StatelessWidget {
  const ReviewsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userId = userProvider.user.userId;

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: CloudFirestoreHelper().fetchUserReviews(userId), // Directly calling the method you provided
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text("Error fetching reviews. Please try again."),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text("No reviews available."),
          );
        }

        // Data is available
        final reviews = snapshot.data!;

        return ListView.builder(
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['reviewerName'] ?? 'Anonymous',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          Icons.star,
                          color: i < (review['rating'] ?? 0)
                              ? Colors.orange
                              : Colors.grey,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(review['comment'] ?? 'No comment'),
                    const SizedBox(height: 6),
                    Text(
                      "Reviewed on: ${review['timestamp']?.toDate().toString().split(' ')[0] ?? 'N/A'}",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

