import 'package:flutter/material.dart';
import 'package:flutter_pad_1/constants/urls.dart';
import 'package:flutter_pad_1/screens/add_screen.dart';
import 'package:flutter_pad_1/screens/chat_list_screen.dart';
import 'package:flutter_pad_1/screens/home_screen.dart';
import 'package:flutter_pad_1/screens/profile_screen.dart';
import 'package:flutter_pad_1/screens/search_screen.dart';
import 'package:flutter_pad_1/widgets/upload_mock_data_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int screenIndex = 0; // Index of selected screen
  final screens = [
    HomeScreen(),
    const SearchScreen(),
    const AddScreen(),
    // const ChatListScreen(),
    const UploadMockDataScreen(),
    ProfileScreen()
  ]; // Screen Lst

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.network(
          logoUrl,
          height: 40,
          ),
          centerTitle: true,
      ),
      body: SafeArea(
        child: screens.elementAt(screenIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: screenIndex, // Show the correct item as selected
        onTap: (index) {
          setState(() {
            screenIndex = index; // Update screenIndex when an item is tapped
          });
        },
        selectedItemColor: Colors.green, // Color when the item is selected
        unselectedItemColor: Colors.grey, // Color when the item is unselected
        type: BottomNavigationBarType.fixed, // Keeps all items fixed (non-shifting)
        showUnselectedLabels: true, // Show labels for unselected items
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined), // Icon for Home
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined), // Icon for Search
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_outlined), // Icon for Add
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_outlined), // Icon for Chat
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined), // Icon for Profile
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}