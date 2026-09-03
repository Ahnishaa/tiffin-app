import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';
import 'plan_selection_screen.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  bool _isHalal = false;
  bool _isPorkFree = false;
  bool _isVegetarian = false;

  final List<Map<String, dynamic>> _allVendors = [
    {
      'name': 'Dapur Kak Siti',
      'subtitle': 'Traditional Malay',
      'rating': '4.8',
      'distance': '1.2 km',
      'tag': 'Muslim-Owned / Halal',
      'filterTags': ['Halal'],
      'imageUrl': 'https://images.unsplash.com/photo-1596797038530-2c107229654b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      'weeklyPrice': 'RM 45',
      'monthlyPrice': 'RM 150',
      'menus': ['Mon: Nasi Lemak', 'Tue: Rendang Daging', 'Wed: Ayam Merah', 'Thu: Asam Pedas', 'Fri: Soto'],
    },
    {
      'name': "Ravi's Banana Leaf",
      'subtitle': 'Authentic Indian',
      'rating': '4.9',
      'distance': '2.5 km',
      'tag': 'Vegetarian Options',
      'filterTags': ['Vegetarian'],
      'imageUrl': 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      'weeklyPrice': 'RM 50',
      'monthlyPrice': 'RM 165',
      'menus': ['Mon: Veggie Kurma', 'Tue: Dalca', 'Wed: Paneer Masala', 'Thu: Gobi Kashmiri', 'Fri: Sambar'],
    },
    {
      'name': 'Anson Chinese Cookhouse',
      'subtitle': 'Chinese Home Style',
      'rating': '4.7',
      'distance': '3.1 km',
      'tag': 'Pork-Free',
      'filterTags': ['Pork-Free'],
      'imageUrl': 'https://images.unsplash.com/photo-1563245372-f21724e3856d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      'weeklyPrice': 'RM 60',
      'monthlyPrice': 'RM 190',
      'menus': ['Mon: Hainanese Chicken Rice', 'Tue: Sweet & Sour Fish', 'Wed: Mapo Tofu', 'Thu: Lemon Chicken', 'Fri: Hokkien Mee (No Lard)'],
    },
    {
      'name': 'The Green Bowl',
      'subtitle': 'Healthy Salads',
      'rating': '4.9',
      'distance': '1.8 km',
      'tag': 'Vegetarian & Pork-Free',
      'filterTags': ['Vegetarian', 'Pork-Free'],
      'imageUrl': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      'weeklyPrice': 'RM 65',
      'monthlyPrice': 'RM 210',
      'menus': ['Mon: Quinoa Salad', 'Tue: Grilled Tofu Wrap', 'Wed: Vegan Lasagna', 'Thu: Harvest Buddha Bowl', 'Fri: Tempeh Stir-fry'],
    },
    {
      'name': 'Western Grill Bonda',
      'subtitle': 'Home Cooked Western',
      'rating': '4.6',
      'distance': '4.0 km',
      'tag': 'Muslim-Owned / Halal',
      'filterTags': ['Halal'],
      'imageUrl': 'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=800&q=80',
      'weeklyPrice': 'RM 55',
      'monthlyPrice': 'RM 180',
      'menus': ['Mon: Grilled Chicken Chop', 'Tue: Spaghetti Carbonara', 'Wed: Black Pepper Beef', 'Thu: Mushroom Soup & Garlic Bread', 'Fri: Fish and Chips'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundCanvas,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70,
        titleSpacing: 0,
        title: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: [
              const Text(
                'Tiffin',
                style: TextStyle(
                  color: AppTheme.primaryBrand,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 16),
              const Icon(LucideIcons.mapPin, color: AppTheme.primaryBrand, size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Zone A: Kolej 10, Serdang',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(LucideIcons.chevronDown, color: AppTheme.textMuted, size: 16),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppTheme.backgroundCanvas,
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.shoppingBag, color: AppTheme.textDark, size: 20),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => Navigator.of(context).pushReplacementNamed('/'),
                child: const Icon(LucideIcons.logOut, color: AppTheme.textMuted, size: 20),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/tiffin_pattern_blank.png'),
                fit: BoxFit.cover,
                opacity: 0.15, // Subtle watermark
              ),
            ),
          ),
          SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 60), // Breathing room at bottom
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar Area
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundCanvas,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: const Row(
                        children: [
                          Icon(LucideIcons.search, color: AppTheme.textMuted, size: 20),
                          SizedBox(width: 12),
                          Text(
                            'Craving home-cooked meals?',
                            style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBrand.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(LucideIcons.slidersHorizontal, color: AppTheme.primaryBrand),
                      onPressed: () => _showFilterBottomSheet(context),
                    ),
                  ),
                ],
              ),
            ),

            // Modern Horizontal Category Selector
            SizedBox(
              height: 130, // Safely expanded to prevent clipping
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  _buildCategory('Malay', 'https://images.unsplash.com/photo-1596797038530-2c107229654b?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80'),
                  _buildCategory('Indian', 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80'),
                  _buildCategory('Chinese', 'https://images.unsplash.com/photo-1563245372-f21724e3856d?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80'),
                  _buildCategory('Healthy', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80'),
                  _buildCategory('Western', 'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=200&q=80'),
                ],
              ),
            ),
            
            // Gorgeous Wide Promo Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '10% OFF your first\nsubscription!',
                            style: TextStyle(
                              color: AppTheme.textDark,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Code: NEWCUST10',
                            style: TextStyle(
                              color: AppTheme.textMuted,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundCanvas,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.ticket, color: AppTheme.primaryBrand, size: 32),
                    ),
                  ],
                ),
              ),
            ),
            
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(
                'Premium Home Chefs',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textDark,
                ),
              ),
            ),
            
            // Dynamic ListView based on filtered data
            Builder(
              builder: (context) {
                // Apply strict AND logic filtering
                List<Map<String, dynamic>> filtered = _allVendors.where((v) {
                  List<String> tags = List<String>.from(v['filterTags']);
                  if (_isHalal && !tags.contains('Halal')) return false;
                  if (_isPorkFree && !tags.contains('Pork-Free')) return false;
                  if (_isVegetarian && !tags.contains('Vegetarian')) return false;
                  return true;
                }).toList();

                if (filtered.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Center(
                      child: Text('No chefs match all your selected filters.', style: TextStyle(color: AppTheme.textMuted)),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final vendor = filtered[index];
                    return _buildVendorCard(
                      context: context,
                      name: vendor['name'],
                      subtitle: vendor['subtitle'],
                      rating: vendor['rating'],
                      distance: vendor['distance'],
                      tag: vendor['tag'],
                      imageUrl: vendor['imageUrl'],
                      weeklyPrice: vendor['weeklyPrice'],
                      monthlyPrice: vendor['monthlyPrice'],
                      menus: List<String>.from(vendor['menus']),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
        ],
      ),
    );
  }

  Widget _buildCategory(String name, String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))
                ]
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVendorCard({
    required BuildContext context,
    required String name,
    required String subtitle,
    required String rating,
    required String distance,
    required String tag,
    required String imageUrl,
    required String weeklyPrice,
    required String monthlyPrice,
    required List<String> menus,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: AppTheme.containerShadow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // High-res Network Image Background Header
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                child: Image.network(
                  imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // Gradient for text readability
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
                    ),
                  ),
                ),
              ),
              // Bright green accent badge
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBrand,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.shieldCheck, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        tag,
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              // Heart icon
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.heart, color: AppTheme.textMuted, size: 16),
                ),
              ),
              // Rating & Time floating block
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.star, color: AppTheme.warning, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      subtitle,
                      style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                    ),
                    const SizedBox(width: 8),
                    Container(width: 4, height: 4, decoration: const BoxDecoration(color: AppTheme.textMuted, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text(
                      distance,
                      style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Cleanly spaced Mon-Fri rotating menu
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundCanvas,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: menus.map((menu) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('•', style: TextStyle(color: AppTheme.primaryBrand, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                menu,
                                style: const TextStyle(
                                  color: AppTheme.textDark,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                
                const SizedBox(height: 16),
                // Premium wide action blocks
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlanSelectionScreen(
                                vendorName: name,
                                planType: 'Weekly Plan',
                                price: weeklyPrice,
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.textDark,
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.grey.shade300, width: 1),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text('Weekly Plan ($weeklyPrice)'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlanSelectionScreen(
                                vendorName: name,
                                planType: 'Monthly Plan',
                                price: monthlyPrice,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBrand,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text('Monthly Plan ($monthlyPrice)'),
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

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter by Dietary',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    title: const Text('Muslim-Owned / Halal', style: TextStyle(fontWeight: FontWeight.bold)),
                    value: _isHalal,
                    onChanged: (val) {
                      setModalState(() => _isHalal = val ?? false);
                      this.setState(() {}); // Update main UI instantly
                    },
                    activeColor: AppTheme.primaryBrand,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  CheckboxListTile(
                    title: const Text('Pork-Free', style: TextStyle(fontWeight: FontWeight.bold)),
                    value: _isPorkFree,
                    onChanged: (val) {
                      setModalState(() => _isPorkFree = val ?? false);
                      this.setState(() {});
                    },
                    activeColor: AppTheme.primaryBrand,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  CheckboxListTile(
                    title: const Text('Vegetarian', style: TextStyle(fontWeight: FontWeight.bold)),
                    value: _isVegetarian,
                    onChanged: (val) {
                      setModalState(() => _isVegetarian = val ?? false);
                      this.setState(() {});
                    },
                    activeColor: AppTheme.primaryBrand,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBrand,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Filters applied!')),
                        );
                      },
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
