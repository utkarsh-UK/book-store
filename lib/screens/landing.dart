import 'package:bookstore/screens/home.dart';
import 'package:bookstore/screens/saved.dart';
import 'package:bookstore/screens/search.dart';
import 'package:bookstore/util/theme.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final double _navIconSize = 30.0;
  int _currentPageIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = [
      const HomeScreen(),
      const SearchScreen(),
      const SavedScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    final double navBarHeight = screenSize.height * 0.08;
    final double navBarWidth = screenSize.width;

    return Stack(
      fit: StackFit.expand,
      children: [
        //main body
        Positioned.fill(
          child: _screens[_currentPageIndex],
        ),
        //bottom navigation
        _buildBottomNavigationBar(navBarHeight, navBarWidth),
      ],
    );
  }

  /// Creates bottom navbar with given [navBarHeight] and [navBarWidth].
  Widget _buildBottomNavigationBar(double navBarHeight, double navBarWidth) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.white,
        height: navBarHeight,
        width: navBarWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildNavItem(
              navBarHeight,
              _currentPageIndex == 0 ? Icons.home_filled : Icons.home_outlined,
              0
            ),
            _buildNavItem(
              navBarHeight,
              _currentPageIndex == 1 ? Icons.saved_search : Icons.search_sharp,
              1
            ),
            _buildNavItem(
              navBarHeight,
              _currentPageIndex == 2 ? Icons.bookmarks : Icons.bookmark_border,
              2
            ),
          ],
        ),
      ),
    );
  }

  /// Creates individual bottom nav bar item
  Widget _buildNavItem(double navBarHeight, IconData icon, int pageIndex) {
    return GestureDetector(
      onTap: () => setState(() => _currentPageIndex = pageIndex),
      child: Container(
        height: navBarHeight * 0.8,
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Icon(
          icon,
          color: AppTheme.fontDarkColor,
          size: _navIconSize,
        ),
      ),
    );
  }
}
