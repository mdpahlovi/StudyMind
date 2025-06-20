import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:studymind/constants/item_type.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/theme/colors.dart';

class ChatMention {
  final String uid;
  final String name;
  final ItemType type;

  ChatMention({required this.uid, required this.name, required this.type});

  factory ChatMention.fromString(String data) {
    final Map<String, dynamic> json = jsonDecode(data.replaceFirst('@mention ', ''));
    return ChatMention(uid: json['uid'], name: json['name'], type: ItemType.values.byName(json['type'].toLowerCase()));
  }

  @override
  String toString() {
    return '@mention {"uid": "$uid", "name": "$name", "type": "${type.name.toUpperCase()}"}';
  }
}

class MentionEmbedBuilder extends EmbedBuilder {
  @override
  String get key => EmbeddableMention.mentionType;

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    final ChatMention mention = ChatMention.fromString(embedContext.node.value.data);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color color = ItemTypeStyle.getStyle(mention.type).color;

    return Container(
      decoration: BoxDecoration(
        color: color.withAlpha(50),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color, width: 1),
      ),
      child: Column(
        children: [Text('@${mention.name}', style: textTheme.labelMedium?.copyWith(height: 1.2, color: color))],
      ),
    );
  }
}

class MentionOutlineEmbedBuilder extends EmbedBuilder {
  @override
  String get key => EmbeddableMention.mentionType;

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    final ChatMention mention = ChatMention.fromString(embedContext.node.value.data);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color color = AppColors().palette.content;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color, width: 1),
      ),
      child: Text('@${mention.name}', style: textTheme.labelMedium?.copyWith(height: 1.2, color: color)),
    );
  }
}

class MentionSyntax extends md.InlineSyntax {
  MentionSyntax() : super(r'@mention\s+(\{[^}]+\})');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final fullMatch = match.group(0);

    final element = md.Element.empty(EmbeddableMention.mentionType);
    element.attributes['data'] = fullMatch!;

    parser.addNode(element);
    return true;
  }
}

class EmbeddableMention extends Embeddable {
  const EmbeddableMention(Map<String, dynamic> data) : super(mentionType, data);

  static const String mentionType = 'mention';

  static BlockEmbed fromMdSyntax(Map<String, dynamic> attributes) {
    return BlockEmbed.custom(CustomBlockEmbed('mention', attributes['data']));
  }

  static BlockEmbed fromChatMention(ChatMention mention) {
    return BlockEmbed.custom(CustomBlockEmbed('mention', mention.toString()));
  }
}
