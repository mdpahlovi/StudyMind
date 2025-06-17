import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/theme/colors.dart';

class ViewAudio extends StatefulWidget {
  final LibraryItem item;
  const ViewAudio({super.key, required this.item});

  @override
  State<ViewAudio> createState() => ViewAudioState();
}

class ViewAudioState extends State<ViewAudio> {
  late AudioPlayer player;

  @override
  void initState() {
    super.initState();
    final audioUrl = widget.item.metadata?['fileUrl'] ?? '';
    player = AudioPlayer();
    player.setUrl(audioUrl);
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: colorPalette.content, width: 2),
              ),
              child: Center(
                child: StreamBuilder<PlayerState>(
                  stream: player.playerStateStream,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data;
                    final processingState = playerState?.processingState;
                    final playing = playerState?.playing;

                    if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
                      return Padding(
                        padding: const EdgeInsets.all(14),
                        child: CircularProgressIndicator(color: colorPalette.content, strokeWidth: 2),
                      );
                    } else if (playing != true) {
                      return IconButton(
                        icon: const Icon(HugeIcons.strokeRoundedPlay, size: 36),
                        onPressed: player.play,
                      );
                    } else if (processingState != ProcessingState.completed) {
                      return IconButton(
                        icon: const Icon(HugeIcons.strokeRoundedPause, size: 36),
                        onPressed: player.pause,
                      );
                    } else {
                      return IconButton(
                        icon: const Icon(HugeIcons.strokeRoundedReplay, size: 36),
                        onPressed: () => player.seek(Duration.zero),
                      );
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            StreamBuilder<Duration>(
              stream: player.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                return StreamBuilder<Duration?>(
                  stream: player.durationStream,
                  builder: (context, snapshot) {
                    final duration = snapshot.data ?? Duration.zero;
                    return Column(
                      children: [
                        Slider(
                          min: 0,
                          max: duration.inMilliseconds.toDouble(),
                          value: position.inMilliseconds.clamp(0, duration.inMilliseconds).toDouble(),
                          onChanged: (value) {
                            player.seek(Duration(milliseconds: value.toInt()));
                          },
                          inactiveColor: colorPalette.primary.withAlpha(100),
                        ),
                        Text('${formatDuration(position)} / ${formatDuration(duration)}', style: textTheme.labelMedium),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
