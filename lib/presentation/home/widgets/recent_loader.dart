import 'package:flutter/material.dart';
import 'package:studymind/theme/colors.dart';

class RecentLoader extends StatefulWidget {
  final double height;
  const RecentLoader({super.key, this.height = 90});

  @override
  State<RecentLoader> createState() => RecentLoaderState();
}

class RecentLoaderState extends State<RecentLoader> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);

    animation = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInOut));

    // Start the animation and repeat it
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                colorPalette.content.withAlpha(13),
                colorPalette.content.withAlpha(25),
                colorPalette.content.withAlpha(13),
              ],
              stops: const [0.1, 0.25, 0.5],
              begin: Alignment(animation.value - 1, -0.5),
              end: Alignment(animation.value + 1, 0.5),
              tileMode: TileMode.clamp,
            ),
          ),
        );
      },
    );
  }
}
