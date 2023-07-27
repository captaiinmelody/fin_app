import 'package:fin_app/features/root/bloc/root_bloc.dart';
import 'package:fin_app/features/root/components/hideable_app_bar.dart';
import 'package:fin_app/features/root/data/models/report_models.dart';
import 'package:fin_app/features/root/components/reports_card.dart';
import 'package:fin_app/features/root/components/reports_card_skeleton.dart';
import 'package:fin_app/routes/route_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class MyReportsPage extends StatefulWidget {
  const MyReportsPage({super.key});

  @override
  State<MyReportsPage> createState() => _MyReportsPageState();
}

class _MyReportsPageState extends State<MyReportsPage> {
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    context.read<RootBloc>().add(ReportsEventGetByUserId());
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            const HideableAppBar(title: "Home"),
          ];
        },
        body: RefreshIndicator(
          key: refreshIndicatorKey,
          onRefresh: fetchData,
          child: BlocBuilder<RootBloc, RootState>(builder: (context, state) {
            if (state is LoadingState) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.withOpacity(0.5),
                highlightColor: Colors.white,
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return const Column(
                      children: [
                        ReportsCardSkeleton(),
                        Divider(),
                      ],
                    );
                  },
                ),
              );
            } else if (state is LoadedState) {
              return ListView.builder(
                itemCount: state.reportsModels!.length,
                itemBuilder: (context, index) {
                  ReportsModels content = state.reportsModels![index];
                  return Column(
                    children: [
                      ReportsCard(
                        username: content.username,
                        reportsDescription: content.description,
                        imageUrl: content.mediaUrl!.imageUrl,
                        videoUrl: content.mediaUrl!.videoUrl,
                        totalLikes: content.totalLikes,
                        totalComments: content.totalComments,
                        datePublished: content.datePublished,
                        status: content.status,
                      ),
                      const Divider(),
                    ],
                  );
                },
              );
            } else {
              return const Center(
                child: Text("an error occurred when fetching the data..."),
              );
            }
          }),
        ),
      ),
    );
  }
}
