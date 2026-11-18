import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/home_screen.dart';
import 'screens/my_subscription_screen.dart';
import 'screens/plans_screen.dart';
import 'screens/profile_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://vjudomkqamghtfhjlcmz.supabase.co',
    anonKey: 'sb_publishable_E65lkio48vvX7t5T_TYpYA_DoxxTmo1',
  );

  runApp(const TheGymApp());
}

class TheGymApp extends StatelessWidget {
  const TheGymApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Gym',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(
        onNavigateToMySubscription: () => setState(() => _selectedIndex = 2),
        onNavigateToProfile: () => setState(() => _selectedIndex = 3),
      ),
      const PlansScreen(),
      const MySubscriptionScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primaryTealLight,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppColors.primaryTeal),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view, color: AppColors.primaryTeal),
            label: 'Plans',
          ),
          NavigationDestination(
            icon: Icon(Icons.badge_outlined),
            selectedIcon: Icon(Icons.badge, color: AppColors.primaryTeal),
            label: 'My Subscription',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppColors.primaryTeal),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
