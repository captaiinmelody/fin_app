import 'package:fin_app/constant/color.dart';
import 'package:fin_app/features/root/components/image_view.dart';
import 'package:fin_app/features/root/components/video_player_view.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class DisplayMedia extends StatefulWidget {
  final String? imageUrl;
  final String? videoUrl;
  final DataSourceType? dataSourceType;
  const DisplayMedia({
    super.key,
    this.imageUrl,
    this.videoUrl,
    this.dataSourceType,
  });

  @override
  State<DisplayMedia> createState() => _DisplayMediaState();
}

class _DisplayMediaState extends State<DisplayMedia> {
  int currentPage = 0;
  PageController pageController = PageController(initialPage: 0);
  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        currentPage = pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 270,
      margin: const EdgeInsets.only(bottom: 12),
      child: Stack(
        children: [
          PageView(
            controller: pageController,
            children: [
              if (widget.imageUrl != null && widget.imageUrl != '')
                ImageView(
                  url: widget.imageUrl!,
                  dataSourceType: widget.dataSourceType!,
                ),
              if (widget.videoUrl != null || widget.videoUrl != '')
                VideoPlayerView(
                  url: widget.videoUrl!,
                  dataSourceType: widget.dataSourceType!,
                ),
            ],
            onPageChanged: (index) {
              setState(() {}); // Update the page indicator
            },
          ),
          if (widget.imageUrl != null && widget.imageUrl != '' ||
              widget.videoUrl != null && widget.videoUrl == '')
            Positioned(
              left: 0,
              right: 0,
              bottom: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: buildPageIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> buildPageIndicator() {
    List<Widget> indicators = [];

    for (int i = 0; i < 2; i++) {
      indicators.add(
        Container(
          width: 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i == currentPage ? AppColors.primaryColor : Colors.black45,
          ),
        ),
      );
    }
    return indicators;
  }

  bool shouldDisplayPageIndicator() {
    return (widget.imageUrl != null && widget.imageUrl != '') ||
        (widget.videoUrl != null && widget.videoUrl != '');
  }
}
