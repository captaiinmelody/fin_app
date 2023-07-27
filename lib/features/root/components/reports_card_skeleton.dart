import 'package:flutter/material.dart';

class ReportsCardSkeleton extends StatefulWidget {
  const ReportsCardSkeleton({super.key});

  @override
  State<ReportsCardSkeleton> createState() => _ReportsCardSkeletonState();
}

class _ReportsCardSkeletonState extends State<ReportsCardSkeleton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(radius: 24.0, backgroundColor: Colors.grey),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    skeletonItems(width: 120, height: 24),
                    skeletonItems(width: 120, height: 24),
                  ],
                ),
                const SizedBox(height: 24.0),
                skeletonItems(width: 270, height: 24),
                const SizedBox(height: 8.0),
                skeletonItems(width: 270, height: 200),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    skeletonItems(width: 72, height: 24),
                    skeletonItems(width: 72, height: 24),
                    skeletonItems(width: 72, height: 24),
                  ],
                ),
                const SizedBox(height: 24.0),
                skeletonItems(width: 72, height: 24),
              ],
            ),
          ),
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
