import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.darkTheme,
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              title: const Text('Executive Data Control'),
              leading: IconButton(
                icon: const Icon(LucideIcons.arrowLeft),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(icon: const Icon(LucideIcons.search), onPressed: () {}),
                IconButton(icon: const Icon(LucideIcons.moreVertical), onPressed: () {}),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Corporate Overview',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Compact 2x2 Dense Analytical Summary Grid
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.6, // More compact height
                    children: [
                      _buildMiniKpiCard(
                        title: 'Total Platform Revenue',
                        value: 'RM 14,250',
                        trend: '+8%',
                        icon: LucideIcons.banknote,
                        color: AppTheme.primaryBrand,
                      ),
                      _buildMiniKpiCard(
                        title: 'Active Subscriptions',
                        value: '142',
                        trend: '+12%',
                        icon: LucideIcons.users,
                        color: AppTheme.primaryBrand,
                      ),
                      _buildMiniKpiCard(
                        title: 'Active Chefs',
                        value: '18',
                        trend: '+3',
                        icon: LucideIcons.chefHat,
                        color: AppTheme.primaryBrand,
                      ),
                      _buildMiniKpiCard(
                        title: 'Pending KKM Apps',
                        value: '3',
                        trend: 'Action Reqd',
                        icon: LucideIcons.fileWarning,
                        color: AppTheme.warning,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  
                  // Smart Cluster Routing Analytics
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Cluster Routing',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBrand.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.primaryBrand.withValues(alpha: 0.3)),
                        ),
                        child: const Row(
                          children: [
                            Icon(LucideIcons.radioReceiver, color: AppTheme.primaryBrand, size: 14),
                            SizedBox(width: 6),
                            Text(
                              'Live Hub',
                              style: TextStyle(
                                color: AppTheme.primaryBrand,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Geographic Routing Visualization Container (Compacted)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: AppTheme.darkContainerShadow,
                    child: Column(
                      children: [
                        _buildRoutingProgressBlock(
                          zone: 'Shah Alam Cluster B',
                          driver: '1 Lalamove Rider (Ahmad)',
                          totalOrders: 15,
                          capacity: 20,
                          status: 'Dispatched',
                          color: Colors.blueAccent,
                        ),
                        const SizedBox(height: 16),
                        _buildRoutingProgressBlock(
                          zone: 'Petaling Jaya Cluster A',
                          driver: 'Pending Batch',
                          totalOrders: 38,
                          capacity: 50,
                          status: 'Batching',
                          color: Colors.orangeAccent,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // AI Optimization Alert (Compacted)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade900.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.zap, color: Colors.purpleAccent, size: 24),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AI Routing Suggestion',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.purpleAccent,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Merge Shah Alam & Subang to save RM15.00.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildMiniKpiCard({
    required String title,
    required String value,
    required String trend,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.darkContainerShadow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 18),
              Text(
                trend,
                style: TextStyle(
                  color: trend.contains('+') ? AppTheme.primaryBrand : (color == AppTheme.warning ? AppTheme.warning : Colors.white70),
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRoutingProgressBlock({
    required String zone,
    required String driver,
    required int totalOrders,
    required int capacity,
    required String status,
    required Color color,
  }) {
    final double percentage = totalOrders / capacity;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              zone,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
            Text(
              status,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(LucideIcons.truck, size: 12, color: Colors.white.withValues(alpha: 0.5)),
                const SizedBox(width: 4),
                Text(
                  driver,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Text(
              '$totalOrders/$capacity',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 6,
            backgroundColor: Colors.white.withValues(alpha: 0.05),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
