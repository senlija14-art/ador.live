import 'package:flutter/material.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 3; // অ্যাপ খুললেই যেন Me (প্রোফাইল) ট্যাব আগে দেখা যায়

  final List<Widget> _pages = const [
    _PlaceholderTab(title: 'Voice Room', icon: Icons.meeting_room_rounded),
    _PlaceholderTab(title: 'Moment Feed', icon: Icons.public_rounded),
    _PlaceholderTab(title: 'Messages', icon: Icons.mail_rounded),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF06211D),
          border: Border(
            top: BorderSide(color: Color(0x33D4AF37), width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF1DE99B),
          unselectedItemColor: Colors.white60,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.meeting_room_rounded),
              label: 'Room',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.public_rounded),
              label: 'Moment',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.mail_rounded),
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '1',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
                ],
              ),
              label: 'Message',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_rounded),
              label: 'Me',
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final String title;
  final IconData icon;
  const _PlaceholderTab({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF061E1B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF082E26),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: const Color(0xFF1DE99B)),
            const SizedBox(height: 12),
            Text(
              '$title পেজটি পরের ধাপে যুক্ত হবে',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
