import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/data_provider.dart';
import '../models/meal.dart';
import '../theme/app_theme.dart';

class CookDashboard extends StatelessWidget {
  final VoidCallback? onBack;
  const CookDashboard({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final dataProvider = context.watch<DataProvider>();
    final userProfile = authProvider.user;
    final meals = dataProvider.meals.where((m) => m.cookId == authProvider.user?['uid']).toList();
    final orders = dataProvider.orders;

    // Calculate wallet balance (fallback to 0.0)
    final walletBalance = (userProfile?['walletBalance'] ?? 0.0).toDouble();

    // Calculate bulk prep forecast (count orders for today/upcoming)
    final totalDeliveries = orders.length; // Simplified for now

    return Scaffold(
      backgroundColor: AppTheme.backgroundCanvas,
      appBar: AppBar(
        title: const Text('Chef Command Center'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppTheme.textDark),
          onPressed: () {
            if (onBack != null) {
              onBack!();
            } else if (Navigator.of(context).canPop()) {
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.bell, color: AppTheme.textDark),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              context.read<AuthProvider>().logout();
              Navigator.of(context).pushReplacementNamed('/');
            },
            child: const Icon(LucideIcons.logOut, color: AppTheme.textMuted, size: 20),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chef Wallet Card
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Chef Wallet',
                        style: TextStyle(
                          color: AppTheme.textDark,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(LucideIcons.wallet, color: AppTheme.primaryBrand, size: 24),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Available Payout Balance',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'RM ${walletBalance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppTheme.textDark,
                      fontSize: 44,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        LucideIcons.landmark,
                        color: Colors.white,
                        size: 20,
                      ),
                      label: const Text(
                        'Withdraw to Bank Account',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBrand,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            
            // Your Fixed Weekly Rotation Menu
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBrand.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(LucideIcons.calendarDays, color: AppTheme.primaryBrand),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Your Fixed Weekly Rotation Menu',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textDark,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.plusCircle, color: AppTheme.primaryBrand),
                  onPressed: () {
                    _showMealDialog(context, null, userProfile?['uid']);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'This is your locked-in bulk cooking schedule.',
              style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
            ),
            const SizedBox(height: 24),
            
            Container(
              padding: const EdgeInsets.all(24),
              decoration: AppTheme.containerShadow,
              child: meals.isEmpty
                  ? const Text('No meals added yet. Click + to add.', style: TextStyle(color: AppTheme.textMuted))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: meals.map((meal) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: InkWell(
                            onTap: () => _showMealDialog(context, meal, userProfile?['uid']),
                            child: _MenuRowItem(day: meal.dayOfWeek.substring(0, 3), meal: meal.name),
                          ),
                        );
                      }).toList(),
                    ),
            ),
            const SizedBox(height: 40),

            // Bulk Prep Forecast
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBrand.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(LucideIcons.chefHat, color: AppTheme.primaryBrand),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Bulk Prep Forecast',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Zero-waste fixed menu tracking for your next bulk cooking cycle.',
              style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
            ),
            const SizedBox(height: 24),
            
            Container(
              padding: const EdgeInsets.all(24),
              decoration: AppTheme.containerShadow,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Monday Deliveries',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textMuted),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: const Text(
                          'In Progress',
                          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '$totalDeliveries',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.textDark,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Tiffins Scheduled for Delivery',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    'Menu Breakdown:',
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark),
                  ),
                  const SizedBox(height: 8),
                  if (meals.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(meals.first.name, style: const TextStyle(color: AppTheme.textMuted)),
                        Text('x$totalDeliveries', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Swap & Drop Container Return Log
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(LucideIcons.refreshCw, color: Colors.blue),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Swap & Drop Container Log',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textDark,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Track your physical stainless steel tiffin assets in the circular economy loop.',
              style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
            ),
            const SizedBox(height: 24),
            
            Container(
              padding: const EdgeInsets.all(24),
              decoration: AppTheme.containerShadow,
              child: Column(
                children: [
                  _buildLogItem('Tiffins Dispatched Today', '78', AppTheme.textDark),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  _buildLogItem('Empty Tiffins Collected Back', '72/78', AppTheme.primaryBrand),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  _buildLogItem('Outstanding Containers', '6', AppTheme.danger),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Solid Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBrand, // Premium Green #00B159
                  foregroundColor: Colors.white, // Sharp white text
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Confirm Bulk Inventory',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildLogItem(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppTheme.textMuted,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  void _showMealDialog(BuildContext context, Meal? meal, String? cookId) {
    if (cookId == null) return;
    final nameController = TextEditingController(text: meal?.name);
    final dayController = TextEditingController(text: meal?.dayOfWeek ?? 'Monday');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(meal == null ? 'Add Meal' : 'Edit Meal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Meal Name'),
              ),
              TextField(
                controller: dayController,
                decoration: const InputDecoration(labelText: 'Day of Week'),
              ),
            ],
          ),
          actions: [
            if (meal != null)
              TextButton(
                onPressed: () {
                  context.read<DataProvider>().deleteMeal(meal.id);
                  Navigator.pop(context);
                },
                child: const Text('Delete', style: TextStyle(color: AppTheme.danger)),
              ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newMeal = Meal(
                  id: meal?.id ?? '',
                  name: nameController.text,
                  description: meal?.description ?? '',
                  dayOfWeek: dayController.text,
                  cookId: cookId,
                );
                if (meal == null) {
                  context.read<DataProvider>().addMeal(newMeal);
                } else {
                  context.read<DataProvider>().updateMeal(newMeal);
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class _MenuRowItem extends StatelessWidget {
  final String day;
  final String meal;

  const _MenuRowItem({required this.day, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.primaryBrand.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            day,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.primaryBrand,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            meal,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark,
            ),
          ),
        ),
      ],
    );
  }
}
