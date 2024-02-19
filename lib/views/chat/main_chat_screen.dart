import 'package:flutter/material.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/views/chat/conversations_screen.dart';

class MainChatScreen extends StatefulWidget {
  static const routeName = 'main';

  const MainChatScreen({super.key});

  @override
  _MainChatScreenState createState() => _MainChatScreenState();
}

class _MainChatScreenState extends State<MainChatScreen> {
  int currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: <Widget>[
          ConversationsScreen(),
          Container(
            color: Colors.green,
          ),
          Container(
            color: Colors.blue,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: TColor.primaryColor1,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        onTap: (int i) {
          setState(() {
            currentIndex = i;
            _pageController.animateToPage(i,
                duration: kTabScrollDuration, curve: Curves.easeIn);
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
