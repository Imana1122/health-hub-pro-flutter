import 'package:flutter/material.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/views/dietician/chat/dietician_conversations_screen.dart';
import 'package:fyp_flutter/views/dietician/profile/dietician_profile_view.dart';

class DieticianCommonLayout extends StatefulWidget {
  const DieticianCommonLayout({super.key});

  @override
  State<DieticianCommonLayout> createState() => _DieticianCommonLayoutState();
}

class _DieticianCommonLayoutState extends State<DieticianCommonLayout> {
  int currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: <Widget>[
          const DieticianProfileView(), // Replace with your conversations screen widget
          const DieticianConversationScreen(),
          Container(color: Colors.blue),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: TColor.primaryColor1,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        onTap: (int index) {
          setState(() {
            currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Home',
          ),
        ],
      ),
    );
  }
}
