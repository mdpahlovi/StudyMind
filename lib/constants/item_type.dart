import 'package:flutter/material.dart';
import 'package:studymind/controllers/library.dart';

class TypeStyle {
  final Color color;
  final String icon;

  const TypeStyle({required this.color, required this.icon});
}

class TypeOption {
  final String icon;
  final String title;
  final Color color;
  final String description;

  const TypeOption({required this.icon, required this.title, required this.color, required this.description});
}

class ItemTypeStyle {
  static TypeStyle getStyle(ItemType type) {
    switch (type) {
      case ItemType.folder:
        return TypeStyle(color: Color(0xFFA8C686), icon: 'folder');
      case ItemType.note:
        return TypeStyle(color: Color(0xFF7D9B5F), icon: 'note');
      case ItemType.document:
        return TypeStyle(color: Color(0xFFF5F5DC), icon: 'document');
      case ItemType.flashcard:
        return TypeStyle(color: Color(0xFF8FBC8F), icon: 'flashcard');
      case ItemType.audio:
        return TypeStyle(color: Color(0xFFE6C79C), icon: 'audio');
      case ItemType.video:
        return TypeStyle(color: Color(0xFFE6C79C), icon: 'video');
      case ItemType.image:
        return TypeStyle(color: Color(0xFFE6C79C), icon: 'image');
    }
  }

  static final List<TypeOption> options = [
    TypeOption(
      icon: "folder",
      title: "Folder",
      color: getStyle(ItemType.folder).color,
      description: "Organize your study materials",
    ),
    TypeOption(
      icon: "note",
      title: "Note",
      color: getStyle(ItemType.note).color,
      description: "Write and format your notes",
    ),
    TypeOption(
      icon: "document",
      title: "Document",
      color: getStyle(ItemType.document).color,
      description: "Upload and manage documents",
    ),
    TypeOption(
      icon: "flashcard",
      title: "Flashcard",
      color: getStyle(ItemType.flashcard).color,
      description: "Create interactive flashcards",
    ),
    TypeOption(
      icon: "audio",
      title: "Audio",
      color: getStyle(ItemType.audio).color,
      description: "Record or upload audio files",
    ),
    TypeOption(
      icon: "video",
      title: "Video",
      color: getStyle(ItemType.video).color,
      description: "Record or upload video contents",
    ),
    TypeOption(
      icon: "image",
      title: "Image",
      color: getStyle(ItemType.image).color,
      description: "Capture or upload your images",
    ),
  ];
}
