import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:studymind/constants/item_type.dart';
import 'package:studymind/controllers/library.dart';

class ChatCreated {
  final String uid;
  final String name;
  final ItemType type;

  ChatCreated({required this.uid, required this.name, required this.type});

  factory ChatCreated.fromString(String data) {
    final Map<String, dynamic> json = jsonDecode(data.replaceFirst('@created ', ''));
    return ChatCreated(uid: json['uid'], name: json['name'], type: ItemType.values.byName(json['type'].toLowerCase()));
  }

  @override
  String toString() {
    return '@created {"uid": "$uid", "name": "$name", "type": "${type.name.toUpperCase()}"}';
  }
}

class CreatedEmbedBuilder extends EmbedBuilder {
  @override
  String get key => EmbeddableCreated.createdType;

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    final LibraryController libraryController = Get.find<LibraryController>();
    final ChatCreated created = ChatCreated.fromString(embedContext.node.value.data);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color color = ItemTypeStyle.getStyle(created.type).color;

    return OutlinedButton(
      onPressed: () => libraryController.navigateToItem(created as dynamic),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color.withAlpha(128)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: color.withAlpha(26),
      ),
      child: Text(created.name, style: textTheme.titleSmall?.copyWith(color: color)),
    );
  }
}

class CreatedSyntax extends md.InlineSyntax {
  CreatedSyntax() : super(r'@created\s+(\{[^}]+\})');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final fullMatch = match.group(0);

    final element = md.Element.empty(EmbeddableCreated.createdType);
    element.attributes['data'] = fullMatch!;

    parser.addNode(element);
    return true;
  }
}

class EmbeddableCreated extends Embeddable {
  const EmbeddableCreated(Map<String, dynamic> data) : super(createdType, data);

  static const String createdType = 'created';

  static BlockEmbed fromMdSyntax(Map<String, dynamic> attributes) {
    return BlockEmbed.custom(CustomBlockEmbed('created', attributes['data']));
  }

  static BlockEmbed fromChatCreated(LibraryItem created) {
    return BlockEmbed.custom(CustomBlockEmbed('created', created.toString()));
  }
}
