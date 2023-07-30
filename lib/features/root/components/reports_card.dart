import 'package:fin_app/constant/color.dart';
import 'package:fin_app/features/root/components/display_media.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

@immutable
class ReportsCard extends StatelessWidget {
  final String? userProfileImage,
      username,
      location,
      detailLocation,
      reportsDescription,
      imageUrl,
      videoUrl;
  final int? totalLikes;
  final int? totalComments;
  final DateTime? datePublished;
  final int? status;
  final bool isHomePage;

  final Function()? onLikeTap, onCommentTap;

  const ReportsCard({
    Key? key,
    this.userProfileImage,
    this.username,
    this.totalLikes,
    this.totalComments,
    this.datePublished,
    this.location,
    this.detailLocation,
    this.reportsDescription,
    this.imageUrl,
    this.videoUrl,
    this.status,
    this.onLikeTap,
    this.onCommentTap,
    required this.isHomePage,
  }) : super(key: key);

  String getFormattedTimeSince(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays >= 7) {
      return '${difference.inDays ~/ 7} week(s) ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day(s) ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour(s) ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute(s) ago';
    } else {
      return '${difference.inSeconds} second(s) ago';
    }
  }

  static const isAlreadyLiking = true;

  @override
  Widget build(BuildContext context) {
    final formattedTimeSince = datePublished != null
        ? getFormattedTimeSince(datePublished!)
        : 'No Date';
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(radius: 24.0, child: Icon(Icons.person)),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "@${username!.toLowerCase()}",
                          style: const TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                "${location!.toLowerCase()} | ${detailLocation!.toLowerCase()}",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                ),
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 12),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45, width: 2),
                          borderRadius: BorderRadius.circular(8),
                          color: status == 0
                              ? Colors.red
                              : status == 1
                                  ? AppColors.primaryColor
                                  : Colors.green),
                      child: Center(
                        child: Text(
                          status == 0
                              ? "Reported"
                              : status == 1
                                  ? "On progress"
                                  : "Fixed",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 24.0),
                Text(
                  reportsDescription ?? 'tidak ada data',
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 8.0),
                DisplayMedia(
                  imageUrl: imageUrl,
                  videoUrl: videoUrl,
                  dataSourceType: DataSourceType.network,
                ),
                const SizedBox(height: 8.0),
                if (isHomePage)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: onLikeTap,
                            splashColor: Colors.grey.withOpacity(0.25),
                            child: isAlreadyLiking
                                ? const Icon(Icons.favorite, color: Colors.red)
                                : const Icon(Icons.favorite_outline,
                                    color: Colors.red),
                          ),
                          const SizedBox(width: 4.0),
                          Text(totalLikes.toString()),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.share, color: Colors.green),
                          const SizedBox(width: 4.0),
                          Text(totalLikes.toString()),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                              onTap: onCommentTap,
                              splashColor: Colors.grey.withOpacity(0.25),
                              child: const Icon(Icons.comment,
                                  color: Colors.blue)),
                          const SizedBox(width: 4.0),
                          Text(totalComments.toString()),
                        ],
                      ),
                    ],
                  ),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formattedTimeSince,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
