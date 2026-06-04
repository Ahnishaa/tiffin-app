import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';

/// Payment method types — matches what Grab Malaysia uses
enum PaymentType { card, fpx, tng, grabpay }

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  PaymentType _selected = PaymentType.card;

  // Saved cards
  final List<Map<String, dynamic>> _cards = [
    {
      'last4': '4242',
      'brand': 'Visa',
      'expiry': '12/27',
      'color': const LinearGradient(
        colors: [Color(0xFF1A1F71), Color(0xFF00B4D8)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'last4': '8765',
      'brand': 'Mastercard',
      'expiry': '09/26',
      'color': const LinearGradient(
        colors: [Color(0xFFEB001B), Color(0xFFF79E1B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundCanvas,
      appBar: AppBar(
        title: const Text('Payment Methods'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- E-Wallet Section ---
            _sectionLabel('E-WALLETS'),
            const SizedBox(height: 10),
            _EWalletTile(
              type: PaymentType.tng,
              label: 'Touch \'n Go eWallet',
              subtitle: 'Balance: RM 38.50',
              logoWidget: _TngLogo(),
              isSelected: _selected == PaymentType.tng,
              onTap: () => setState(() => _selected = PaymentType.tng),
            ),
            const SizedBox(height: 10),
            _EWalletTile(
              type: PaymentType.grabpay,
              label: 'GrabPay',
              subtitle: 'Balance: RM 12.00',
              logoWidget: _GrabPayLogo(),
              isSelected: _selected == PaymentType.grabpay,
              onTap: () => setState(() => _selected = PaymentType.grabpay),
            ),
            const SizedBox(height: 24),

            // --- FPX Online Banking ---
            _sectionLabel('ONLINE BANKING (FPX)'),
            const SizedBox(height: 10),
            _EWalletTile(
              type: PaymentType.fpx,
              label: 'FPX Online Banking',
              subtitle: 'Maybank, CIMB, RHB, and more',
              logoWidget: _FpxLogo(),
              isSelected: _selected == PaymentType.fpx,
              onTap: () => setState(() => _selected = PaymentType.fpx),
            ),
            const SizedBox(height: 24),

            // --- Credit / Debit Cards ---
            _sectionLabel('CREDIT / DEBIT CARDS'),
            const SizedBox(height: 14),

            // Horizontal card carousel
            SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _cards.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  if (index == _cards.length) {
                    return _AddCardSlot(
                      onTap: () => _showAddCardSheet(context),
                    );
                  }
                  final card = _cards[index];
                  return GestureDetector(
                    onTap: () => setState(() => _selected = PaymentType.card),
                    child: _CardWidget(
                      last4: card['last4'] as String,
                      brand: card['brand'] as String,
                      expiry: card['expiry'] as String,
                      gradient: card['color'] as LinearGradient,
                      isSelected: _selected == PaymentType.card,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),

            // --- Confirm Button ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          '${_paymentLabel(_selected)} set as preferred payment'),
                      backgroundColor: AppTheme.primaryBrand,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBrand,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Confirm Payment Method',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _paymentLabel(PaymentType type) {
    switch (type) {
      case PaymentType.card:
        return 'Card';
      case PaymentType.fpx:
        return 'FPX';
      case PaymentType.tng:
        return 'Touch \'n Go';
      case PaymentType.grabpay:
        return 'GrabPay';
    }
  }

  Widget _sectionLabel(String text) {
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

  void _showAddCardSheet(BuildContext context) {
    final cardNoController = TextEditingController();
    final expiryController = TextEditingController();
    final cvvController = TextEditingController();
    final nameController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
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
                const SizedBox(height: 20),
                const Text(
                  'Add New Card',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 20),
                _CardTextField(
                    controller: cardNoController,
                    label: 'CARD NUMBER',
                    hint: '0000 0000 0000 0000',
                    keyboardType: TextInputType.number),
                const SizedBox(height: 14),
                _CardTextField(
                    controller: nameController,
                    label: 'CARDHOLDER NAME',
                    hint: 'Hannah Lee'),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _CardTextField(
                          controller: expiryController,
                          label: 'EXPIRY',
                          hint: 'MM/YY',
                          keyboardType: TextInputType.number),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _CardTextField(
                          controller: cvvController,
                          label: 'CVV',
                          hint: '•••',
                          keyboardType: TextInputType.number,
                          obscure: true),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBrand,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Add Card',
                      style: TextStyle(
                          fontWeight: FontWeight.w900, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Reusable widgets ──────────────────────────────────────────────────────────

class _EWalletTile extends StatelessWidget {
  final PaymentType type;
  final String label;
  final String subtitle;
  final Widget logoWidget;
  final bool isSelected;
  final VoidCallback onTap;

  const _EWalletTile({
    required this.type,
    required this.label,
    required this.subtitle,
    required this.logoWidget,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryBrand
                : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isSelected ? 0.06 : 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(width: 48, height: 36, child: logoWidget),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppTheme.primaryBrand : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primaryBrand
                      : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 13)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _CardWidget extends StatelessWidget {
  final String last4;
  final String brand;
  final String expiry;
  final LinearGradient gradient;
  final bool isSelected;

  const _CardWidget({
    required this.last4,
    required this.brand,
    required this.expiry,
    required this.gradient,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 240,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        border: isSelected
            ? Border.all(color: Colors.white, width: 3)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isSelected ? 0.25 : 0.12),
            blurRadius: isSelected ? 20 : 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                brand,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isSelected)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Selected',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w900),
                  ),
                ),
            ],
          ),
          // Chip icon
          Container(
            width: 38,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.amber.shade400.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '•••• •••• •••• $last4',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Expires $expiry',
                style: const TextStyle(color: Colors.white60, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddCardSlot extends StatelessWidget {
  final VoidCallback onTap;
  const _AddCardSlot({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: AppTheme.primaryBrand.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.primaryBrand.withValues(alpha: 0.3),
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.primaryBrand.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: AppTheme.primaryBrand, size: 26),
            ),
            const SizedBox(height: 10),
            const Text(
              'Add Card',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: AppTheme.primaryBrand,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType? keyboardType;
  final bool obscure;

  const _CardTextField({
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: AppTheme.textMuted,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppTheme.primaryBrand, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Logo widgets (self-contained, no network needed) ─────────────────────────

class _TngLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF00A3E0),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: const Text(
        'TnG',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _GrabPayLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF00B14F),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: const Text(
        'Grab',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _FpxLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF003087),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: const Text(
        'FPX',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 13,
        ),
      ),
    );
  }
}
