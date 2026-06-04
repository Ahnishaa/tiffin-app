import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int? _expandedFaqIndex;

  final List<Map<String, dynamic>> _topics = [
    {
      'icon': LucideIcons.packageOpen,
      'label': 'My Order',
      'color': const Color(0xFF6366F1),
    },
    {
      'icon': LucideIcons.creditCard,
      'label': 'Payments',
      'color': const Color(0xFF0EA5E9),
    },
    {
      'icon': LucideIcons.bike,
      'label': 'Delivery',
      'color': const Color(0xFF22C55E),
    },
    {
      'icon': LucideIcons.userCog,
      'label': 'Account',
      'color': Colors.orange,
    },
    {
      'icon': LucideIcons.repeat2,
      'label': 'Refunds',
      'color': const Color(0xFFEC4899),
    },
    {
      'icon': LucideIcons.shieldCheck,
      'label': 'Safety',
      'color': AppTheme.primaryBrand,
    },
  ];

  final List<Map<String, String>> _faqs = [
    {
      'q': 'How do I pause my meal subscription?',
      'a':
          'Go to Profile → Manage Delivery → uncheck the days you want to skip. Your tiffin containers will be credited to your next billing cycle automatically.',
    },
    {
      'q': 'My order hasn\'t arrived — what do I do?',
      'a':
          'First, check your live delivery tracker under the "Track" tab. If the cook has marked it as dispatched but it\'s been over 45 minutes, tap "Get Help" on your order and we\'ll investigate immediately.',
    },
    {
      'q': 'Can I change my delivery address after ordering?',
      'a':
          'You can change the delivery address up to 15 minutes after placing your order. Go to Order History → select the active order → tap Edit Address.',
    },
    {
      'q': 'How do refunds work?',
      'a':
          'If your order is cancelled or there is a quality issue, refunds are processed within 3–5 business days back to your original payment method. For TNG or GrabPay, it may reflect faster.',
    },
    {
      'q': 'How do I become a home cook on TIFFIN.CO?',
      'a':
          'Apply via the Cook Portal. Our team will verify your hygiene certification, kitchen photos, and sample menu. Approval typically takes 3–5 working days.',
    },
    {
      'q': 'Is the Tiffin container returned after delivery?',
      'a':
          'Yes! Our zero-waste programme requires containers to be returned to the delivery rider on the next delivery. You\'ll receive RM 1.00 credit per container returned on time.',
    },
    {
      'q': 'What payment methods are accepted?',
      'a':
          'We accept Credit/Debit Cards (Visa & Mastercard), FPX Online Banking, Touch \'n Go eWallet, and GrabPay.',
    },
    {
      'q': 'How do I cancel my subscription?',
      'a':
          'Go to Profile → Manage Delivery → Subscription Settings → Cancel Plan. Note: cancellations take effect at the end of your current billing cycle. No partial refunds are issued.',
    },
  ];

  List<Map<String, String>> get _filteredFaqs {
    if (_searchQuery.isEmpty) return _faqs;
    final q = _searchQuery.toLowerCase();
    return _faqs
        .where((faq) =>
            faq['q']!.toLowerCase().contains(q) ||
            faq['a']!.toLowerCase().contains(q))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundCanvas,
      appBar: AppBar(
        title: const Text('Help Center'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        children: [
          // ── Search bar ───────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() {
                _searchQuery = v;
                _expandedFaqIndex = null;
              }),
              decoration: InputDecoration(
                hintText: 'Search for help…',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon:
                    const Icon(LucideIcons.search, color: AppTheme.textMuted),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(LucideIcons.x,
                            color: AppTheme.textMuted, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ── Topic grid (hidden when searching) ──────────────────────
          if (_searchQuery.isEmpty) ...[
            const _SectionLabel('BROWSE BY TOPIC'),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: _topics
                  .map((t) => _TopicCard(
                        icon: t['icon'] as IconData,
                        label: t['label'] as String,
                        color: t['color'] as Color,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 28),

            // ── Contact options ──────────────────────────────────────
            const _SectionLabel('CONTACT US'),
            const SizedBox(height: 12),
            _ContactTile(
              icon: LucideIcons.messageCircle,
              label: 'Live Chat',
              subtitle: 'Avg. reply in 2 mins',
              color: const Color(0xFF22C55E),
              onTap: () => _showChatComingSoon(context),
            ),
            const SizedBox(height: 10),
            _ContactTile(
              icon: LucideIcons.mail,
              label: 'Email Support',
              subtitle: 'support@tiffin.co',
              color: const Color(0xFF6366F1),
              onTap: () {},
            ),
            const SizedBox(height: 10),
            _ContactTile(
              icon: LucideIcons.phone,
              label: 'Call Us',
              subtitle: '+603-1234 5678 (9am–6pm)',
              color: const Color(0xFF0EA5E9),
              onTap: () {},
            ),
            const SizedBox(height: 28),
          ],

          // ── FAQ accordion ────────────────────────────────────────────
          const _SectionLabel('FREQUENTLY ASKED'),
          const SizedBox(height: 12),
          if (_filteredFaqs.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  const Icon(LucideIcons.searchX,
                      size: 40, color: AppTheme.textMuted),
                  const SizedBox(height: 12),
                  Text(
                    'No results for "$_searchQuery"',
                    style: const TextStyle(
                        color: AppTheme.textMuted, fontSize: 14),
                  ),
                ],
              ),
            )
          else
            ...List.generate(_filteredFaqs.length, (i) {
              final faq = _filteredFaqs[i];
              final isOpen = _expandedFaqIndex == i;
              return _FaqTile(
                question: faq['q']!,
                answer: faq['a']!,
                isOpen: isOpen,
                onTap: () =>
                    setState(() => _expandedFaqIndex = isOpen ? null : i),
              );
            }),
        ],
      ),
    );
  }

  void _showChatComingSoon(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.messageCircle,
                  color: Color(0xFF22C55E), size: 36),
            ),
            const SizedBox(height: 16),
            const Text(
              'Live Chat',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textDark),
            ),
            const SizedBox(height: 8),
            const Text(
              'Our support team is online.\nAverage reply time: 2 minutes.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22C55E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Start Chat',
                    style: TextStyle(
                        fontWeight: FontWeight.w900, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Reusable widgets ──────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.4,
        color: AppTheme.textMuted,
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _TopicCard(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: AppTheme.textDark,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ContactTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: AppTheme.textDark)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 12, color: AppTheme.textMuted)),
                ],
              ),
            ),
            const Icon(LucideIcons.chevronRight,
                size: 18, color: AppTheme.textMuted),
          ],
        ),
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  final String question;
  final String answer;
  final bool isOpen;
  final VoidCallback onTap;

  const _FaqTile({
    required this.question,
    required this.answer,
    required this.isOpen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isOpen
              ? AppTheme.primaryBrand.withValues(alpha: 0.4)
              : Colors.grey.shade200,
          width: isOpen ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isOpen ? 0.05 : 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      question,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isOpen
                            ? AppTheme.primaryBrand
                            : AppTheme.textDark,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    turns: isOpen ? 0.5 : 0,
                    child: Icon(
                      LucideIcons.chevronDown,
                      size: 18,
                      color:
                          isOpen ? AppTheme.primaryBrand : AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isOpen)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textMuted,
                  height: 1.6,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
