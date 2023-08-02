import 'package:fin_app/constant/color.dart';
import 'package:fin_app/routes/route_config.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class UserRank extends StatefulWidget {
  final String? rank;
  final String? badges;
  final String? username;
  const UserRank({
    super.key,
    this.rank,
    this.badges,
    this.username,
  });

  @override
  State<UserRank> createState() => _UserRankState();
}

class _UserRankState extends State<UserRank> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) =>
        ShowCaseWidget.of(context)
            .startShowCase([globalKeyTwo, globalKeyThree]));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height * 0.32,
      margin: const EdgeInsets.only(top: 24, left: 12, right: 12),
      padding: const EdgeInsets.all(24),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircleAvatar(
            radius: 40,
            child: Icon(
              Icons.person,
              size: 40,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              widget.username ?? "",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Showcase(
                key: globalKeyTwo,
                title: 'Ini adalah ranking kamu',
                description: '',
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: AppColors.lightIndigo,
                      borderRadius: BorderRadius.circular(12)),
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.rank ?? "0",
                        style: const TextStyle(fontSize: 40),
                      ),
                      const SizedBox(
                        width: 100,
                        child: Text(
                          'Peringkat',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Showcase(
                key: globalKeyTwo,
                title: 'Ini adalah jumlah lencana kamu',
                description: '',
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: AppColors.lightIndigo,
                      borderRadius: BorderRadius.circular(12)),
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.badges ?? "0",
                        style: const TextStyle(fontSize: 40),
                      ),
                      const SizedBox(
                        width: 100,
                        child: Text(
                          'Lencana',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
