import 'package:flutter/material.dart';
import 'package:recova/pages/home_page.dart';
// import 'package:recova/pages/stats_page.dart';
// import 'package:recova/pages/community_page.dart';
// import 'package:recova/pages/journal_page.dart';
// import 'package:recova/pages/profile_page.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  final int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    // const StatsPage(),
    // const CommunityPage(),
    // const JournalPage(),
    // const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      // Gunakan IndexedStack untuk menjaga state setiap halaman
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      floatingActionButton: _currentIndex == 2
          ? FloatingActionButton(
              onPressed: () {
                // TODO: Aksi untuk membuat post baru di komunitas
              },
              backgroundColor: const Color(0xFF2EC4B6),
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2EC4B6),
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          // setState(() {
          //   _currentIndex = index;
          // });
        },
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/menu/home_icon.png')),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/menu/stat_icon.png')),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/menu/comm_icon.png')),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/menu/book_icon.png')),
            label: 'Journal',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/menu/setting_icon.png')),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}