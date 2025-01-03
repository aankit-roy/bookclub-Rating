

import 'package:bookclub/res/colors/app_colors.dart';
import 'package:bookclub/screens/discover_book_screen.dart';
import 'package:bookclub/screens/favourite_book_screen.dart';
import 'package:bookclub/screens/home_screen.dart';
import 'package:bookclub/screens/profile_screen.dart';
import 'package:bookclub/screens/search_bar_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {

  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: PersistentTabView(
  //       context,
  //       controller: PersistentTabController(initialIndex: 0),
  //       screens:  const [
  //         HomeScreen(), // Replace with your actual tab screens
  //         ChallengesScreen(),
  //         ProgressScreen(),
  //         CommunityScreen(),
  //         ProfileScreen(),
  //       ],
  //       items: [
  //         PersistentBottomNavBarItem(
  //           icon: const Icon(Icons.home_filled),
  //           title: 'Home',
  //           activeColorPrimary: AppColors.primary,
  //           inactiveColorPrimary: Colors.grey,
  //         ),
  //         PersistentBottomNavBarItem(
  //           icon: const Icon(Icons.accessibility),
  //           title: 'Challenges',
  //           activeColorPrimary: AppColors.primary,
  //           inactiveColorPrimary: Colors.grey,
  //         ),
  //         PersistentBottomNavBarItem(
  //           icon: const Icon(Icons.bar_chart_outlined),
  //           title: 'Progress',
  //           activeColorPrimary: AppColors.primary,
  //           inactiveColorPrimary: Colors.grey,
  //         ),
  //         PersistentBottomNavBarItem(
  //           icon: const Icon(Icons.group),
  //           title: 'Community',
  //           activeColorPrimary: AppColors.primary,
  //           inactiveColorPrimary: Colors.grey,
  //         ),
  //         PersistentBottomNavBarItem(
  //           icon: const Icon(Icons.person),
  //           title: 'Me',
  //           activeColorPrimary: AppColors.primary,
  //           inactiveColorPrimary: Colors.grey,
  //         ),
  //       ],
  //
  //       confineToSafeArea: true,
  //       backgroundColor: Colors.grey.shade100,
  //       handleAndroidBackButtonPress: true,
  //       resizeToAvoidBottomInset: true,
  //       stateManagement: true,
  //       hideNavigationBarWhenKeyboardAppears: true,
  //       navBarHeight:60.sp,
  //
  //       decoration:  const NavBarDecoration(
  //           colorBehindNavBar: AppColors.primary
  //
  //       ),
  //
  //     ),
  //   );
  // }

  int _currentIndex = 0;

  // List of screens for each tab in the BottomNavigationBar
  final List<Widget> _screens = [
    const HomeScreen(),
     const DiscoverBookScreen(category: "startup",),
     const SearchBarScreen(),
     const FavouriteBookScreen(),
    const ProfileScreen()
  ];

  // Function to update the selected index when a tab is tapped
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  //implement at last
  // Future<bool> _onWillPop() async {
  //   // If user is not on the home page, navigate back to the home page
  //   if (_currentIndex != 0) {
  //     setState(() {
  //       _currentIndex = 0;
  //     });
  //     return Future.value(false); // Prevent app from exiting
  //   } else {
  //     // If user is already on the home page, allow app to exit
  //     return Future.value(true);
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],  // Display the current screen
      bottomNavigationBar: Container(
        height: 70.h,
        decoration: BoxDecoration(
            color: AppColors.tertiary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.tertiary.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 10,
              ),
            ]),
        child: bottomNavBar(),
      ),
    );
  }

  BottomNavigationBar bottomNavBar() {
    return BottomNavigationBar(
      // backgroundColor: AppColors.success,
      currentIndex: _currentIndex,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      iconSize: 26.sp,
      onTap: _onTabTapped,
      items: const [
        BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("assets/icons/home.png")),
            label: 'Home'
        ),
        BottomNavigationBarItem(
            icon:  ImageIcon(AssetImage("assets/icons/discover.png")),
            label: 'Discover'
        ),
        BottomNavigationBarItem(
            icon:  ImageIcon(AssetImage("assets/icons/search.png")),
            label: 'Search'
        ),
        BottomNavigationBarItem(
            icon:  ImageIcon(AssetImage("assets/icons/favourite2.png")),
            label: 'Favourites'
        ),
        BottomNavigationBarItem(
            icon:  ImageIcon(AssetImage("assets/icons/profile.png")),
            label: 'Me'
        ),
      ],
    );
  }
}
