import 'package:flutter/material.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_text_field.dart';

class CreateFlashcard extends StatefulWidget {
  const CreateFlashcard({super.key});

  @override
  State<CreateFlashcard> createState() => CreateFlashcardState();
}

class CreateFlashcardState extends State<CreateFlashcard> {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  String creationMethod = 'manual';
  bool isFlipped = false;

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Create Flashcard', style: textTheme.labelLarge),
        const SizedBox(height: 8),
        if (creationMethod == 'manual') ...[
          // Manual Creation
          // Flashcard Preview
          GestureDetector(
            onTap: () => setState(() => isFlipped = !isFlipped),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [colorPalette.primary, colorPalette.secondary],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: colorPalette.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(isFlipped ? 'Answer' : 'Question', style: textTheme.labelMedium),
                    Expanded(
                      child: Center(
                        child: Text(
                          isFlipped
                              ? (answerController.text.isEmpty ? 'Answer will appear here' : answerController.text)
                              : (questionController.text.isEmpty
                                  ? 'Question will appear here'
                                  : questionController.text),
                          style: textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Text('Tap to flip', style: textTheme.labelMedium),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Question Input
          CustomTextField(controller: questionController, label: 'Question'),
          const SizedBox(height: 12),
          // Answer Input
          CustomTextField(controller: answerController, label: 'Answer', maxLines: 2),
        ],
      ],
    );
  }
}
