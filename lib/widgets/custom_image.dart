import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:studymind/theme/colors.dart';

class CustomImage extends StatefulWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final bool isUser;

  /// Optional widget to show when the image fails to load.
  /// If null, a default asset image is shown.
  final Widget? errorWidget;

  const CustomImage({
    super.key,
    required this.imageUrl,
    this.width = 60,
    this.height = 60,
    this.fit = BoxFit.cover,
    this.isUser = false,
    this.errorWidget,
  });

  @override
  State<CustomImage> createState() => CustomImageState();
}

class CustomImageState extends State<CustomImage> with SingleTickerProviderStateMixin {
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

    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,

      // Use caller-supplied widget if provided, else fallback asset.
      errorWidget: (context, url, error) =>
          widget.errorWidget ??
          Image.asset(
            widget.isUser ? 'assets/images/profile.png' : 'assets/images/broken-image.jpg',
            fit: widget.fit,
            width: widget.width,
            height: widget.height,
          ),

      placeholder: (context, url) => AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Container(
            width: widget.width,
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
      ),
    );
  }
}
