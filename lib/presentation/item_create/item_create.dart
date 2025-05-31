import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/constants/item_type.dart';
import 'package:studymind/core/logger.dart';
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

class ItemCreateScreen extends StatefulWidget {
  const ItemCreateScreen({super.key});

  @override
  State<ItemCreateScreen> createState() => ItemCreateScreenState();
}

class ItemCreateScreenState extends State<ItemCreateScreen> {
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

  @override
  Widget build(BuildContext context) {
    final TypeOption option = Get.arguments;
    final TextTheme textTheme = Theme.of(context).textTheme;

    Widget itemCreateWidget() {
      switch (option.title) {
        case 'Folder':
          return CreateFolder(formKey: formKey);
        case 'Note':
          return CreateNote(formKey: formKey);
        case 'Document':
          return CreateDocument(formKey: formKey);
        case 'Flashcard':
          return CreateFlashcard(formKey: formKey);
        case 'Audio':
          return CreateAudio(formKey: formKey);
        case 'Video':
          return CreateVideo(formKey: formKey);
        case 'Image':
          return CreateImage(formKey: formKey);
        default:
          return const SizedBox();
      }
    }

    final List<ItemFolder> folders = [
      ItemFolder(id: null, name: "Root Folder", path: "/"),
      ItemFolder(id: 1, name: "Mathematics", path: "/Mathematics"),
      ItemFolder(id: 2, name: "Physics", path: "/Physics"),
      ItemFolder(id: 3, name: "Chemistry", path: "/Chemistry"),
      ItemFolder(id: 4, name: "Biology", path: "/Biology"),
      ItemFolder(id: 5, name: "Computer Science", path: "/Computer Science"),
      ItemFolder(id: 6, name: "History", path: "/History"),
      ItemFolder(id: 7, name: "Geography", path: "/Geography"),
      ItemFolder(id: 8, name: "English", path: "/English"),
      ItemFolder(id: 9, name: "Arabic", path: "/Arabic"),
      ItemFolder(id: 10, name: "French", path: "/French"),
    ];

    Future<void> handleCreate() async {
      if (formKey.currentState!.validate()) {
        logger.d('Creating ${option.title} with name: ${nameController.text}');
      }
    }

    return Scaffold(
      appBar: AppBar(leading: CustomBackButton(icon: 'cancel'), title: Text('Create ${option.title}')),
      body: Form(
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
                  Text('Name *', style: textTheme.labelLarge),
                  SizedBox(height: 8),
                  CustomTextField(
                    controller: nameController,
                    placeholder: 'Enter Name',
                    validator: Validators.validateName,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Item-specific content
              itemCreateWidget(),
              const SizedBox(height: 24),
              // Parent Folder Selector
              ParentFolderSelector(folders: folders, value: 10, onChanged: (folderId) {}),
              const SizedBox(height: 24),
              // Description Input Section
              Column(
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
              ),
              const SizedBox(height: 24),
              // Create Button
              CustomButton(text: 'Create ${option.title}', onPressed: handleCreate),
            ],
          ),
        ),
      ),
    );
  }
}
