import 'package:flutter/material.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/views/account/chat/conversations_screen.dart';
import 'package:fyp_flutter/views/account/dietician_subscription/payment_details.dart';
import 'package:fyp_flutter/views/account/dietician_subscription/subscription_details.dart';
import 'package:fyp_flutter/views/layouts/authenticated_user_layout.dart';

class MainChatScreen extends StatefulWidget {
  static const routeName = 'main';

  const MainChatScreen({super.key});

  @override
  State<MainChatScreen> createState() => _MainChatScreenState();
}

class _MainChatScreenState extends State<MainChatScreen> {
  int currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return AuthenticatedLayout(
      child: Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: const <Widget>[
            ConversationsScreen(),
            SubscriptionDetails(),
            PaymentDetails(),
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
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              label: 'My Dieticians',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.payment),
              label: 'Payment',
            ),
          ],
        ),
      ),
    );
  }
}
