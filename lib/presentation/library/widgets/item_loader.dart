import 'package:flutter/material.dart';
import 'package:studymind/theme/colors.dart';

class ItemLoader extends StatefulWidget {
  final bool isSearch;
  const ItemLoader({super.key, this.isSearch = false});

  @override
  State<ItemLoader> createState() => ItemLoaderState();
}

class ItemLoaderState extends State<ItemLoader> with SingleTickerProviderStateMixin {
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

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...widget.isSearch
            ? [
              TextField(decoration: InputDecoration(hintText: 'Search in library...', prefixIcon: Icon(Icons.search))),
              const SizedBox(height: 16),
            ]
            : [],
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemCount: 12,
          itemBuilder:
              (context, index) => AnimatedBuilder(
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
              ),
        ),
      ],
    );
  }
}
