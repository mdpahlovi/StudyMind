import 'dart:math';

import 'package:flutter/material.dart';
import 'package:studymind/controllers/item_create.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon.dart';
import 'package:studymind/widgets/library/flashcard_preview.dart';

class ViewFlashcard extends StatefulWidget {
  final LibraryItem item;
  const ViewFlashcard({super.key, required this.item});

  @override
  State<ViewFlashcard> createState() => ViewFlashcardState();
}

class ViewFlashcardState extends State<ViewFlashcard> {
  final PageController pageController = PageController();
  int selectedIndex = 0;

  void nextPage() {
    pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void prevPage() {
    pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    final List<Flashcard> flashcards = [];
    for (var flashcard in widget.item.metadata?['cards'] ?? []) {
      flashcards.add(Flashcard.fromJson(flashcard));
    }

    return Column(
      children: [
        Row(
          children: [
            IconButton.filled(
              onPressed: selectedIndex > 0 ? prevPage : null,
              icon: CustomIcon(icon: 'arrowLeft', size: 24),
              color: selectedIndex > 0 ? colorPalette.white : colorPalette.contentDim,
            ),
            Expanded(
              child: Text(
                'Card (${selectedIndex + 1}/${flashcards.length})',
                style: textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
            IconButton.filled(
              onPressed: selectedIndex < flashcards.length - 1 ? nextPage : null,
              icon: CustomIcon(
                icon: 'arrowRight',
                size: 24,
                color: selectedIndex < flashcards.length - 1 ? colorPalette.white : colorPalette.contentDim,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AspectRatio(
          aspectRatio: 1 / sqrt(2),
          child: PageView.builder(
            controller: pageController,
            onPageChanged: (index) => setState(() => selectedIndex = index),
            itemCount: flashcards.length,
            itemBuilder: (context, index) {
              final flashcard = flashcards[index];
              return FlashcardPreview(flashcard: flashcard);
            },
          ),
        ),
      ],
    );
  }
}
