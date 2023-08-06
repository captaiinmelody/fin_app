import 'package:fin_app/constant/text_styles.dart';
import 'package:fin_app/features/auth/data/localresources/auth_local_storage.dart';
import 'package:fin_app/features/root/bloc/root_bloc.dart';
import 'package:fin_app/features/root/components/hideable_app_bar.dart';
import 'package:fin_app/features/root/data/models/report_models.dart';
import 'package:fin_app/features/root/components/reports_card.dart';
import 'package:fin_app/features/root/components/reports_card_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class MyReportsPage extends StatefulWidget {
  final RootBloc rootBloc;
  const MyReportsPage({super.key, required this.rootBloc});

  @override
  State<MyReportsPage> createState() => _MyReportsPageState();
}

class _MyReportsPageState extends State<MyReportsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool? currentIsAdmin;

  @override
  void initState() {
    initRoleData();
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> initRoleData() async {
    await getRole();

    fetchData();
  }

  Future<void> getRole() async {
    final isAdmin = await AuthLocalStorage().isRoleAdmin();
    setState(() {
      currentIsAdmin = isAdmin;
    });
  }

  Future<void> fetchData() async {
    if (currentIsAdmin == false) {
      context.read<RootBloc>().add(ReportsEventGetByUserId());
    } else {
      context.read<RootBloc>().add(ReportsEventGet());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              HideableAppBar(
                  child: Text('Laporan',
                      style:
                          TextStyles.titleText.copyWith(color: Colors.white))),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Dilaporkan'),
                      Tab(text: 'Terkonfirmasi'),
                      Tab(text: 'Telah diperbaiki'),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: BlocBuilder<RootBloc, RootState>(builder: (context, state) {
            if (state is LoadingState) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.withOpacity(0.5),
                highlightColor: Colors.white,
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return const Column(
                      children: [
                        ReportsCardSkeleton(isHomePage: false),
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
      return RefreshIndicator(
        onRefresh: fetchData,
        child: ListView.builder(
          itemCount: reportsForStatus.length,
          itemBuilder: (context, index) {
            ReportsModels content = reportsForStatus[index];
            return Column(
              children: [
                ReportsCard(
                  rootBloc: widget.rootBloc,
                  reportsId: content.reportsId,
                  username: content.username,
                  location: content.kampus,
                  detailLocation: content.detailLokasi,
                  reportsDescription: content.description,
                  imageUrl: content.mediaUrl?.imageUrl,
                  videoUrl: content.mediaUrl?.videoUrl,
                  fixedImageUrl: content.mediaUrl?.fixedImageUrl,
                  fixedVideoUrl: content.mediaUrl?.fixedVideoUrl,
                  totalLikes: content.totalLikes,
                  totalComments: content.totalComments,
                  datePublished: content.datePublished,
                  status: content.status,
                  isHomePage: false,
                  isAdmin: currentIsAdmin ?? false,
                ),
                const Divider(),
              ],
            );
          },
        ),
      );
    } else if (status == 0) {
      return const Center(
        child: Text("Data laporan tidak ada, buat laporan terlebih dahulu"),
      );
    } else if (status == 1) {
      return const Center(
        child: Text("Belum ada laporan yang terkonfirmasi"),
      );
    } else {
      return const Center(
        child: Text("Belum ada laporan yang telah diperbaiki"),
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
