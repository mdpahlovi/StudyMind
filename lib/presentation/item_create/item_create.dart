import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/item_create.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/core/validators.dart';
import 'package:studymind/presentation/item_create/widgets/create_audio.dart';
import 'package:studymind/presentation/item_create/widgets/create_document.dart';
import 'package:studymind/presentation/item_create/widgets/create_flashcard.dart';
import 'package:studymind/presentation/item_create/widgets/create_folder.dart';
import 'package:studymind/presentation/item_create/widgets/create_image.dart';
import 'package:studymind/presentation/item_create/widgets/create_note.dart';
import 'package:studymind/presentation/item_create/widgets/create_video.dart';
import 'package:studymind/presentation/item_create/widgets/parent_folder_selector.dart';
import 'package:studymind/widgets/custom_back_button.dart';
import 'package:studymind/widgets/custom_button.dart';
import 'package:studymind/widgets/custom_text_field.dart';
import 'package:studymind/widgets/dialog/confirm.dart';

class ItemCreateScreen extends StatefulWidget {
  const ItemCreateScreen({super.key});

  @override
  State<ItemCreateScreen> createState() => ItemCreateScreenState();
}

class ItemCreateScreenState extends State<ItemCreateScreen> {
  final ItemCreateController itemCreateController = Get.find<ItemCreateController>();

  final ItemType type = ItemType.values.firstWhere((e) => e.toString().split('.').last == Get.parameters['type']);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> handleCreate() async {
    final String name = nameController.text.trim();
    final String description = descriptionController.text.trim();

    itemCreateController.createLibraryItem(type, name, description);
    nameController.clear();
    descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(leading: CustomBackButton(icon: 'cancel'), title: Text('Create ${type.name.capitalize}')),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name Input Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name', style: textTheme.labelLarge),
                    SizedBox(height: 8),
                    CustomTextField(
                      controller: nameController,
                      placeholder: 'Enter Name',
                      validator: Validators.validateName,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Item-specific content
                buildItemCreateWidget(type),
                const SizedBox(height: 16),
                // Parent Folder Selector
                ParentFolderSelector(),
                const SizedBox(height: 16),
                // Description Input Section
                type != ItemType.folder
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Description', style: textTheme.labelLarge),
                        SizedBox(height: 8),
                        CustomTextField(
                          controller: descriptionController,
                          placeholder: 'Add a brief description (optional)',
                          maxLines: 3,
                          maxLength: 200,
                        ),
                      ],
                    )
                    : SizedBox(),
                type != ItemType.folder ? const SizedBox(height: 16) : SizedBox(),
                // Create Button
                const SizedBox(height: 8),
                Obx(
                  () => CustomButton(
                    text: 'Create ${type.name.capitalize}',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Get.dialog(ConfirmDialog(onConfirmed: () => handleCreate()));
                      }
                    },
                    isLoading: itemCreateController.isCreating.value,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildItemCreateWidget(ItemType type) {
  switch (type) {
    case ItemType.folder:
      return CreateFolder();
    case ItemType.note:
      return CreateNote();
    case ItemType.document:
      return CreateDocument();
    case ItemType.flashcard:
      return CreateFlashcard();
    case ItemType.audio:
      return CreateAudio();
    case ItemType.video:
      return CreateVideo();
    case ItemType.image:
      return CreateImage();
  }
}
