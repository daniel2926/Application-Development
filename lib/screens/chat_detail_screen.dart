import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pad_1/helpers/cloud_firestore_helper.dart';
import 'package:flutter_pad_1/models/message_model.dart';
import 'package:flutter_pad_1/providers/auth_provider.dart';
import 'package:flutter_pad_1/widgets/time_ago.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String title;

  const ChatScreen({super.key, required this.chatId, required this.title});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: CloudFirestoreHelper().getMessagesStream(widget.chatId),
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
                  controller: _scrollController,  // Attach the ScrollController
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
                          if (!isSentByMe) ...[
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
                            const SizedBox(width: 8),
                          ],
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
            icon: const Icon(Icons.send, color: Colors.blueAccent),
            onPressed: () => _sendMessage(chatId),
          ),
        ],
      ),
    );
  }
}
