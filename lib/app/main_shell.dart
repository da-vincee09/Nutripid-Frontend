import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Provides the shared layout and bottom navigation for the main app screens.
class MainShell extends StatelessWidget {
  // Holds the GoRouter navigation shell that manages the different navigation branches.
  // A navigation branch is simply a separate section or tab in your application that has its own screens and navigation history.
  final StatefulNavigationShell navigationShell;

  // Constructor that receives the navigation shell from GoRouter.
  const MainShell({super.key, required this.navigationShell});

  // Handles user taps on the bottom navigation tabs.
  void _onTap(int index) {
    // Switches to the selected navigation branch.
    navigationShell.goBranch(
      index,
      // Returns to the branch's first route when the active tab is tapped again.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  // Builds the main layout containing the current screen and bottom navigation.
  Widget build(BuildContext context) {
    return Scaffold(
      // Displays the currently selected screen or navigation branch
      body: navigationShell,

      // Creates the bottom navigation bar.
      bottomNavigationBar: NavigationBar(
        // Identifies which navigation tab is currently selected.
        selectedIndex: navigationShell.currentIndex,

        // Calls _onTap when the user selects a navigation destination
        onDestinationSelected: _onTap,

        // Defines the five navigation destinations of application.
        destinations: const [
          // Home tab with outlined and selected icons.
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),

          // Meals tab for accessing meal-related screens.
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu),
            label: 'Meals',
          ),

          // Planner tab for accessing meal planning features.
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Planner',
          ),

          // For You tab for accessing personalized recommendations.
          NavigationDestination(
            icon: Icon(Icons.recommend_outlined),
            selectedIcon: Icon(Icons.recommend),
            label: 'For You',
          ),

          // Pantry tab for managing available ingredients.
          NavigationDestination(
            icon: Icon(Icons.kitchen_outlined),
            selectedIcon: Icon(Icons.kitchen),
            label: 'Pantry',
          ),
        ],
      ),
    );
  }
}