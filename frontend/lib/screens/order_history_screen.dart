import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _allOrders = [
    {
      'id': '#TF-20240604',
      'date': 'Today, 12:30 PM',
      'cook': "Aunty Lim's Kitchen",
      'cookAvatar': '👩‍🍳',
      'items': ['Nasi Lemak (x1)', 'Ayam Masak Merah (x1)'],
      'total': 'RM 14.90',
      'status': 'Delivered',
      'rating': 5,
    },
    {
      'id': '#TF-20240603',
      'date': 'Yesterday, 1:05 PM',
      'cook': "Chef Rajan's Meals",
      'cookAvatar': '👨‍🍳',
      'items': ['Dhal Rice (x1)', 'Rasam Soup (x1)', 'Papadum (x2)'],
      'total': 'RM 12.50',
      'status': 'Delivered',
      'rating': 4,
    },
    {
      'id': '#TF-20240601',
      'date': '1 Jun, 12:45 PM',
      'cook': 'Mak Cik Bedah',
      'cookAvatar': '👵',
      'items': ['Nasi Campur (x1)', 'Sirap Bandung (x1)'],
      'total': 'RM 10.00',
      'status': 'Delivered',
      'rating': 0,
    },
    {
      'id': '#TF-20240530',
      'date': '30 May, 11:50 AM',
      'cook': "Aunty Lim's Kitchen",
      'cookAvatar': '👩‍🍳',
      'items': ['Char Kway Teow (x1)'],
      'total': 'RM 9.90',
      'status': 'Cancelled',
      'rating': 0,
    },
    {
      'id': '#TF-20240528',
      'date': '28 May, 12:15 PM',
      'cook': "Chef Rajan's Meals",
      'cookAvatar': '👨‍🍳',
      'items': ['Chicken Briyani (x1)', 'Raita (x1)'],
      'total': 'RM 16.00',
      'status': 'Delivered',
      'rating': 5,
    },
  ];

  List<Map<String, dynamic>> get _delivered =>
      _allOrders.where((o) => o['status'] == 'Delivered').toList();

  List<Map<String, dynamic>> get _cancelled =>
      _allOrders.where((o) => o['status'] == 'Cancelled').toList();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundCanvas,
      appBar: AppBar(
        title: const Text('Order History'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryBrand,
          unselectedLabelColor: AppTheme.textMuted,
          indicatorColor: AppTheme.primaryBrand,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Delivered'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _OrderList(orders: _allOrders),
          _OrderList(orders: _delivered),
          _OrderList(orders: _cancelled),
        ],
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  final List<Map<String, dynamic>> orders;
  const _OrderList({required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppTheme.primaryBrand.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.shoppingBag,
                  size: 48, color: AppTheme.primaryBrand),
            ),
            const SizedBox(height: 20),
            const Text('No orders here yet',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textDark)),
            const SizedBox(height: 8),
            const Text('Your past meals will show up here.',
                style: TextStyle(color: AppTheme.textMuted)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) => _OrderCard(order: orders[i]),
    );
  }
}

class _OrderCard extends StatefulWidget {
  final Map<String, dynamic> order;
  const _OrderCard({required this.order});

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard> {
  bool _expanded = false;
  int _userRating = 0;

  Color _statusColor(String status) {
    switch (status) {
      case 'Delivered':
        return const Color(0xFF22C55E);
      case 'Cancelled':
        return AppTheme.danger;
      default:
        return Colors.orange;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'Delivered':
        return LucideIcons.checkCircle2;
      case 'Cancelled':
        return LucideIcons.xCircle;
      default:
        return LucideIcons.clock;
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final statusColor = _statusColor(order['status'] as String);
    final bool isDelivered = order['status'] == 'Delivered';
    final int savedRating = order['rating'] as int;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Header row ────────────────────────────────────────────────
          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Cook avatar bubble
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBrand.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      order['cookAvatar'] as String,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order['cook'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            color: AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          order['date'] as String,
                          style: const TextStyle(
                              fontSize: 12, color: AppTheme.textMuted),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        order['total'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_statusIcon(order['status'] as String),
                              size: 12, color: statusColor),
                          const SizedBox(width: 4),
                          Text(
                            order['status'] as String,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _expanded
                        ? LucideIcons.chevronUp
                        : LucideIcons.chevronDown,
                    size: 18,
                    color: AppTheme.textMuted,
                  ),
                ],
              ),
            ),
          ),

          // ── Expanded detail section ───────────────────────────────────
          if (_expanded) ...[
            const Divider(height: 1, indent: 16, endIndent: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order ID
                  Row(
                    children: [
                      const Icon(LucideIcons.receipt,
                          size: 14, color: AppTheme.textMuted),
                      const SizedBox(width: 6),
                      Text(
                        'Order ${order['id']}',
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textMuted,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Items list
                  const Text(
                    'ITEMS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textMuted,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ...List<String>.from(order['items'] as List).map(
                    (item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.dot,
                              size: 16, color: AppTheme.textMuted),
                          Text(item,
                              style: const TextStyle(
                                  fontSize: 13, color: AppTheme.textDark)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Rating section (only for delivered & not yet rated)
                  if (isDelivered && savedRating == 0) ...[
                    const Text(
                      'RATE THIS MEAL',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textMuted,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(5, (i) {
                        return GestureDetector(
                          onTap: () => setState(() => _userRating = i + 1),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Icon(
                              _userRating > i
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              color: _userRating > i
                                  ? Colors.amber
                                  : Colors.grey.shade300,
                              size: 28,
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Already rated badge
                  if (isDelivered && savedRating > 0) ...[
                    Row(
                      children: [
                        ...List.generate(
                          savedRating,
                          (_) => const Icon(Icons.star_rounded,
                              color: Colors.amber, size: 18),
                        ),
                        const SizedBox(width: 6),
                        const Text('You rated this meal',
                            style: TextStyle(
                                fontSize: 12, color: AppTheme.textMuted)),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Action buttons
                  Row(
                    children: [
                      if (isDelivered)
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(LucideIcons.refreshCw, size: 15),
                            label: const Text('Reorder'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.primaryBrand,
                              side: const BorderSide(
                                  color: AppTheme.primaryBrand),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      if (isDelivered) const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(LucideIcons.helpCircle, size: 15),
                          label: const Text('Get Help'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.textMuted,
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding:
                                const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
