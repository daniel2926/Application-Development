import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pad_1/constants/urls.dart';
import 'package:flutter_pad_1/models/chat_model.dart';
import 'package:flutter_pad_1/models/message_model.dart';
import 'package:flutter_pad_1/models/post_model.dart';
import 'package:flutter_pad_1/models/review_model.dart';
import 'package:flutter_pad_1/models/user_model.dart';


List<ReviewModel> generateMockReviews(String uid) {
  return [
    ReviewModel(
      reviewerId: 'user_002',
      reviewerName: 'Mable',
      rating: 5,
      comment: 'Great experience selling to this user! Highly recommended.',
      timestamp:
          Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 10))),
    ),
    ReviewModel(
      reviewerId: 'user_003',
      reviewerName: 'Alice',
      rating: 4,
      comment: 'Very polite and understanding during the transaction.',
      timestamp:
          Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 7))),
    ),
    ReviewModel(
      reviewerId: 'user_004',
      reviewerName: 'Bob',
      rating: 3,
      comment: 'Good buyer, but there was a slight delay in communication.',
      timestamp:
          Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 20))),
    ),
    ReviewModel(
      reviewerId: 'user_005',
      reviewerName: 'Sophia',
      rating: 4,
      comment: 'Transaction went smoothly. Would sell to this user again.',
      timestamp:
          Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 15))),
    ),
    ReviewModel(
      reviewerId: 'user_006',
      reviewerName: 'Olivia',
      rating: 5,
      comment: 'Excellent buyer! Payment was fast and communication was clear.',
      timestamp:
          Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 5))),
    ),
    ReviewModel(
      reviewerId: 'user_007',
      reviewerName: 'Liam',
      rating: 4,
      comment: 'Good buyer. Had a minor issue but resolved it quickly.',
      timestamp:
          Timestamp.fromDate(DateTime.now().subtract(Duration(days: 12))),
    ),
    ReviewModel(
      reviewerId: 'user_008',
      reviewerName: 'Emma',
      rating: 5,
      comment: 'This user was great to deal with. Would definitely recommend!',
      timestamp: Timestamp.fromDate(DateTime.now().subtract(Duration(days: 3))),
    ),
    ReviewModel(
      reviewerId: 'user_009',
      reviewerName: 'James',
      rating: 2,
      comment:
          'Communication could have been better. Buyer seemed unresponsive at times.',
      timestamp:
          Timestamp.fromDate(DateTime.now().subtract(Duration(days: 25))),
    ),
  ];
}

List<PostModel> generateMockPosts(String uid) {
  return [
    PostModel(
      postId: 'post_001',
      title: 'Mountain Bike',
      description:
          'A lightly used mountain bike, ideal for trail rides and outdoor adventures. Comes with a sturdy frame, smooth gears, and durable tires.',
      price: 120,
      images: [
        postImg1,
        postImg1,
      ],
      sellerId: uid, // user_001 replaced with uid
      sellerName: 'Mike',
      location: const GeoPoint(34.0522, -118.2437),
      isAvailable: true,
      createdAt:
          Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 3))),
    ),
    PostModel(
      postId: 'post_002',
      title: 'Stylish Potted Plant',
      description:
          'A beautiful potted plant in great condition, perfect for adding a touch of greenery to your space. Barely used and includes a decorative ceramic pot.',
      price: 12,
      images: [
        postImg2,
      ],
      sellerId: 'user_002',
      sellerName: 'Tom',
      location: const GeoPoint(37.7749, -122.4194),
      isAvailable: true,
      createdAt:
          Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1))),
    ),
    PostModel(
      postId: 'post_003',
      title: 'Sofa',
      description:
          'A gently-used 3-seater sofa in neutral tones, perfect for a cozy living room setup. Comfortable cushions and easy-to-clean fabric.',
      price: 35,
      images: [
        postImg3,
      ],
      sellerId: 'user_003',
      sellerName: 'Stella',
      location: const GeoPoint(51.5074, -0.1278),
      isAvailable: false,
      createdAt:
          Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 4))),
    ),
    PostModel(
      postId: 'post_004',
      title: 'Leather Jacket',
      description:
          'A premium leather jacket with a classic bomber style. Perfect for casual outings and offers excellent durability and comfort.',
      price: 220,
      images: [
        postImg4,
      ],
      sellerId: uid, // user_004 replaced with uid
      sellerName: 'Ava',
      location: const GeoPoint(51.5074, -0.1278),
      isAvailable: true,
      createdAt:
          Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 5))),
    ),
    PostModel(
      postId: 'post_005',
      title: 'Designer Handbag',
      description:
          'A luxurious designer handbag crafted from genuine leather. Spacious interior with multiple compartments, perfect for everyday use or special occasions.',
      price: 180,
      images: [
        postImg5,
      ],
      sellerId: 'user_005',
      sellerName: 'Olivia',
      location: const GeoPoint(48.8566, 2.3522),
      isAvailable: true,
      createdAt:
          Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 6))),
    ),
    PostModel(
      postId: 'post_006',
      title: 'Wooden Bookshelf',
      description:
          'A solid wood bookshelf with a natural finish. Durable and spacious, capable of holding up to 100 books. Perfect for organizing your home or office.',
      price: 60,
      images: [
        postImg6,
      ],
      sellerId: 'user_006',
      sellerName: 'Sophia',
      location: const GeoPoint(40.7128, -74.0060),
      isAvailable: true,
      createdAt:
          Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 2))),
    ),
  ];
}

List<ChatModel> generateMockChatModels(String uid) {
  return [
    ChatModel(
      id: 'chat1',
      title: 'Mable',
      participants: [uid, 'user2'],
      postId: 'post_001',
      transactionStatus: 'pending',
      lastMessage: MessageModel(
        content: 'Understood! Thank you!',
        senderId: 'user2',
        timestamp: Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 7))),
      ),
    ),
    ChatModel(
      id: 'chat2',
      title: 'Alice',
      participants: [uid, 'user3'],
      postId: 'post_002',
      transactionStatus: 'completed',
      lastMessage: MessageModel(
        content: 'When will you ship it?',
        senderId: 'user3',
        timestamp: Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 3))),
      ),
    ),
    ChatModel(
      id: 'chat3',
      title: 'Bob',
      participants: [uid, 'user4'],
      postId: 'post_003',
      transactionStatus: 'cancelled',
      lastMessage: MessageModel(
        content: 'See you next week!',
        senderId: uid,
        timestamp: Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 1))),
      ),
    ),
  ];
}

Map<String, List<MessageModel>> generateMockMessages(String uid) {
  return {
    'chat1': [
      MessageModel(
        content: 'Is the item still available?',
        senderId: uid,
        timestamp: Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 8))),
      ),
      MessageModel(
        content: 'Yes, it\'s still available!',
        senderId: 'user2',
        timestamp: Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 8, hours: 2))),
      ),
      MessageModel(
        content: 'Understood! Thank you!',
        senderId: uid,
        timestamp: Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 7))),
      ),
    ],
    'chat2': [
      MessageModel(
        content: 'When will you ship it?',
        senderId: 'user3',
        timestamp: Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 3))),
      ),
      MessageModel(
        content: 'It will be shipped tomorrow.',
        senderId: uid,
        timestamp: Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 3, hours: 4))),
      ),
    ],
    'chat3': [
      MessageModel(
        content: 'See you next week!',
        senderId: uid,
        timestamp: Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 1))),
      ),
    ],
  };
}

List<UserModel> generateMockUsers() {
  return [
    UserModel(
      userId: 'user2',
      name: 'Mable',
      email: 'mable@example.com',
      nickname: 'MableSells',
      profileImage: 'https://example.com/mable.jpg', // Example placeholder
      joinedDate: Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 400))),
      favorites: [],
    ),
    UserModel(
      userId: 'user3',
      name: 'Alice',
      email: 'alice@example.com',
      nickname: 'Alice123',
      profileImage: 'https://example.com/alice.jpg', // Example placeholder
      joinedDate: Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 500))),
      favorites: [],
    ),
    UserModel(
      userId: 'user4',
      name: 'Bob',
      email: 'bob@example.com',
      nickname: 'BobTheSeller',
      profileImage: 'https://example.com/bob.jpg', // Example placeholder
      joinedDate: Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 300))),
      favorites: [],
    ),
  ];
}
