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
}
