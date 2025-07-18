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
import 'package:studymind/presentation/item_create/widgets/note_toolbar.dart';
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

  final ItemType type = ItemType.values.byName(Get.parameters['type']!);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final FocusNode focusNode = FocusNode();
  bool hasFocused = false;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);
  }

  void onFocusChange() {
    setState(() => hasFocused = focusNode.hasFocus);
  }

  @override
  void dispose() {
    itemCreateController.nameController.clear();
    itemCreateController.descriptionController.clear();
    focusNode.removeListener(onFocusChange);
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(icon: 'cancel'),
        title: Text('Create ${type.name.capitalize}'),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
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
                          controller: itemCreateController.nameController,
                          placeholder: 'Enter Name',
                          validator: Validators.validateName,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Item-specific content
                    buildItemCreateWidget(type, focusNode, hasFocused),
                    const SizedBox(height: 16),
                    // Parent Folder Selector
                    Text('Parent Folder', style: textTheme.labelLarge),
                    SizedBox(height: 8),
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
                                controller: itemCreateController.descriptionController,
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
                          FocusManager.instance.primaryFocus?.unfocus();

                          if (formKey.currentState!.validate()) {
                            Get.dialog(
                              ConfirmDialog(
                                message: "You want to create ${type.name}?\nPlease recheck before confirm.",
                                onConfirm: () => itemCreateController.createLibraryItem(type),
                              ),
                            );
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
          if (hasFocused) Positioned(bottom: 0, left: 0, right: 0, child: NoteToolbar()),
        ],
      ),
    );
  }
}

Widget buildItemCreateWidget(ItemType type, FocusNode focusNode, bool hasFocused) {
  switch (type) {
    case ItemType.folder:
      return CreateFolder();
    case ItemType.note:
      return CreateNote(focusNode: focusNode, hasFocused: hasFocused);
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
