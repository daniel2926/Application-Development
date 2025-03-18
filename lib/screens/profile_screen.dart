import 'package:flutter/material.dart';
import 'package:flutter_pad_1/providers/user_provider.dart';
import 'package:flutter_pad_1/widgets/profile_tabs.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch user provider
    final userProvider = Provider.of<UserProvider>(context);

    // Trigger loading of user data when the widget is first built
    if (userProvider.user.name.isEmpty) {
      userProvider.loadUser(); // Ensure user data is loaded if it's empty
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
                        userProvider.user.name, // Safely access the user's name now
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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


