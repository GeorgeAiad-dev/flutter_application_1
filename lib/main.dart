import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
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
      const _PlaceholderScreen(
        title: 'Plans',
        subtitle: 'Coming in Part 3',
        icon: Icons.card_membership_outlined,
      ),
      const _PlaceholderScreen(
        title: 'My Subscription',
        subtitle: 'Coming in Part 3',
        icon: Icons.verified_user_outlined,
      ),
      const _PlaceholderScreen(
        title: 'Profile',
        subtitle: 'Coming in Part 2',
        icon: Icons.person_outline,
      ),
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

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _PlaceholderScreen({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 54, color: AppColors.primaryTeal),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: AppColors.textGrey)),
          ],
        ),
      ),
    );
  }
}
