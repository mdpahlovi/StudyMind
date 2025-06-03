import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studymind/controllers/item_create.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon.dart';

class FlashcardPreview extends StatefulWidget {
  final Flashcard flashcard;
  const FlashcardPreview({super.key, required this.flashcard});

  @override
  State<FlashcardPreview> createState() => FlashcardPreviewState();
}

class FlashcardPreviewState extends State<FlashcardPreview> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> frontRotation;
  late Animation<double> backRotation;
  bool isFrontVisible = true;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));

    frontRotation = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.0, end: pi / 2).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50.0,
      ),
      TweenSequenceItem<double>(tween: ConstantTween<double>(pi / 2), weight: 50.0),
    ]).animate(animationController);

    backRotation = TweenSequence<double>([
      TweenSequenceItem<double>(tween: ConstantTween<double>(pi / 2), weight: 50.0),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: -pi / 2, end: 0.0).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50.0,
      ),
    ]).animate(animationController);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void flipCard() {
    HapticFeedback.mediumImpact();
    if (isFrontVisible) {
      animationController.forward();
    } else {
      animationController.reverse();
    }

    setState(() => isFrontVisible = !isFrontVisible);
  }

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;

    return GestureDetector(
      onTap: flipCard,
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Stack(
            children: [
              Transform(
                transform:
                    Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(frontRotation.value),
                alignment: Alignment.center,
                child:
                    frontRotation.value < pi / 4
                        ? buildCardSide(
                          context: context,
                          title: 'Question',
                          content: widget.flashcard.question,
                          color: colorPalette.primary,
                        )
                        : const SizedBox(),
              ),
              Transform(
                transform:
                    Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(backRotation.value),
                alignment: Alignment.center,
                child:
                    backRotation.value > -pi / 4
                        ? buildCardSide(
                          context: context,
                          title: 'Answer',
                          content: widget.flashcard.answer,
                          color: colorPalette.tertiary,
                        )
                        : const SizedBox(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildCardSide({
    required BuildContext context,
    required String title,
    required String content,
    required Color color,
  }) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(50),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(100)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withAlpha(50),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withAlpha(100)),
            ),
            child: Text(title, style: textTheme.labelMedium?.copyWith(color: color)),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(content, style: textTheme.bodyMedium, textAlign: TextAlign.center),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CustomIcon(icon: 'tap', size: 16),
              const SizedBox(width: 4),
              Text('Tap to flip', style: textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}
