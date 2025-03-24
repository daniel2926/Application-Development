import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pad_1/helpers/cloud_firestore_helper.dart';
import 'package:flutter_pad_1/models/message_model.dart';
import 'package:flutter_pad_1/models/post_model.dart';
import 'package:flutter_pad_1/providers/auth_provider.dart';
import 'package:flutter_pad_1/screens/post_detail_screen.dart';
import 'package:flutter_pad_1/widgets/starting_widget.dart';
import 'package:flutter_pad_1/widgets/time_ago.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String title;
  final String postId;
  final String otherParticipantId;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.title,
    required this.postId,
    required this.otherParticipantId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _reviewController = TextEditingController();
  int _rating = 0;

  void _sendMessage(String chatId) async {
    // Ensure the message input is not empty
    if (_messageController.text.trim().isEmpty) return;

    // Retrieve the current user's ID from AuthenticationProvider
    final userId = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    ).user?.uid;

    // If no user is logged in, do not proceed
    if (userId == null) return;

    // Create a new message object using the MessageModel
    final newMessage = MessageModel(
      content: _messageController.text.trim(),
      senderId: userId,
      timestamp: Timestamp.now(),
    );

    try {
      // Send the message to Firestore using CloudFirestoreHelper
      await CloudFirestoreHelper().sendMessage(chatId, newMessage);

      // Clear the input field after sending the message
      _messageController.clear();

      // Scroll to the latest message
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } catch (error) {
      print('Failed to send message: $error');
    }
  }

 Future<void> _submitReview(BuildContext context, String sellerId, int rating, String review) async {
    if (rating == 0 || review.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please provide a rating and a review.")),
      );
      return;
    }

    try {
      final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
      final userId = authProvider.user?.uid;
      final userName = authProvider.user?.displayName;

      if (userId == null || userName == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unable to retrieve user information.")),
        );
        return;
      }

      await CloudFirestoreHelper().addReview(
        sellerId: sellerId,
        reviewerId: userId,
        reviewerName: userName,
        rating: rating.toDouble(),
        comment: review,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Review submitted successfully!")),
      );

      // Reset fields after submission
      _rating = 0;
      _reviewController.clear();
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to submit review. Please try again.")),
      );
      print("Error submitting review: $e");
    }
  }

  void _showReviewModal() {
  showDialog(
    context: context,
    builder: (context) {
      int tempRating = _rating; // Simpan rating sementara untuk modal
      return StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            title: const Text("Submit Review"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Widget Star Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      onPressed: () {
                        setModalState(() {
                          tempRating = index + 1;
                        });
                      },
                      icon: Icon(
                        index < tempRating ? Icons.star : Icons.star_border,
                        color: Colors.orange,
                        size: 36,
                      ),
                    );
                  }),
                ),
                TextField(
                  controller: _reviewController,
                  decoration: const InputDecoration(
                    hintText: "Write your review...",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _rating = tempRating; // Update nilai rating utama
                  });
                  _submitReview(
                    context,
                    widget.otherParticipantId,
                    _rating,
                    _reviewController.text,
                  );
                },
                child: const Text("Complete"),
              ),
            ],
          );
        },
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: CloudFirestoreHelper().fetchPostData(widget.postId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching post data.'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Post not found.'));
          }

          final postData = snapshot.data!;
          final post = PostModel.fromMap(postData ?? {});
          final imageUrl = post.images.isNotEmpty ? post.images.first : '';
          final title = postData['title'] ?? 'No Title';
          final price = postData['price'] ?? 'No Price';

          return Column(
            children: [
              // Item Information Section
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // Item Image
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Item Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Price: $price',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Buttons Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PostDetailScreen(postId: widget.postId),
                        ),
                      );
                    },
                    child: const Text("View Item"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Reserved for future purchase confirmation feature
                      _showReviewModal();
                    },
                    child: const Text("Complete Sale"),
                  ),
                ],
              ),
              Expanded(
                child: StreamBuilder<List<MessageModel>>(
                  stream:
                      CloudFirestoreHelper().getMessagesStream(widget.chatId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final messages = snapshot.data ?? [];
                    if (messages.isEmpty) {
                      return const Center(child: Text('No messages yet.'));
                    }

                    final currentUserId = Provider.of<AuthenticationProvider>(
                      context,
                      listen: false,
                    ).user?.uid;

                    return ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isSentByMe = message.senderId == currentUserId;

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 8),
                          child: Row(
                            mainAxisAlignment: isSentByMe
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              if (!isSentByMe)
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey,
                                  ),
                                  child: const Icon(Icons.person_outline,
                                      color: Colors.white),
                                ),
                              if (!isSentByMe) const SizedBox(width: 8),
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isSentByMe
                                        ? Colors.blue
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(16),
                                      topRight: const Radius.circular(16),
                                      bottomLeft: isSentByMe
                                          ? const Radius.circular(16)
                                          : const Radius.circular(4),
                                      bottomRight: isSentByMe
                                          ? const Radius.circular(4)
                                          : const Radius.circular(16),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        message.content,
                                        style: TextStyle(
                                          color: isSentByMe
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        timeAgo(message.timestamp),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isSentByMe
                                              ? Colors.white70
                                              : Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              _buildMessageInputField(widget.chatId),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMessageInputField(String chatId) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () {
              // Implement file attachment
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: "Type a message...",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.green),
            onPressed: () => _sendMessage(chatId),
          ),
        ],
      ),
    );
  }
}
