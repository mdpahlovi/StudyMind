import 'package:flutter/material.dart';
import 'package:studymind/controllers/library.dart';

class TypeStyle {
  final Color color;
  final String icon;

  const TypeStyle({required this.color, required this.icon});
}

class ItemTypeStyle {
  final ItemType type;
  ItemTypeStyle({required this.type});

  TypeStyle get decoration {
    switch (type) {
      case ItemType.folder:
        return TypeStyle(color: Color(0xFF606C38), icon: 'folder');
      case ItemType.note:
        return TypeStyle(color: Color(0xFF283618), icon: 'note');
      case ItemType.document:
        return TypeStyle(color: Color(0xFFFEFAE0), icon: 'document');
      case ItemType.flashcard:
        return TypeStyle(color: Color(0xFF588157), icon: 'flashcard');
      case ItemType.audio:
        return TypeStyle(color: Color(0xFFDDA15E), icon: 'audio');
      case ItemType.video:
        return TypeStyle(color: Color(0xFFDDA15E), icon: 'video');
      case ItemType.image:
        return TypeStyle(color: Color(0xFFDDA15E), icon: 'image');
    }
  }
}
