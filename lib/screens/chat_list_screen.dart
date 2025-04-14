import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pad_1/helpers/cloud_firestore_helper.dart';
import 'package:flutter_pad_1/models/chat_model.dart';
import 'package:flutter_pad_1/models/message_model.dart';
import 'package:flutter_pad_1/screens/chat_detail_screen.dart';
import 'package:flutter_pad_1/widgets/time_ago.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});
  

  Future<String> getUserName(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc.data()?['name'] ?? 'Unknown';
      }
    } catch (e) {
      print('Error fetching user name: $e');
    }
    return 'Unknown';
  }
  Future<String> resolveChatTitle(String currentUserId, String buyerId, String postId) async {
    try {
      final postDoc = await FirebaseFirestore.instance.collection('posts').doc(postId).get();
      if (!postDoc.exists) return 'Unknown';

      final sellerId = postDoc.data()?['sellerId'];
      final isBuyer = currentUserId == buyerId;
      final otherUserId = isBuyer ? sellerId : buyerId;

      return await getUserName(otherUserId);
    } catch (e) {
      print('Error resolving chat title: $e');
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chats')),
        body: const Center(child: Text('You need to log in to see chats.')),
      );
    }

    final String userId = user.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: CloudFirestoreHelper().getChatsStream(userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading chats'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No chats available'));
          }

          final chats = snapshot.data!.docs.map((doc) {
            var chatData = doc.data();
            return ChatModel.fromMap(chatData, doc.id);
          }).toList();

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              var chat = chats[index];

              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .doc(chat.id)
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .limit(1)
                    .snapshots(),
                builder: (context, messageSnapshot) {
                  if (messageSnapshot.hasError) {
                    return const Center(child: Text('Error loading messages'));
                  }

                  String lastMessageText = 'No messages yet';
                  Timestamp? lastMessageTimestamp;

                  if (messageSnapshot.hasData && messageSnapshot.data!.docs.isNotEmpty) {
                    var lastMessageData = messageSnapshot.data!.docs.first.data();

                    // Periksa apakah lastMessageData dalam format yang benar
                    if (lastMessageData is Map<String, dynamic>) {
                      var lastMessage = MessageModel.fromMap(lastMessageData);
                      lastMessageText = lastMessage.content;
                      lastMessageTimestamp = lastMessage.timestamp;
                    }
                  }

                  return Column(
                    children: [
                      FutureBuilder<String>(
                        future: resolveChatTitle(userId, chat.participants.last, chat.postId ?? ''),
                        builder: (context, titleSnapshot) {
                          final chatTitle = titleSnapshot.data ?? 'Loading...';

                          return ListTile(
                            leading: CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.grey[300],
                              child: const Icon(Icons.person, color: Colors.white),
                            ),
                            title: Text(
                              chatTitle,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              lastMessageText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: lastMessageTimestamp != null
                                ? Text(timeAgo(lastMessageTimestamp))
                                : null,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    chatId: chat.id,
                                    title: chatTitle,
                                    postId: chat.postId ?? '',
                                    otherParticipantId: userId,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const Divider(thickness: 1, color: Colors.grey),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
