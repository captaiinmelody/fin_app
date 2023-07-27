import 'package:flutter/material.dart';

class LeaderboardsCardsSkeleton extends StatelessWidget {
  final String? profilePhoto;
  final String? userName;
  final int? badges;
  final int? totalReports;
  const LeaderboardsCardsSkeleton({
    super.key,
    this.profilePhoto,
    this.userName,
    this.badges,
    this.totalReports,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey, // Set the shadow color
              offset: Offset(
                  0, 3), // Set the offset of the shadow (horizontal, vertical)
              blurRadius: 6, // Set the blur radius of the shadow
              spreadRadius: 2,
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 24.0, backgroundColor: Colors.grey),
              const SizedBox(width: 16),
              skeletonItems(width: 96, height: 24),
            ],
          ),
          Row(
            children: [
              skeletonItems(width: 36, height: 24),
              skeletonItems(width: 36, height: 24),
            ],
          )
        ],
      ),
    );
  }

  Container skeletonItems({
    double? width,
    double? height,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
