import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/item_create.dart';
import 'package:studymind/core/logger.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_button.dart';
import 'package:studymind/widgets/custom_text_field.dart';
import 'package:studymind/widgets/library/flashcard_preview.dart';

class CreateFlashcard extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const CreateFlashcard({super.key, required this.formKey});

  @override
  State<CreateFlashcard> createState() => CreateFlashcardState();
}

class CreateFlashcardState extends State<CreateFlashcard> {
  final ItemCreateController itemCreateController = Get.find<ItemCreateController>();

  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();

  void handleAddFlashcard() {
    if (widget.formKey.currentState!.validate()) {
      itemCreateController.flashcards.add(Flashcard(question: questionController.text, answer: answerController.text));
      questionController.clear();
      answerController.clear();

      logger.t(itemCreateController.flashcards);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Flashcard Content *', style: textTheme.labelLarge),
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
        const SizedBox(height: 16),
        Text('Preview', style: textTheme.labelLarge),
        const SizedBox(height: 8),
        Obx(() {
          final flashcards = itemCreateController.flashcards;

          if (flashcards.isEmpty) {
            return SizedBox(
              height: 224,
              child: FlashcardPreview(flashcard: Flashcard(question: 'Question goes here', answer: 'Answer goes here')),
            );
          }

          return SizedBox(
            height: 224,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: flashcards.length,
              itemBuilder: (context, index) {
                final flashcard = flashcards[index];
                return SizedBox(width: size.width - 32, child: FlashcardPreview(flashcard: flashcard));
              },
            ),
          );
        }),
      ],
    );
  }
}
