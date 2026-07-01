import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DeliveryTrackerScreen extends StatefulWidget {
  const DeliveryTrackerScreen({super.key});

  @override
  State<DeliveryTrackerScreen> createState() => _DeliveryTrackerScreenState();
}

class _DeliveryTrackerScreenState extends State<DeliveryTrackerScreen> {
  int _currentStep = 0;
  Timer? _timer;

  final List<LatLng> _routePoints = [
    const LatLng(3.1412, 101.6865), // Restaurant
    const LatLng(3.1425, 101.6870),
    const LatLng(3.1438, 101.6885),
    const LatLng(3.1440, 101.6890),
    const LatLng(3.1450, 101.6910), // Home
  ];

  LatLng _interpolate(double progress) {
    if (progress <= 0) return _routePoints.first;
    if (progress >= 1) return _routePoints.last;
    
    double totalSegments = (_routePoints.length - 1).toDouble();
    double currentSegment = progress * totalSegments;
    int startIndex = currentSegment.floor();
    int endIndex = startIndex + 1;
    double segmentProgress = currentSegment - startIndex;

    LatLng start = _routePoints[startIndex];
    LatLng end = _routePoints[endIndex];

    return LatLng(
      start.latitude + (end.latitude - start.latitude) * segmentProgress,
      start.longitude + (end.longitude - start.longitude) * segmentProgress,
    );
  }

  // Grab-style dynamic text
  final List<Map<String, String>> _statusMessages = [
    {
      'title': "Your order's in the kitchen.",
      'subtitle': "We'll let you know when it's out for delivery.",
      'image': 'https://images.unsplash.com/photo-1556910103-1c02745aae4d?w=500&q=80', // Kitchen prep
    },
    {
      'title': "Your order is ready.",
      'subtitle': "Waiting for the delivery partner to pick it up.",
      'image': 'https://images.unsplash.com/photo-1588675646184-f5b0b0b0b2de?w=500&q=80', // Packed food
    },
    {
      'title': "Your order is on the way.",
      'subtitle': "The delivery partner is heading your way.",
      'image': 'https://images.unsplash.com/photo-1526304640581-d334cdbbf45e?w=500&q=80', // Delivery bag/scooter
    },
    {
      'title': "Swap & Drop!",
      'subtitle': "Leave your empty tiffin out for collection.",
      'image': 'https://images.unsplash.com/photo-1498837167922-ddd27525d352?w=500&q=80', // Home food
    },
  ];

  @override
  void initState() {
    super.initState();
    // Simulate time-based progression
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentStep < 3) {
        setState(() {
          _currentStep++;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentStatus = _statusMessages[_currentStep];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronDown, color: AppTheme.textDark, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Contact Support',
              style: TextStyle(
                color: AppTheme.textDark,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // ── Grab-style Header ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ETA
                      const Text(
                        '12:20 - 12:35 PM',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.textDark,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Main Status Text
                      Text(
                        currentStatus['title']!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
                // Illustration Circle
                Expanded(
                  flex: 1,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(currentStatus['image']!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Animated Map Tracking (Visible only on step 2) ──
          if (_currentStep == 2)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: FlutterMap(
                  options: const MapOptions(
                    initialCenter: LatLng(3.1431, 101.6887),
                    initialZoom: 15.5,
                    interactionOptions: InteractionOptions(flags: InteractiveFlag.none),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.tiffin_app',
                    ),
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: _routePoints,
                          color: AppTheme.primaryBrand,
                          strokeWidth: 4.0,
                        ),
                      ],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _routePoints.first,
                          width: 40,
                          height: 40,
                          child: const Icon(LucideIcons.store, color: AppTheme.primaryBrand, size: 30),
                        ),
                        Marker(
                          point: _routePoints.last,
                          width: 40,
                          height: 40,
                          child: const Icon(LucideIcons.home, color: AppTheme.primaryBrand, size: 30),
                        ),
                      ],
                    ),
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(seconds: 5), // Same as timer step duration
                      builder: (context, value, child) {
                        final currentPosition = _interpolate(value);
                        return MarkerLayer(
                          markers: [
                            Marker(
                              point: currentPosition,
                              width: 40,
                              height: 40,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: AppTheme.primaryBrand,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))
                                  ],
                                ),
                                child: const Icon(LucideIcons.bike, color: Colors.white, size: 20),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

          // ── Horizontal Progress Bar ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildProgressNode(0, LucideIcons.store),
                _buildProgressLine(0),
                _buildProgressNode(1, LucideIcons.utensils),
                _buildProgressLine(1),
                _buildProgressNode(2, LucideIcons.bike),
                _buildProgressLine(2),
                _buildProgressNode(3, LucideIcons.home),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Subtitle Text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                currentStatus['subtitle']!,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppTheme.textDark,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
          
          const Spacer(),

          // ── Zero-Waste Impact Badge ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryBrand.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryBrand.withValues(alpha: 0.2)),
              ),
              child: const Row(
                children: [
                  Text('🌿', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'You saved 18 plastic containers this month.',
                      style: TextStyle(
                        color: AppTheme.primaryBrand,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),

          // ── Grab-style Driver Bottom Sheet ──
          Container(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle indicator
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Row(
                  children: [
                    // Driver photo
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade200),
                        image: const DecorationImage(
                          image: NetworkImage('https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=200&q=80'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Driver Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ahmad',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              color: AppTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'BND 1234 • Honda EX5',
                            style: TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Colors.orange, size: 16),
                              const SizedBox(width: 4),
                              const Text(
                                '4.9',
                                style: TextStyle(
                                  color: AppTheme.textDark,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Lalamove',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Actions
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: IconButton(
                        icon: const Icon(LucideIcons.messageCircle, color: AppTheme.textDark),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF22C55E), // WhatsApp/Phone Green
                      ),
                      child: IconButton(
                        icon: const Icon(LucideIcons.phone, color: Colors.white),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressNode(int stepIndex, IconData icon) {
    final bool isCompletedOrActive = _currentStep >= stepIndex;
    return Container(
      padding: const EdgeInsets.all(4),
      child: Icon(
        icon,
        color: isCompletedOrActive ? AppTheme.primaryBrand : Colors.grey.shade300,
        size: 24,
      ),
    );
  }

  Widget _buildProgressLine(int lineIndex) {
    // If the current step is greater than the line index, it means we have passed this line.
    final bool isFilled = _currentStep > lineIndex;
    
    return Expanded(
      child: Container(
        height: 4,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isFilled ? AppTheme.primaryBrand : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
