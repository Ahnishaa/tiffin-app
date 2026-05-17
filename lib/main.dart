import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'screens/customer_home.dart';
import 'screens/delivery_tracker.dart';
import 'screens/customer_profile.dart';
import 'screens/cook_dashboard.dart'; // Make sure this file exists!
import 'screens/admin_dashboard.dart'; // Make sure this file exists!

void main() {
  runApp(const TiffinApp());
}

class TiffinApp extends StatelessWidget {
  const TiffinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tiffin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF00B159), // Tech Grab Green
        fontFamily: 'Outfit',
      ),
      // FORCE login screen to be the first thing that opens
      initialRoute: '/',
      onGenerateInitialRoutes: (String initialRoute) {
        return [
          MaterialPageRoute(builder: (context) => const AuthScreen()),
        ];
      },
      routes: {
        '/': (context) => const AuthScreen(),
        '/home': (context) => const MainNavigation(initialIndex: 0),
        '/cook': (context) =>
            const MainNavigation(initialIndex: 3), // Cook Mode route
        '/admin': (context) =>
            const MainNavigation(initialIndex: 4), // Admin Mode route
      },
    );
  }
}

class MainNavigation extends StatefulWidget {
  final int initialIndex;
  const MainNavigation({super.key, this.initialIndex = 0});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  // All your screens live here in a master list
  final List<Widget> _screens = [
    const CustomerHomeScreen(),
    const DeliveryTrackerScreen(),
    const CustomerProfileScreen(),
    const CookDashboard(), // Index 3
    const AdminDashboard(), // Index 4
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Scaffold(
            body: Stack(
              children: [
                _screens[_selectedIndex < 3 ? _selectedIndex : _selectedIndex],

                // FLOATING DEV PANEL (Only for your presentation control)
                Positioned(
                  bottom: 80,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildDevButton(Icons.person, 'Cust', 0),
                        _buildDevButton(Icons.restaurant, 'Chef', 3),
                        _buildDevButton(Icons.admin_panel_settings, 'Admin', 4),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Only show the customer bottom bar if we are on customer screens
            bottomNavigationBar: _selectedIndex < 3
                ? BottomNavigationBar(
                    currentIndex: _selectedIndex,
                    selectedItemColor: const Color(0xFF00B159),
                    unselectedItemColor: Colors.grey,
                    backgroundColor: Colors.white,
                    elevation: 10,
                    onTap: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    items: const [
                      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.local_shipping),
                        label: 'Track',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: 'Profile',
                      ),
                    ],
                  )
                : null, // Hide customer bottom bar when on Cook/Admin mode
          ),
        ),
      ),
    );
  }

  Widget _buildDevButton(IconData icon, String label, int targetIndex) {
    bool isActive = _selectedIndex == targetIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = targetIndex;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF00B159) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                fontFamily: 'Outfit',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
