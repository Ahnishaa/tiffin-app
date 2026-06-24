import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'firebase_options.dart';
import 'services/firebase_auth_service.dart';
import 'providers/auth_provider.dart';
import 'providers/data_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/customer_home.dart';
import 'screens/delivery_tracker.dart';
import 'screens/customer_profile.dart';
import 'screens/cook_dashboard.dart'; // Make sure this file exists!
import 'screens/admin_dashboard.dart'; // Make sure this file exists!

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await dotenv.load(fileName: ".env");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization failed. Please run 'flutterfire configure'. Error: $e");
  }

  final authService = FirebaseAuthService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            authService: authService,
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, DataProvider>(
          create: (_) => DataProvider()..loadMeals(),
          update: (_, auth, data) {
            final provider = data ?? DataProvider()..loadMeals();
            if (auth?.isAuthenticated == true) {
              final uid = FirebaseAuth.instance.currentUser?.uid;
              if (uid != null && auth?.user != null) {
                provider.loadUserSubscription(uid);
                if (auth!.user!['role'] == 'COOK') {
                  provider.loadCookOrders(uid);
                } else {
                  provider.loadUserOrders(uid);
                }
              }
            }
            return provider;
          },
        ),
      ],
      child: const TiffinApp(),
    ),
  );
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

  void _updateIndex(int index) {
    if (_selectedIndex != index) {
      HapticFeedback.mediumImpact();
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Widget _buildActiveScreen() {
    switch (_selectedIndex) {
      case 0:
        return const CustomerHomeScreen();
      case 1:
        return const DeliveryTrackerScreen();
      case 2:
        return CustomerProfileScreen(
          onSwitchPortal: (index) => _updateIndex(index),
        );
      case 3:
        return CookDashboard(
          onBack: () => _updateIndex(2),
        );
      case 4:
        return AdminDashboard(
          onBack: () => _updateIndex(2),
        );
      default:
        return const CustomerHomeScreen();
    }
  }

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
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    final fadeTransition = FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                    return ScaleTransition(
                      scale: Tween<double>(begin: 0.97, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                      child: fadeTransition,
                    );
                  },
                  child: KeyedSubtree(
                    key: ValueKey<int>(_selectedIndex),
                    child: _buildActiveScreen(),
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
                    onTap: (index) => _updateIndex(index),
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
}
