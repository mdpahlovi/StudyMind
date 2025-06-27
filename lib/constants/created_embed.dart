import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:studymind/constants/item_type.dart';
import 'package:studymind/controllers/library.dart';

class CreatedEmbedBuilder extends EmbedBuilder {
  @override
  String get key => EmbeddableCreated.createdType;

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    final LibraryController libraryController = Get.find<LibraryController>();
    final LibraryItem created = LibraryItem.fromString(embedContext.node.value.data);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color color = ItemTypeStyle.getStyle(created.type).color;

    return OutlinedButton(
      onPressed: () => libraryController.navigateToItem(created as dynamic),
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color.withAlpha(50)),
        ),
        backgroundColor: color.withAlpha(25),
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
