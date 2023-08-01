import 'package:fin_app/constant/text_styles.dart';
import 'package:fin_app/features/root/bloc/root_bloc.dart';
import 'package:fin_app/features/root/components/display_image.dart';
import 'package:fin_app/features/root/components/hideable_app_bar.dart';
import 'package:fin_app/features/root/data/models/report_models.dart';
import 'package:fin_app/features/root/components/reports_card.dart';
import 'package:fin_app/features/root/components/reports_card_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  final RootBloc rootBloc;
  const HomePage({super.key, required this.rootBloc});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    context.read<RootBloc>().add(ReportsEventGet());
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            HideableAppBar(
                child: Text('Home',
                    style: TextStyles.titleText.copyWith(color: Colors.white))),
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
                itemCount: state.listOfReportsModels!.length,
                itemBuilder: (context, index) {
                  ReportsModels content = state.listOfReportsModels![index];
                  int totalLikes = content.totalLikes!;
                  int totalComments = content.totalComments!;
                  String reportsId = content.reportsId!;
                  state.listOfReportsModels?.sort(
                      (a, b) => b.datePublished!.compareTo(a.datePublished!));
                  return Column(
                    children: [
                      ReportsCard(
                        username: content.username,
                        profilePhotoUrl: content.profilePhotoUrl,
                        location: content.kampus,
                        detailLocation: content.detailLokasi,
                        reportsDescription: content.description,
                        imageUrl: content.mediaUrl?.imageUrl,
                        videoUrl: content.mediaUrl?.videoUrl,
                        totalLikes: totalLikes,
                        totalComments: totalComments,
                        datePublished: content.datePublished,
                        status: content.status,
                        viewImage: () {
                          showGeneralDialog(
                            context: context,
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return DisplayImage(
                                url: content.mediaUrl!.imageUrl!,
                                dataSourceType: DataSourceType.network,
                                onPressed: () {
                                  GoRouter.of(context).pop();
                                },
                              );
                            },
                          );
                        },
                        onLikeTap: () async {
                          setState(() {
                            totalLikes = content.totalLikes! + 1;
                            widget.rootBloc.add(ReportsEventUpdateCounter(
                                reportsId: reportsId, counter: 'totalLikes'));
                          });
                        },
                        onCommentTap: () {
                          setState(() {
                            totalComments = content.totalComments! + 1;
                            widget.rootBloc.add(ReportsEventUpdateCounter(
                                reportsId: reportsId,
                                counter: 'totalComments'));
                          });
                        },
                        isHomePage: true,
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
