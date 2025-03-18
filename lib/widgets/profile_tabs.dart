import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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


class ReviewsTab extends StatelessWidget {
  const ReviewsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Reviews'),
    );
  }
}
