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
      height: 24,
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(12),
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
