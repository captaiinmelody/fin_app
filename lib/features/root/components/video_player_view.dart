import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends StatefulWidget {
  final String url;
  final DataSourceType dataSourceType;
  final Function()? onPressed;

  const VideoPlayerView({
    super.key,
    required this.url,
    required this.dataSourceType,
    this.onPressed,
  });

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late VideoPlayerController videoPlayerController;

  late ChewieController chewieController;

  @override
  void initState() {
    super.initState();

    switch (widget.dataSourceType) {
      case DataSourceType.asset:
        videoPlayerController = VideoPlayerController.asset(widget.url);
        break;
      case DataSourceType.file:
        videoPlayerController = VideoPlayerController.file(File(widget.url));
        break;
      case DataSourceType.network:
        videoPlayerController =
            VideoPlayerController.networkUrl(Uri.parse(widget.url));
        break;
      case DataSourceType.contentUri:
        videoPlayerController =
            VideoPlayerController.contentUri(Uri.parse(widget.url));
    }

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 200,
          child: Chewie(controller: chewieController),
        ),
        if (widget.onPressed != null)
          Positioned(
              top: 0,
              left: 0,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: widget.onPressed,
              ))
      ],
    );
  }
}
