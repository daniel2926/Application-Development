import 'package:flutter/material.dart';
import 'package:flutter_pad_1/datas/mock_posts.dart';
import 'package:flutter_pad_1/models/post_model.dart';

class PostProvider with ChangeNotifier {
  final List<PostModel> _posts = mockPosts;
   List<PostModel> get posts => _posts;
  void addPost(PostModel post) {
    _posts.add(post);        // Add the post to the list
    notifyListeners();       // Notify listeners to update the UI
  }

void removePost(String postId) {
     _posts.removeWhere((post) => post.postId == postId);  // Remove post matching postId
    notifyListeners();   
}
}
