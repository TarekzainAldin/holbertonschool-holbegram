import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import '../screens/pages/feed.dart';
import '../screens/pages/search.dart';
import '../screens/pages/add_image.dart';
import '../screens/pages/favorite.dart';
import '../screens/pages/profile_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(); // Initialize the PageController
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose the PageController to free resources
    super.dispose();
  }

  // Function to handle page change
  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List<BottomNavyBarItem> _buildBottomNavItems() {
    return [
      BottomNavyBarItem(
        icon: const Icon(Icons.home_outlined),
        title: const Text('Home', style: _navTextStyle),
        activeColor: Colors.red,
        inactiveColor: Colors.black,
      ),
      BottomNavyBarItem(
        icon: const Icon(Icons.search),
        title: const Text('Search', style: _navTextStyle),
        activeColor: Colors.red,
        inactiveColor: Colors.black,
      ),
      BottomNavyBarItem(
        icon: const Icon(Icons.add),
        title: const Text('Add', style: _navTextStyle),
        activeColor: Colors.red,
        inactiveColor: Colors.black,
      ),
      BottomNavyBarItem(
        icon: const Icon(Icons.favorite_outline),
        title: const Text('Favorite', style: _navTextStyle),
        activeColor: Colors.red,
        inactiveColor: Colors.black,
      ),
      BottomNavyBarItem(
        icon: const Icon(Icons.person_outline),
        title: const Text('Profile', style: _navTextStyle),
        activeColor: Colors.red,
        inactiveColor: Colors.black,
      ),
    ];
  }

  static const TextStyle _navTextStyle = TextStyle(
    fontSize: 25,
    fontFamily: 'Billabong',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: [
          const Feed(),
          const Search(),
          AddImage(pageController: _pageController),
          const Favorite(),
          const Profile(),
        ],
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 8,
        curve: Curves.easeInBack,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        items: _buildBottomNavItems(),
      ),
    );
  }
}