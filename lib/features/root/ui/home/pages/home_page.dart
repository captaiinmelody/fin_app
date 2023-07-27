import 'package:fin_app/constant/color.dart';
import 'package:fin_app/constant/text_styles.dart';
import 'package:fin_app/features/root/bloc/root_bloc.dart';
import 'package:fin_app/features/root/data/models/report_models.dart';
import 'package:fin_app/features/root/ui/home/components/content_card.dart';
import 'package:fin_app/features/root/ui/home/components/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
            SliverAppBar(
              pinned: false,
              floating: true,
              snap: true,
              backgroundColor: AppColors.primaryColor,
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.search,
                      size: 36,
                      color: Colors.white,
                    ))
              ],
              centerTitle: true,
              expandedHeight: 80,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12))),
              flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(bottom: 24),
                  centerTitle: true,
                  title: Text("Home",
                      style:
                          TextStyles.titleText.copyWith(color: Colors.white))),
            ),
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
                        Skeleton(),
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
                      ContentCard(
                        username: content.username,
                        content: content.description,
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
