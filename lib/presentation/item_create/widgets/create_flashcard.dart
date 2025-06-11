import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/item_create.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_button.dart';
import 'package:studymind/widgets/custom_icon.dart';
import 'package:studymind/widgets/custom_text_field.dart';
import 'package:studymind/widgets/library/flashcard_preview.dart';

class CreateFlashcard extends StatefulWidget {
  const CreateFlashcard({super.key});

  @override
  State<CreateFlashcard> createState() => CreateFlashcardState();
}

class CreateFlashcardState extends State<CreateFlashcard> {
  final ItemCreateController itemCreateController = Get.find<ItemCreateController>();

  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  final PageController pageController = PageController();

  int selectedIndex = 0;

  void nextPage() {
    pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void prevPage() {
    pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void handleAddFlashcard() {
    if (questionController.text.isNotEmpty && answerController.text.isNotEmpty) {
      // Jump to the last page
      if (itemCreateController.flashcards.isNotEmpty) {
        pageController.jumpToPage(itemCreateController.flashcards.length);
        setState(() => selectedIndex = itemCreateController.flashcards.length);
      }

      // Add flashcard
      itemCreateController.flashcards.add(Flashcard(question: questionController.text, answer: answerController.text));
      questionController.clear();
      answerController.clear();
    }
  }

  @override
  void dispose() {
    itemCreateController.flashcards.clear();
    questionController.dispose();
    answerController.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Flashcard Content', style: textTheme.labelLarge),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorPalette.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(controller: questionController, label: 'Question'),
              const SizedBox(height: 16),
              CustomTextField(controller: answerController, label: 'Answer', maxLines: 3),
            ],
          ),
        ),
        const SizedBox(height: 16),
        CustomButton(text: "Add Flashcard", prefixIcon: 'add', onPressed: () => handleAddFlashcard()),
        Obx(() {
          final flashcards = itemCreateController.flashcards;

          if (flashcards.isEmpty) {
            return Column(
              children: [
                const SizedBox(height: 16),
                Text('Preview', style: textTheme.titleMedium),
                const SizedBox(height: 8),
              ],
            );
          } else {
            return Column(
              children: [
                const SizedBox(height: 14),
                Row(
                  children: [
                    Text('Preview (${selectedIndex + 1}/${flashcards.length})', style: textTheme.titleMedium),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(color: colorPalette.warning, shape: BoxShape.circle),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            questionController.text = flashcards[selectedIndex].question;
                            answerController.text = flashcards[selectedIndex].answer;

                            flashcards.removeAt(selectedIndex);
                            if (selectedIndex > 0) selectedIndex--;
                          });
                        },
                        borderRadius: BorderRadius.circular(14), // Match the circular shape
                        child: Padding(padding: const EdgeInsets.all(6), child: CustomIcon(icon: 'fileEdit', size: 16)),
                      ),
                    ),
                    SizedBox(width: 4),
                    Container(
                      decoration: BoxDecoration(color: colorPalette.error, shape: BoxShape.circle),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            flashcards.removeAt(selectedIndex);
                            if (selectedIndex > 0) selectedIndex--;
                          });
                        },
                        borderRadius: BorderRadius.circular(14), // Match the circular shape
                        child: Padding(padding: const EdgeInsets.all(6), child: CustomIcon(icon: 'cancel', size: 16)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
              ],
            );
          }
        }),
        Obx(() {
          final flashcards = itemCreateController.flashcards;

          if (flashcards.isEmpty) {
            return SizedBox(
              height: 224,
              child: FlashcardPreview(flashcard: Flashcard(question: 'Question goes here', answer: 'Answer goes here')),
            );
          } else {
            return SizedBox(
              height: 224,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: pageController,
                    onPageChanged: (index) => setState(() => selectedIndex = index),
                    itemCount: flashcards.length,
                    itemBuilder: (context, index) {
                      final flashcard = flashcards[index];
                      return FlashcardPreview(flashcard: flashcard);
                    },
                  ),
                  if (flashcards.length > 1) ...[
                    Positioned(
                      left: 8.5,
                      top: 8.5,
                      child: IconButton.filled(
                        onPressed: selectedIndex > 0 ? prevPage : null,
                        icon: CustomIcon(icon: 'arrowLeft', size: 24),
                        color: selectedIndex > 0 ? colorPalette.white : colorPalette.contentDim,
                      ),
                    ),
                    Positioned(
                      right: 8.5,
                      top: 8.5,
                      child: IconButton.filled(
                        onPressed: selectedIndex < flashcards.length - 1 ? nextPage : null,
                        icon: CustomIcon(
                          icon: 'arrowRight',
                          size: 24,
                          color: selectedIndex < flashcards.length - 1 ? colorPalette.white : colorPalette.contentDim,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }
        }),
      ],
    );
  }
}
