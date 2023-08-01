import 'dart:io';

import 'package:fin_app/features/root/ui/reports/components/custom_icon_button.dart';
import 'package:flutter/material.dart';

class ButtonMedia extends StatefulWidget {
  final File? imageFile, videoFile;

  final Function() onSelectImageTap,
      onSelectVideoTap,
      onTakeImageTap,
      onTakeVideoTap;

  const ButtonMedia({
    super.key,
    this.imageFile,
    this.videoFile,
    required this.onSelectImageTap,
    required this.onSelectVideoTap,
    required this.onTakeImageTap,
    required this.onTakeVideoTap,
  });

  @override
  State<ButtonMedia> createState() => _ButtonMediaState();
}

class _ButtonMediaState extends State<ButtonMedia> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.imageFile == null)
          CustomIconButton(
            onPressed: widget.onSelectImageTap,
            icon: const Icon(Icons.image_outlined),
            label: 'Select an image...',
          ),
        if (widget.videoFile == null)
          CustomIconButton(
            onPressed: widget.onSelectVideoTap,
            icon: const Icon(Icons.video_file_outlined),
            label: 'Select a video...',
          ),
        if (widget.imageFile == null)
          CustomIconButton(
            onPressed: widget.onTakeImageTap,
            icon: const Icon(Icons.camera_alt_outlined),
            label: 'Take an image...',
          ),
        if (widget.videoFile == null)
          CustomIconButton(
            onPressed: widget.onTakeVideoTap,
            icon: const Icon(Icons.videocam_outlined),
            label: 'Record a video...',
          ),
      ],
    );
  }
}
