import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ImageView extends StatefulWidget {
  final String url;
  final DataSourceType dataSourceType;
  final Function()? onPressed;
  const ImageView({
    super.key,
    required this.url,
    required this.dataSourceType,
    this.onPressed,
  });

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  late Widget image;

  @override
  void initState() {
    super.initState();

    switch (widget.dataSourceType) {
      case DataSourceType.asset:
        image = Image.asset(
          widget.url,
          height: 200,
          width: 270,
          fit: BoxFit.fitHeight,
        );
        break;
      case DataSourceType.file:
        image = Image.file(
          File(widget.url),
          height: 200,
          width: 270,
          fit: BoxFit.fitHeight,
        );
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
    return Center(
      child: Stack(children: [
        Container(
          color: Colors.black26,
          child: image,
        ),
        if (widget.onPressed != null)
          Positioned(
              top: 0,
              left: 0,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: widget.onPressed,
              ))
      ]),
    );
  }
}
