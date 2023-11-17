import 'package:fin_app/constant/color.dart';
import 'package:fin_app/features/root/components/display_image.dart';
import 'package:fin_app/features/root/components/display_video.dart';
import 'package:fin_app/features/root/components/popup_image.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class DisplayMedia extends StatefulWidget {
  final List<String?>? imageUrls;
  final String? videoUrl;
  final DataSourceType? dataSourceType;
  final Function(int)? removeImage;
  final Function()? removeVideo;
  final bool showButtonRemove;
  const DisplayMedia({
    Key? key,
    this.imageUrls,
    this.videoUrl,
    this.dataSourceType,
    this.removeImage,
    this.removeVideo,
    this.showButtonRemove = false,
  }) : super(key: key);

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
    final mediaCount = widget.imageUrls?.length ?? 0;
    final hasVideo = widget.videoUrl != null && widget.videoUrl!.isNotEmpty;
    if (mediaCount == 0 && !hasVideo) {
      return const Text(
        "Sertakan Gambar atau Video dalam pelaporan!\nAnda dapat memasukkan 3 gambar dan satu video atau salah satu.",
        style: TextStyle(color: Colors.redAccent, fontSize: 16),
      );
    }
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.26,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(bottom: 12),
          child: PageView.builder(
            controller: pageController,
            itemCount: mediaCount + (hasVideo ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < mediaCount) {
                return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => PopupImage(
                          imageUrl: widget.imageUrls?[index],
                          dataSourceType: widget.dataSourceType,
                        ),
                      );
                    },
                    child: DisplayImage(
                      url: widget.imageUrls![index]!,
                      dataSourceType: widget.dataSourceType!,
                      showButtonRemove: widget.showButtonRemove,
                      onPressed: () {
                        widget.removeImage!(index);
                      },
                    ));
              } else if (hasVideo && index == mediaCount) {
                return DisplayVideo(
                  url: widget.videoUrl!,
                  dataSourceType: widget.dataSourceType!,
                  onPressed: widget.removeVideo,
                );
              }
              return Container();
            },
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
          ),
        ),
        if (mediaCount > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buildPageIndicator(),
          ),
      ],
    );
  }

  List<Widget> buildPageIndicator() {
    final mediaCount = widget.imageUrls?.length ?? 0;
    final hasVideo = widget.videoUrl != null && widget.videoUrl!.isNotEmpty;
    List<Widget> indicators = [];

    if (mediaCount + (hasVideo ? 1 : 0) > 0) {
      for (int i = 0; i < mediaCount + (hasVideo ? 1 : 0); i++) {
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
    }

    return indicators;
  }
}
