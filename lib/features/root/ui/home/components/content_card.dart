import 'package:fin_app/constant/color.dart';
import 'package:fin_app/features/root/components/display_media.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ContentCard extends StatelessWidget {
  final String? userProfileImage;
  final String? username;
  final int? totalLikes;
  final int? totalComments;
  final String? content;
  final DateTime? datePublished;
  final String? imageUrl;
  final String? videoUrl;
  final int? status;

  const ContentCard({
    Key? key,
    this.userProfileImage,
    this.username,
    this.totalLikes,
    this.totalComments,
    this.content,
    this.datePublished,
    this.imageUrl,
    this.videoUrl,
    this.status,
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
                    Text(
                      username ?? 'tidak ada data',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
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
                  content ?? 'tidak ada data',
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 8.0),
                DisplayMedia(
                  imageUrl: imageUrl,
                  videoUrl: videoUrl,
                  dataSourceType: DataSourceType.network,
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.favorite, color: Colors.red),
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
                        const Icon(Icons.comment, color: Colors.blue),
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
