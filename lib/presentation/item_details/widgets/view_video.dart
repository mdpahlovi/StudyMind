import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:studymind/core/logger.dart';
import 'package:studymind/theme/colors.dart';
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
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    final videoUrl = widget.item.metadata?['fileUrl'] ?? '';
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
      ..initialize()
          .then((_) {
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
          })
          .catchError((error) {
            logger.e('Error initializing video player: $error');
            setState(() => isError = true);
          })
          .whenComplete(() => setState(() => isLoading = false));
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return AspectRatio(
      aspectRatio: videoPlayerController.value.aspectRatio,
      child: chewieController != null && videoPlayerController.value.isInitialized
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Chewie(controller: chewieController!),
            )
          : Card(
              child: isError
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(HugeIcons.strokeRoundedAlert02, color: colorPalette.error, size: 64),
                        const SizedBox(height: 12),
                        Text('Failed to load video', style: textTheme.bodyMedium),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          padding: const EdgeInsets.all(8),
                          child: const CircularProgressIndicator(),
                        ),
                        const SizedBox(height: 12),
                        Text('Loading your video...', style: textTheme.bodyMedium),
                      ],
                    ),
            ),
    );
  }
}
