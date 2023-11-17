import 'package:fin_app/features/root/components/display_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

class PopupImage extends StatefulWidget {
  final String? imageUrl;
  final DataSourceType? dataSourceType;
  const PopupImage({super.key, this.imageUrl, this.dataSourceType});

  @override
  State<PopupImage> createState() => _PopupImageState();
}

class _PopupImageState extends State<PopupImage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            GoRouter.of(context).pop();
          });
        },
        child: Container(
            width: MediaQuery.of(context).size.width - 50,
            height: MediaQuery.of(context).size.height,
            color: Colors.black.withOpacity(0.25),
            child: Stack(children: [
              Center(
                  child: DisplayImage(
                url: widget.imageUrl!,
                dataSourceType: widget.dataSourceType!,
              ))
            ])));
  }
}
