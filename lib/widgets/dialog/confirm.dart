import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/theme/colors.dart';

class ConfirmDialog extends StatefulWidget {
  final void Function()? onConfirmed;
  const ConfirmDialog({super.key, this.onConfirmed});

  @override
  ConfirmDialogState createState() => ConfirmDialogState();
}

class ConfirmDialogState extends State<ConfirmDialog> with TickerProviderStateMixin {
  late AnimationController scaleController;
  late AnimationController pathController;
  late Animation<double> scaleAnimation;
  late Animation<double> pathAnimation;

  @override
  void initState() {
    super.initState();
    scaleController = AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    pathController = AnimationController(duration: Duration(milliseconds: 1500), vsync: this);

    scaleAnimation = CurvedAnimation(parent: scaleController, curve: Curves.elasticOut);

    pathAnimation = CurvedAnimation(parent: pathController, curve: Curves.easeInOut);

    scaleController.forward();
    pathController.forward();
  }

  @override
  void dispose() {
    scaleController.dispose();
    pathController.dispose();
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
              SizedBox(
                width: 80,
                height: 80,
                child: AnimatedBuilder(
                  animation: pathAnimation,
                  builder: (context, child) {
                    return CustomPaint(painter: WarningIconPainter(pathAnimation.value), size: Size(80, 80));
                  },
                ),
              ),
              SizedBox(height: 24),
              Text('Are You Sure?', style: textTheme.headlineLarge),
              SizedBox(height: 12),
              Text(
                'This action cannot be undone. Please confirm that you want to proceed.',
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

class WarningIconPainter extends CustomPainter {
  final ColorPalette colorPalette = AppColors().palette;

  final double progress;

  WarningIconPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = colorPalette.warning
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    // Draw circle
    canvas.drawCircle(center, radius, paint);

    if (progress > 0.3) {
      final exclamationProgress = ((progress - 0.3) / 0.7).clamp(0.0, 1.0);

      // Draw exclamation line
      final lineStart = Offset(center.dx, center.dy - 15);
      final lineEnd = Offset(center.dx, center.dy + 5);
      final currentLineEnd = Offset(lineStart.dx, lineStart.dy + (lineEnd.dy - lineStart.dy) * exclamationProgress);

      canvas.drawLine(lineStart, currentLineEnd, paint);

      // Draw dot
      if (exclamationProgress > 0.5) {
        final dotPaint =
            Paint()
              ..color = colorPalette.warning
              ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(center.dx, center.dy + 12), 2, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
