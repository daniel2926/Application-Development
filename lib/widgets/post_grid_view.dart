import 'package:flutter/material.dart';
import 'package:flutter_pad_1/models/post_model.dart';
import 'package:flutter_pad_1/widgets/post_card.dart';

class PostGridView extends StatelessWidget {
  const PostGridView({
    super.key,
    required this.posts,
  });

  final List<PostModel> posts;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0), // Adds padding around the grid
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two cards per row
          childAspectRatio: 0.7, // Aspect ratio for cards
          crossAxisSpacing: 8.0, // Horizontal spacing between cards
          mainAxisSpacing: 8.0, // Vertical spacing between cards
        ),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return PostCard(post: posts[index]);
        },
      ),
    );
  }
}