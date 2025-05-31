import 'package:flutter/material.dart';

class CreateFolder extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const CreateFolder({super.key, required this.formKey});

  @override
  State<CreateFolder> createState() => CreateFolderState();
}

class CreateFolderState extends State<CreateFolder> {
  Color selectedColor = Colors.blue;
  IconData selectedIcon = Icons.folder;

  final List<Color> folderColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.indigo,
    Colors.pink,
  ];

  final List<IconData> folderIcons = [
    Icons.folder,
    Icons.folder_special,
    Icons.book,
    Icons.science,
    Icons.calculate,
    Icons.language,
    Icons.history_edu,
    Icons.palette,
  ];

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Color Selection
        Text('Choose Color', style: textTheme.labelLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              folderColors.map((color) {
                return GestureDetector(
                  onTap: () => setState(() => selectedColor = color),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: selectedColor == color ? Border.all(color: Colors.white, width: 3) : null,
                      boxShadow:
                          selectedColor == color
                              ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 2))]
                              : null,
                    ),
                    child: selectedColor == color ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
                  ),
                );
              }).toList(),
        ),
        const SizedBox(height: 24),
        // Icon Selection
        Text('Choose Icon', style: textTheme.labelLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              folderIcons.map((icon) {
                return GestureDetector(
                  onTap: () => setState(() => selectedIcon = icon),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: selectedIcon == icon ? selectedColor.withOpacity(0.1) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border:
                          selectedIcon == icon
                              ? Border.all(color: selectedColor, width: 2)
                              : Border.all(color: Colors.grey[300]!, width: 1),
                    ),
                    child: Icon(icon, color: selectedIcon == icon ? selectedColor : Colors.grey[600], size: 24),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
