
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pad_1/constants/urls.dart';
import 'package:flutter_pad_1/models/post_model.dart';
import 'package:flutter_pad_1/models/user_model.dart';

List<PostModel> mockPosts = [
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
    sellerId: 'user_001',
    sellerName: 'Udin',
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
    sellerId: 'user_004',
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

UserModel mockUser = UserModel(
  userId: 'user_001',
  name: 'Jane Doe',
  email: 'janedoe@example.com',
  profileImage: '',
  joinedDate: Timestamp.fromDate(DateTime(2024, 1, 1)),
  favorites: ['post_001', 'post_002', 'post_003'], nickname: 'dodol',
);