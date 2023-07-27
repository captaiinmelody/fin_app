import 'package:flutter/material.dart';

class LeaderboardsCards extends StatelessWidget {
  final String? profilePhoto;
  final String? userName;
  final int? badges;
  final int? totalReports;
  const LeaderboardsCards({
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
      decoration: BoxDecoration(
          color: Colors.white,
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
              CircleAvatar(
                radius: 24.0,
                child: profilePhoto != null
                    ? Image.network(profilePhoto!)
                    : const Icon(
                        Icons.person_sharp,
                        size: 24,
                      ),
              ),
              const SizedBox(width: 16.0),
              Text(userName!, style: const TextStyle(fontSize: 24)),
            ],
          ),
          Row(
            children: [
              Text("x$badges", style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 16.0),
              const Icon(Icons.military_tech_outlined),
            ],
          )
        ],
      ),
    );
  }
}
