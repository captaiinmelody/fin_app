import 'package:fin_app/constant/text_styles.dart';
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

class _MyReportsPageState extends State<MyReportsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
            HideableAppBar(
                child: Text('My Reports',
                    style: TextStyles.titleText.copyWith(color: Colors.white))),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Reported'),
                    Tab(text: 'On Progress'),
                    Tab(text: 'Fixed'),
                  ],
                ),
              ),
              pinned: true,
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
                        ReportsCardSkeleton(),
                        Divider(),
                      ],
                    );
                  },
                ),
              );
            } else if (state is LoadedState) {
              return TabBarView(
                controller: _tabController,
                children: [
                  // Display data for status 0
                  _buildReportsForStatus(state, 0),
                  // Display data for status 1
                  _buildReportsForStatus(state, 1),
                  // Display data for status 2
                  _buildReportsForStatus(state, 2),
                ],
              );
            } else {
              return const Center(
                child: Text("An error occurred when fetching the data..."),
              );
            }
          }),
        ),
      ),
    );
  }

  Widget _buildReportsForStatus(LoadedState state, int status) {
    final List<ReportsModels> reportsForStatus = state.listOfReportsModels!
        .where((report) => report.status == status)
        .toList();
    if (reportsForStatus.isNotEmpty) {
      return ListView.builder(
        itemCount: reportsForStatus.length,
        itemBuilder: (context, index) {
          ReportsModels content = reportsForStatus[index];
          return Column(
            children: [
              ReportsCard(
                username: content.username,
                location: content.kampus,
                detailLocation: content.detailLokasi,
                reportsDescription: content.description,
                imageUrl: content.mediaUrl!.imageUrl,
                videoUrl: content.mediaUrl!.videoUrl,
                totalLikes: content.totalLikes,
                totalComments: content.totalComments,
                datePublished: content.datePublished,
                status: content.status,
                isHomePage: false,
              ),
              const Divider(),
            ],
          );
        },
      );
    } else if (status == 0) {
      return const Center(
        child: Text("You haven't made a reports..."),
      );
    } else if (status == 1) {
      return const Center(
        child: Text("None of your reports is being process..."),
      );
    } else {
      return const Center(
        child: Text("None of your reports is being fixed..."),
      );
    }
  }
}

// ... Rest of the code remains unchanged.

// This class is used to add the TabBar as a persistent header in the NestedScrollView.
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverAppBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
