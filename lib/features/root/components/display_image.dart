import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class DisplayImage extends StatefulWidget {
  final String url;
  final DataSourceType dataSourceType;
  final Function()? onPressed;
  final Widget? popupImage;
  final bool showButtonRemove;
  const DisplayImage(
      {super.key,
      required this.url,
      required this.dataSourceType,
      this.onPressed,
      this.popupImage,
      this.showButtonRemove = false});

  @override
  State<DisplayImage> createState() => _DisplayImageState();
}

class _DisplayImageState extends State<DisplayImage> {
  late Widget image;
  @override
  void initState() {
    super.initState();
    switch (widget.dataSourceType) {
      case DataSourceType.asset:
        image = Image.asset(widget.url, fit: BoxFit.fitHeight);
        break;
      case DataSourceType.file:
        image = Image.file(File(widget.url), fit: BoxFit.fitHeight);
        break;
      case DataSourceType.network:
        image = Image.network(widget.url);
        break;
      case DataSourceType.contentUri:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 200,
          width: MediaQuery.of(context).size.width - 50,
          child: image,
        ),
      ),
      if (widget.showButtonRemove)
        Positioned(
            top: 0,
            left: 0,
            child: IconButton(
                icon: const Icon(Icons.close), onPressed: widget.onPressed))
    ]);
  }
}
