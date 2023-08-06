import 'package:flutter/material.dart';

class LeaderboardsCards extends StatelessWidget {
  final String? profilePhoto;
  final String? userName;
  final int? badges;
  final int? totalReports;
  final int? rank;
  const LeaderboardsCards({
    Key? key, // Add the 'key' argument here
    this.profilePhoto,
    this.userName,
    this.badges,
    this.totalReports,
    this.rank,
  }) : super(key: key); // Pass the 'key' to the superclass constructor

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      margin: const EdgeInsets.only(bottom: 12.0, left: 12.0, right: 12.0),
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
              const CircleAvatar(
                  radius: 18.0, child: Icon(Icons.person_sharp, size: 18.0)),
              const SizedBox(width: 16.0),
              Text(userName ?? "no name",
                  style: const TextStyle(fontSize: 18.0)),
            ],
          ),
          Row(
            children: [
              Text(badges == null ? "x0" : "x${badges ?? ''}",
                  style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 12.0),
              const Icon(Icons.military_tech_rounded)
            ],
          )
        ],
      ),
    );
  }
}
