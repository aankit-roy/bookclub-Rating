
import 'package:bookclub/res/theme/app_theme.dart';
import 'package:bookclub/screens/discover_book_screen.dart';
import 'package:bookclub/screens/home_screen.dart';
import 'package:bookclub/screens/onboarding_screen.dart';
import 'package:bookclub/screens/root_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'screens/search_bar_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Set your design size
      minTextAdapt: true, // Ensures text scales properly
      builder: (context, child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'BookClub',
            theme: AppTheme.lightTheme(context),
            // Light theme
            darkTheme: AppTheme.darkTheme(context),
            // Dark theme
            themeMode: ThemeMode.light,
            home: OnboardingScreen(),
            // home: const HomeScreen() // Replace with your homepage widget
          // home: const DiscoverBookScreen(),
          // home: const SearchBarScreen(),
        );
      },
    );
  }
}
