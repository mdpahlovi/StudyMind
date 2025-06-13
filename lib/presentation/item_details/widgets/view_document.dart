import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:studymind/controllers/library.dart';

class ViewDocument extends StatelessWidget {
  final LibraryItem item;
  const ViewDocument({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1 / sqrt(2),
      child: Card(
        child: Html(
          data: """
        <h1>Hello, World!</h1>
        <p><span style="font-style:italic;">flutter_html</span> supports a variety of HTML and CSS tags and attributes.</p>
        <p>Over a hundred static tags are supported out of the box.</p>
        <p>Or you can even define your own using an <code>Extension</code>: <flutter></flutter></p>
        <p>Its easy to add custom styles to your Html as well using the <code>Style</code> class:</p>
        <p class="fancy">Here's a fancy &lt;p&gt; element!</p>
        """,
          extensions: [
            TagExtension(tagsToExtend: {"flutter"}, child: const FlutterLogo()),
          ],
        ),
      ),
    );
  }
}
