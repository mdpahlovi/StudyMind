import 'package:flutter/material.dart';
import 'package:studymind/theme/colors.dart';

class ItemLoader extends StatelessWidget {
  const ItemLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final itemWidth = (size.width - 16 * 2 - 12) / 2;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: List.generate(8, (index) => SizedBox(width: itemWidth, height: 160, child: const ItemLoaderCard())),
      ),
    );
  }
}

class ItemLoaderCard extends StatefulWidget {
  const ItemLoaderCard({super.key});

  @override
  State<ItemLoaderCard> createState() => ItemLoaderCardState();
}

class ItemLoaderCardState extends State<ItemLoaderCard> with SingleTickerProviderStateMixin {
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
      animation: animation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
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
