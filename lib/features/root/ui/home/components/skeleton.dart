import 'package:flutter/material.dart';

class Skeleton extends StatefulWidget {
  const Skeleton({super.key});

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> {
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
                    Container(width: 120, height: 24, color: Colors.grey),
                    Container(width: 120, height: 24, color: Colors.grey)
                  ],
                ),
                const SizedBox(height: 24.0),
                Container(width: 270, height: 24, color: Colors.grey),
                const SizedBox(height: 8.0),
                Container(width: 270, height: 200, color: Colors.grey),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(width: 96, height: 24, color: Colors.grey),
                    Container(width: 96, height: 24, color: Colors.grey),
                    Container(width: 96, height: 24, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 24.0),
                Container(width: 96, height: 24, color: Colors.grey)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
