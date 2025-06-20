import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:just_audio/just_audio.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:markdown_quill/markdown_quill.dart';
import 'package:studymind/constants/mention_embed.dart';
import 'package:video_player/video_player.dart';

String bytesToMB(dynamic bytes, {int decimals = 2}) {
  double mb = bytes / (1024 * 1024);
  return mb.toStringAsFixed(decimals);
}

String secToMin(dynamic totalSeconds) {
  int minutes = totalSeconds ~/ 60;
  int seconds = (totalSeconds % 60).toInt();
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}

Future<int> getAudioDuration(String filePath) async {
  final player = AudioPlayer();
  await player.setFilePath(filePath);

  final duration = player.duration;
  await player.dispose();

  return duration != null ? duration.inSeconds : 0;
}

Future<int> getVideoDuration(String filePath) async {
  final player = VideoPlayerController.file(File(filePath));
  await player.initialize();

  final duration = player.value.duration;
  await player.dispose();

  return duration.inSeconds;
}

Future<String> getImageResolution(String filePath) async {
  final imageBytes = await File(filePath).readAsBytes();
  final image = img.decodeImage(imageBytes);

  return image != null ? '${image.width}x${image.height}' : '';
}

final markdownTODelta = MarkdownToDelta(
  markdownDocument: md.Document(
    encodeHtml: false,
    blockSyntaxes: [EmbeddableTableSyntax()],
    inlineSyntaxes: [MentionSyntax()],
  ),
  customElementToEmbeddable: {
    EmbeddableTable.tableType: EmbeddableTable.fromMdSyntax,
    EmbeddableMention.mentionType: EmbeddableMention.fromMdSyntax,
  },
);
final deltaToMarkdown = DeltaToMarkdown();
