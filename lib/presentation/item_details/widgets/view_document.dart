import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_iframe/flutter_html_iframe.dart';
import 'package:studymind/controllers/library.dart';

class ViewDocument extends StatelessWidget {
  final LibraryItem item;
  const ViewDocument({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final fileUrl = item.metadata?['fileUrl'];
    if (fileUrl == null || fileUrl.isEmpty) {
      return const Center(child: Text("No document available"));
    }

    final viewerUrl = Uri.encodeFull("https://docs.google.com/gview?embedded=true&url=$fileUrl");
    final width = MediaQuery.of(context).size.width - 32;

    return AspectRatio(
      aspectRatio: 1 / sqrt(2), // A4 paper ratio
      child: Html(
        data:
            """
              <iframe 
                src="$viewerUrl" 
                width="$width" 
                height="${width * sqrt(2)}" 
                style="border:none;">
              </iframe>
            """,
        extensions: [IframeHtmlExtension()],
      ),
    );
  }
}
