import 'dart:io';

import 'package:fin_app/constant/color.dart';
import 'package:fin_app/features/root/ui/reports/components/custom_icon_button.dart';
import 'package:flutter/material.dart';

class ButtonMedia extends StatefulWidget {
  final List<File?>? imageFile;
  final File? videoFile;
  final Function() onSelectImageTap,
      onSelectVideoTap,
      onTakeImageTap,
      onTakeVideoTap;
  const ButtonMedia(
      {super.key,
      this.imageFile,
      this.videoFile,
      required this.onSelectImageTap,
      required this.onSelectVideoTap,
      required this.onTakeImageTap,
      required this.onTakeVideoTap});

  @override
  State<ButtonMedia> createState() => _ButtonMediaState();
}

class _ButtonMediaState extends State<ButtonMedia> {
  @override
  Widget build(BuildContext context) {
    const color = AppColors.primaryColor;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (widget.imageFile?.length != 3)
        CustomIconButton(
            onPressed: widget.onSelectImageTap,
            icon: const Icon(Icons.image_outlined, color: color, size: 36),
            label: 'Ambil gambar dari gallery'),
      if (widget.videoFile == null)
        CustomIconButton(
            onPressed: widget.onSelectVideoTap,
            icon: const Icon(Icons.video_file_outlined, color: color, size: 36),
            label: 'Ambail video dari gallery'),
      if (widget.imageFile?.length != 3)
        CustomIconButton(
            onPressed: widget.onTakeImageTap,
            icon: const Icon(Icons.camera_alt_outlined, color: color, size: 36),
            label: 'Ambil gambar menggunakan kamera'),
      if (widget.videoFile == null)
        CustomIconButton(
            onPressed: widget.onTakeVideoTap,
            icon: const Icon(Icons.videocam_outlined, color: color, size: 36),
            label: 'Rekam video menggunakan kamera')
    ]);
  }
}
