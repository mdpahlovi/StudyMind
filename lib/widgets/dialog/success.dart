import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/theme/colors.dart';

class SuccessDialog extends StatefulWidget {
  final String message;
  final String confirmText;
  final void Function()? onConfirmed;
  const SuccessDialog({super.key, this.message = '', this.confirmText = 'Confirm', this.onConfirmed});

  @override
  SuccessDialogState createState() => SuccessDialogState();
}

class SuccessDialogState extends State<SuccessDialog> with TickerProviderStateMixin {
  late AnimationController scaleController;
  late AnimationController pathController;
  late AnimationController confettiController;
  late Animation<double> scaleAnimation;
  late Animation<double> pathAnimation;
  late Animation<double> confettiAnimation;

  @override
  void initState() {
    super.initState();
    scaleController = AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    pathController = AnimationController(duration: Duration(milliseconds: 800), vsync: this);
    confettiController = AnimationController(duration: Duration(milliseconds: 2000), vsync: this);

    scaleAnimation = CurvedAnimation(parent: scaleController, curve: Curves.elasticOut);

    pathAnimation = CurvedAnimation(parent: pathController, curve: Curves.easeInOut);

    confettiAnimation = CurvedAnimation(parent: confettiController, curve: Curves.easeOut);

    scaleController.forward();
    Future.delayed(Duration(milliseconds: 200), () {
      pathController.forward();
    });
    Future.delayed(Duration(milliseconds: 600), () {
      confettiController.forward();
    });
  }

  @override
  void dispose() {
    scaleController.dispose();
    pathController.dispose();
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Dialog(
      child: ScaleTransition(
        scale: scaleAnimation,
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(color: colorPalette.surface, borderRadius: BorderRadius.circular(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: confettiAnimation,
                    builder: (context, child) {
                      return CustomPaint(painter: ConfettiPainter(confettiAnimation.value), size: Size(120, 120));
                    },
                  ),
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: AnimatedBuilder(
                      animation: pathAnimation,
                      builder: (context, child) {
                        return CustomPaint(painter: CheckmarkPainter(pathAnimation.value), size: Size(80, 80));
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Text('Success!', style: textTheme.headlineLarge),
              SizedBox(height: 12),
              Text(
                widget.message != '' ? widget.message : 'Your action has been completed successfully.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium,
              ),
              SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorPalette.content,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Get.back(),
                      child: Text('Cancel', style: textTheme.titleMedium?.copyWith(color: colorPalette.background)),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorPalette.success,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                      onPressed: () {
                        Get.back();
                        if (widget.onConfirmed != null) widget.onConfirmed!();
                      },
                      child: Text('Confirm', style: textTheme.titleMedium),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CheckmarkPainter extends CustomPainter {
  final double progress;

  CheckmarkPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Color(0xFF38A169)
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    // Draw circle
    canvas.drawCircle(center, radius, paint);

    if (progress > 0.3) {
      final checkProgress = ((progress - 0.3) / 0.7).clamp(0.0, 1.0);

      // Checkmark path
      final path = Path();
      final p1 = Offset(center.dx - 12, center.dy);
      final p2 = Offset(center.dx - 4, center.dy + 8);
      final p3 = Offset(center.dx + 12, center.dy - 8);

      path.moveTo(p1.dx, p1.dy);

      if (checkProgress <= 0.5) {
        // First part of checkmark
        final t = checkProgress * 2;
        final currentX = p1.dx + (p2.dx - p1.dx) * t;
        final currentY = p1.dy + (p2.dy - p1.dy) * t;
        path.lineTo(currentX, currentY);
      } else {
        // Complete first part and animate second part
        path.lineTo(p2.dx, p2.dy);
        final t = (checkProgress - 0.5) * 2;
        final currentX = p2.dx + (p3.dx - p2.dx) * t;
        final currentY = p2.dy + (p3.dy - p2.dy) * t;
        path.lineTo(currentX, currentY);
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class ConfettiPainter extends CustomPainter {
  final double progress;

  ConfettiPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;

    final colors = [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFF38A169), Color(0xFFF56565), Color(0xFFECC94B)];

    for (int i = 0; i < 12; i++) {
      final angle = (i * 30) * (3.14159 / 180);
      final distance = 60 * progress;
      final x = size.width / 2 + distance * cos(angle);
      final y = size.height / 2 + distance * sin(angle);

      final paint =
          Paint()
            ..color = colors[i % colors.length].withValues(alpha: 1 - progress)
            ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), 3, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
