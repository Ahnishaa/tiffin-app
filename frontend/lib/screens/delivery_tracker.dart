import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';

class DeliveryTrackerScreen extends StatelessWidget {
  const DeliveryTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundCanvas,
      appBar: AppBar(
        title: const Text('Live Order'),
        elevation: 0,
        backgroundColor: Colors.white,
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
            // Beautiful Vector Route Painter
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.white,
              child: CustomPaint(
                painter: DeliveryRoutePainter(),
              ),
            ),
            
            // Prominent Lalamove Delivery Partner Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Transform.translate(
                offset: const Offset(0, -30),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Lalamove Delivery Partner',
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const Text(
                            'Arriving in 15 mins',
                            style: TextStyle(
                              color: AppTheme.primaryBrand,
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppTheme.backgroundCanvas,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: const Icon(LucideIcons.user, color: AppTheme.textMuted),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ahmad',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18,
                                    color: AppTheme.textDark,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'BND 1234 • Honda EX5',
                                  style: TextStyle(
                                    color: AppTheme.textMuted,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBrand,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: AppTheme.primaryBrand.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(LucideIcons.phone, color: Colors.white, size: 20),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Modern Stepper Tracker
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: AppTheme.containerShadow,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order Milestones',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildStepperItem('Food Cooked & Packed', true, false, false),
                    _buildStepperLine(true),
                    _buildStepperItem('Dispatched via Lalamove', true, false, false),
                    _buildStepperLine(true),
                    _buildStepperItem('Arriving Soon', false, true, false),
                    _buildStepperLine(false),
                    _buildStepperItem('Swap & Drop Tiffin Pickup', false, false, true),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Zero-Waste Impact Badge (Glassmorphism inspired)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBrand.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.primaryBrand.withValues(alpha: 0.2)),
                ),
                child: const Row(
                  children: [
                    Text('🌿', style: TextStyle(fontSize: 24)),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'You saved 18 plastic containers this month.',
                        style: TextStyle(
                          color: AppTheme.primaryBrand,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
        ],
      ),
    );
  }

  Widget _buildStepperItem(String title, bool isCompleted, bool isActive, bool isPending) {
    Color iconColor;
    Color bgColor;
    IconData icon;

    if (isCompleted) {
      iconColor = Colors.white;
      bgColor = AppTheme.primaryBrand;
      icon = LucideIcons.check;
    } else if (isActive) {
      iconColor = AppTheme.primaryBrand;
      bgColor = AppTheme.primaryBrand.withValues(alpha: 0.1);
      icon = LucideIcons.bike;
    } else {
      iconColor = AppTheme.textMuted;
      bgColor = AppTheme.backgroundCanvas;
      icon = LucideIcons.clock;
    }

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: isCompleted || isActive ? AppTheme.primaryBrand : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 16),
        Text(
          title,
          style: TextStyle(
            fontWeight: isActive || isCompleted ? FontWeight.bold : FontWeight.w500,
            color: isActive || isCompleted ? AppTheme.textDark : AppTheme.textMuted,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildStepperLine(bool isActive) {
    return Container(
      margin: const EdgeInsets.only(left: 17, top: 4, bottom: 4),
      width: 2,
      height: 24,
      color: isActive ? AppTheme.primaryBrand : Colors.grey.shade200,
    );
  }
}

class DeliveryRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Beautiful fake map route drawing
    final paint = Paint()
      ..color = AppTheme.primaryBrand.withValues(alpha: 0.2)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(40, 100);
    path.quadraticBezierTo(size.width * 0.4, 40, size.width * 0.6, 120);
    path.quadraticBezierTo(size.width * 0.8, 160, size.width - 40, 80);

    canvas.drawPath(path, paint);
    
    // Draw Nodes
    _drawNode(canvas, const Offset(40, 100), true); // Kitchen
    _drawNode(canvas, Offset(size.width * 0.6, 120), true, isPulsing: true); // Bike
    _drawNode(canvas, Offset(size.width - 40, 80), false); // Drop
  }

  void _drawNode(Canvas canvas, Offset offset, bool isActive, {bool isPulsing = false}) {
    if (isPulsing) {
      canvas.drawCircle(
        offset,
        16,
        Paint()..color = AppTheme.primaryBrand.withValues(alpha: 0.2),
      );
    }
    
    canvas.drawCircle(
      offset,
      8,
      Paint()..color = isActive ? AppTheme.primaryBrand : Colors.grey.shade300,
    );
    canvas.drawCircle(
      offset,
      8,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
