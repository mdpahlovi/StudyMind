import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studymind/constants/item_type.dart';
import 'package:studymind/controllers/library.dart';

class ChatMention {
  final String uid;
  final String name;
  final ItemType type;

  ChatMention({required this.uid, required this.name, required this.type});

  String toEmbedData() {
    return '$uid|$name|${type.name.toUpperCase()}';
  }

  static ChatMention fromEmbedData(String data) {
    final parts = data.split('|');
    return ChatMention(uid: parts[0], name: parts[1], type: ItemType.values.byName(parts[2].toLowerCase()));
  }

  @override
  String toString() {
    return 'ChatMention{uid: $uid, name: $name, type: $type}';
  }
}

class MentionEmbed extends CustomBlockEmbed {
  const MentionEmbed(String value) : super(mentionType, value);

  static const String mentionType = 'mention';

  static MentionEmbed fromChatMention(ChatMention mention) => MentionEmbed(mention.toEmbedData());

  ChatMention get chatMention => ChatMention.fromEmbedData(data);
}

class MentionEmbedBuilder extends EmbedBuilder {
  @override
  String get key => 'mention';

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    final mention = MentionEmbed(embedContext.node.value.data);
    final chatMention = mention.chatMention;
    final Color color = ItemTypeStyle.getStyle(chatMention.type).color;

    return InkWell(
      onTap: embedContext.readOnly
          ? null
          : () {
              final index = embedContext.controller.document.search(embedContext.node.value.data).first;
              embedContext.controller.replaceText(index, 1, '', TextSelection.collapsed(offset: index));
            },
      child: Container(
        decoration: BoxDecoration(
          color: color.withAlpha(50),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: color, width: 1),
        ),
        child: Text('@${chatMention.name}', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: color)),
      ),
    );
  }
}
