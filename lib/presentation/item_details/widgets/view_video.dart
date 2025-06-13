import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:studymind/controllers/library.dart';

class ViewVideo extends StatefulWidget {
  final LibraryItem item;
  const ViewVideo({super.key, required this.item});

  @override
  State<ViewVideo> createState() => ViewVideoState();
}

class ViewVideoState extends State<ViewVideo> {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    final videoUrl = widget.item.metadata?['fileUrl'] ?? '';
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
      ..initialize().then((_) {
        setState(() {
          chewieController = ChewieController(
            videoPlayerController: videoPlayerController,
            autoPlay: true,
            looping: false,
            aspectRatio: videoPlayerController.value.aspectRatio,
            errorBuilder: (context, errorMessage) {
              return Center(child: Text('Error: $errorMessage'));
            },
          );
        });
      });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: videoPlayerController.value.aspectRatio,
      child: chewieController != null && videoPlayerController.value.isInitialized
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Chewie(controller: chewieController!),
            )
          : Card(
              child: Center(child: SizedBox(width: 64, height: 64, child: const CircularProgressIndicator())),
            ),
    );
  }
}
