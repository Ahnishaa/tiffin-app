import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/data_provider.dart';
import '../theme/app_theme.dart';
import 'saved_addresses_screen.dart';
import 'payment_methods_screen.dart';
import 'order_history_screen.dart';
import 'help_center_screen.dart';
import 'edit_profile_screen.dart';

class CustomerProfileScreen extends StatelessWidget {
  final ValueChanged<int>? onSwitchPortal;
  const CustomerProfileScreen({super.key, this.onSwitchPortal});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final dataProvider = context.watch<DataProvider>();
    final userProfile = authProvider.user;
    final subscription = dataProvider.subscription;

    return Scaffold(
      backgroundColor: AppTheme.backgroundCanvas,
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.settings),
            onPressed: () {},
          ),
        ],
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
                opacity: 0.15,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
          children: [
            const SizedBox(height: 24),
            // User Persona Header
            Center(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.primaryBrand.withValues(alpha: 0.2), width: 3),
                    ),
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userProfile?['fullName'] ?? 'User',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userProfile?['phone'] ?? 'Add Phone Number',
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                      );
                    },
                    icon: const Icon(LucideIcons.edit2, size: 16),
                    label: const Text('Edit Profile'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryBrand,
                      side: const BorderSide(color: AppTheme.primaryBrand),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Active Subscription Overview (Credit Card Style)
            if (subscription != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.textDark,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2C2C2C), Color(0xFF1C1C1C)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            subscription.planType,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBrand.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Active',
                              style: TextStyle(
                                color: AppTheme.primaryBrand,
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${subscription.mealsRemaining}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              height: 1,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 6.0),
                            child: Text(
                              'Meals Left',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => _ManageDeliveryModal(
                                subscriptionId: subscription.id,
                                initialActiveDays: subscription.activeDays,
                                initialBatch: subscription.deliveryBatch,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryBrand,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Manage Delivery'),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBrand.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.primaryBrand.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      const Icon(LucideIcons.calendarClock, color: AppTheme.primaryBrand, size: 48),
                      const SizedBox(height: 16),
                      const Text(
                        'No Active Plan',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Subscribe to a meal plan to start receiving delicious home-cooked meals.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppTheme.textMuted),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => onSwitchPortal?.call(0),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBrand,
                        ),
                        child: const Text('Browse Plans'),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 32),

            // Referral Reward Card (Orange)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.gift, color: Colors.orange, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Refer & Earn RM10',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              color: AppTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'RM10 Off with code: HANNAH26',
                            style: TextStyle(
                              color: Colors.orange.shade800,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(LucideIcons.chevronRight, color: Colors.orange),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Portal Switching Section
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, 12),
              child: Text(
                'Switch Account Mode',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                decoration: AppTheme.containerShadow,
                child: Column(
                  children: [
                    _buildSectionTile(
                      LucideIcons.chefHat,
                      'Switch to Chef Center',
                      onTap: () => onSwitchPortal?.call(3),
                    ),
                    Divider(height: 1, indent: 56, color: Colors.grey.shade200),
                    _buildSectionTile(
                      LucideIcons.lock,
                      'Switch to Executive Control',
                      onTap: () => onSwitchPortal?.call(4),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Clean Section Tiles
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                decoration: AppTheme.containerShadow,
                child: Column(
                  children: [
                    _buildSectionTile(
                      LucideIcons.creditCard,
                      'Payment Methods',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PaymentMethodsScreen(),
                        ),
                      ),
                    ),
                    Divider(height: 1, indent: 56, color: Colors.grey.shade200),
                    _buildSectionTile(
                      LucideIcons.mapPin,
                      'Saved Addresses',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SavedAddressesScreen(),
                        ),
                      ),
                    ),
                    Divider(height: 1, indent: 56, color: Colors.grey.shade200),
                    _buildSectionTile(
                      LucideIcons.history,
                      'Order History',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OrderHistoryScreen(),
                        ),
                      ),
                    ),
                    Divider(height: 1, indent: 56, color: Colors.grey.shade200),
                    _buildSectionTile(
                      LucideIcons.helpCircle,
                      'Help Center',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HelpCenterScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            
            TextButton.icon(
              onPressed: () {
                context.read<AuthProvider>().logout();
              },
              icon: const Icon(LucideIcons.logOut, color: AppTheme.danger),
              label: const Text(
                'Log Out',
                style: TextStyle(color: AppTheme.danger, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
        ],
      ),
    );
  }

  Widget _buildSectionTile(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.textDark, size: 22),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textDark),
      ),
      trailing: const Icon(LucideIcons.chevronRight, size: 20, color: AppTheme.textMuted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      onTap: onTap,
    );
  }
}

class _ManageDeliveryModal extends StatefulWidget {
  final String subscriptionId;
  final Map<String, bool> initialActiveDays;
  final String initialBatch;

  const _ManageDeliveryModal({
    required this.subscriptionId,
    required this.initialActiveDays,
    required this.initialBatch,
  });

  @override
  State<_ManageDeliveryModal> createState() => _ManageDeliveryModalState();
}

class _ManageDeliveryModalState extends State<_ManageDeliveryModal> {
  late Map<String, bool> _daysSelected;
  late String? _selectedBatch;

  @override
  void initState() {
    super.initState();
    _daysSelected = Map.from(widget.initialActiveDays);
    _selectedBatch = widget.initialBatch;
  }

  @override
  Widget build(BuildContext context) {
    int skippedDays = _daysSelected.values.where((selected) => !selected).length;

    // Fully wrapped in ScrollView to prevent pixel overflows
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Manage Delivery Schedule',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 24),
            
            // Clean Dropdown Menu
            const Text(
              'Delivery Window',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textMuted),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedBatch,
                  isExpanded: true,
                  icon: const Icon(LucideIcons.chevronDown, color: AppTheme.textMuted),
                  items: const [
                    DropdownMenuItem(value: 'Batch 1 (11:00 AM - 12:00 PM)', child: Text('Batch 1 (11:00 AM - 12:00 PM)')),
                    DropdownMenuItem(value: 'Batch 2 (12:00 PM - 1:00 PM)', child: Text('Batch 2 (12:00 PM - 1:00 PM)')),
                    DropdownMenuItem(value: 'Batch 3 (1:00 PM - 2:00 PM)', child: Text('Batch 3 (1:00 PM - 2:00 PM)')),
                    DropdownMenuItem(value: 'Batch 4 (2:00 PM - 3:00 PM)', child: Text('Batch 4 (2:00 PM - 3:00 PM)')),
                  ],
                  onChanged: (value) => setState(() => _selectedBatch = value),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Rollover Logic Banner
            if (skippedDays > 0)
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBrand.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primaryBrand.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.info, color: AppTheme.primaryBrand, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Meal Paused: $skippedDays Tiffin container rollover credited to your next billing cycle automatically.',
                        style: const TextStyle(
                          color: AppTheme.primaryBrand,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            
            // Weekly Checklist
            const Text(
              'Weekly Checklist',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textMuted),
            ),
            const SizedBox(height: 12),
            _buildDayRow('Monday'),
            _buildDayRow('Tuesday'),
            _buildDayRow('Wednesday'),
            _buildDayRow('Thursday'),
            _buildDayRow('Friday'),
            const SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_selectedBatch != null) {
                    await context.read<DataProvider>().updateSubscriptionPreferences(
                          widget.subscriptionId,
                          _daysSelected,
                          _selectedBatch!,
                        );
                    if (context.mounted) Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('Save Preferences'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayRow(String day) {
    bool isSelected = _daysSelected[day] ?? true;
    return InkWell(
      onTap: () {
        setState(() {
          _daysSelected[day] = !isSelected;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryBrand : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppTheme.primaryBrand : Colors.grey.shade300,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: isSelected ? const Icon(LucideIcons.check, size: 16, color: Colors.white) : null,
            ),
            const SizedBox(width: 16),
            Text(
              day,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppTheme.textDark : AppTheme.textMuted,
                decoration: isSelected ? null : TextDecoration.lineThrough,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
