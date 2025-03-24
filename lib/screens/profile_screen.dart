import 'package:flutter/material.dart';
import 'package:flutter_pad_1/providers/user_provider.dart';
import 'package:flutter_pad_1/widgets/profile_tabs.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<double> fetchAverageRating(String userId) async {
    // Simulate fetching data from Firestore or any database
    await Future.delayed(Duration(seconds: 2)); // Simulating network delay
    return 4.2; // Example average rating value
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (userProvider.user.name.isEmpty) {
      userProvider.loadUser();
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            if (userProvider.user.name.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                const SizedBox(height: 30),
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFD9D9D9),
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        userProvider.user.name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      FutureBuilder<double>(
                        future: fetchAverageRating(userProvider.user.userId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (snapshot.hasError) {
                            return const Text("Error fetching rating");
                          }

                          double averageRating = snapshot.data ?? 0.0;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.orange,
                                size: 24,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                averageRating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const TabBar(
                  tabs: [
                    Tab(text: "My Sales"),
                    Tab(text: "Favorites"),
                    Tab(text: "Reviews"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      MySalesTab(),
                      FavoritesTab(),
                      ReviewsTab(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
