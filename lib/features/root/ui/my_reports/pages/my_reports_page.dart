import 'package:fin_app/constant/color.dart';
import 'package:fin_app/constant/text_styles.dart';
import 'package:fin_app/features/auth/data/localresources/auth_local_storage.dart';
import 'package:fin_app/features/root/bloc/root_bloc.dart';
import 'package:fin_app/features/root/components/hideable_app_bar.dart';
import 'package:fin_app/features/root/data/models/report_models.dart';
import 'package:fin_app/features/root/components/reports_card.dart';
import 'package:fin_app/routes/route_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MyReportsPage extends StatefulWidget {
  final RootBloc rootBloc;
  const MyReportsPage({super.key, required this.rootBloc});

  @override
  State<MyReportsPage> createState() => _MyReportsPageState();
}

class _MyReportsPageState extends State<MyReportsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? currentRole;

  Future<void> initRoleData() async {
    await getRole();
    fetchData();
  }

  Future<void> getRole() async {
    final role = await AuthLocalStorage().getRole();
    setState(() {
      currentRole = role;
    });
  }

  Future<void> fetchData() async {
    print(currentRole);
    void getReportsForRole(String role, {String? campus}) {
      context
          .read<RootBloc>()
          .add(GetReportsEvent(role, "reports", campus: campus));
    }

    switch (currentRole) {
      case "reporter":
        getReportsForRole("reporter");
        break;
      case "krt_kampus_1":
        getReportsForRole("krt", campus: "Kampus 1");
        break;
      case "krt_kampus_2":
        getReportsForRole("krt", campus: "Kampus 2");
        break;
      case "krt_kampus_3":
        getReportsForRole("krt", campus: "Kampus 3");
        break;
      case "krt_kampus_4":
        getReportsForRole("krt", campus: "Kampus 4");
        break;
      case "krt_kampus_5":
        getReportsForRole("krt", campus: "Kampus 5");
        break;
      case "krt_kampus_6":
        getReportsForRole("krt", campus: "Kampus 6");
        break;
      default:
        getReportsForRole("admin");
        break;
    }
  }

  @override
  void initState() {
    initRoleData();
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
      return [
        HideableAppBar(
            icon: [
              Container(
                  margin: const EdgeInsets.only(right: 20, top: 20),
                  child: IconButton(
                      onPressed: () {
                        GoRouter.of(context)
                            .goNamed(MyRouterConstant.notificationRouterName);
                      },
                      icon:
                          const Icon(Icons.notifications, color: Colors.white)))
            ],
            child: Text('Laporan',
                style: TextStyles.titleText.copyWith(color: Colors.white))),
        SliverPersistentHeader(
            delegate: _SliverAppBarDelegate(
                TabBar(controller: _tabController, tabs: const [
              Tab(text: 'Dilaporkan'),
              Tab(text: "Ditolak"),
              Tab(text: 'Dikonfirmasi'),
              Tab(text: 'Telah diperbaiki')
            ])),
            pinned: true)
      ];
    }, body: BlocBuilder<RootBloc, RootState>(builder: (context, state) {
      if (state is ReportsState && state.isLoading) {
        return Center(
            child: LoadingAnimationWidget.horizontalRotatingDots(
                color: AppColors.primaryColor, size: 24));
      } else if (state is ReportsState && !state.isLoading && !state.isError) {
        return RefreshIndicator(
            onRefresh: fetchData,
            child: TabBarView(controller: _tabController, children: [
              buildReportsForStatus(state, "reported"),
              buildReportsForStatus(state, "rejected"),
              buildReportsForStatus(state, "confirmed"),
              buildReportsForStatus(state, "fixed")
            ]));
      } else if (state is ReportsState && !state.isLoading && state.isError) {
        return Center(
          child: Text(state.message!),
        );
      } else {
        return const Center(
            child: Text("Terjadi kesalahan ketika mengambil data..."));
      }
    })));
  }

  Widget buildReportsForStatus(ReportsState state, String status) {
    final List<ReportsModel> reportsForStatus = state.reportsData!
        .where((report) => report.reportsData!.status == status)
        .toList();
    if (reportsForStatus.isNotEmpty) {
      return RefreshIndicator(
          onRefresh: fetchData,
          child: ListView.builder(
              itemCount: reportsForStatus.length,
              itemBuilder: (context, index) {
                ReportsModel content = reportsForStatus[index];
                return Column(children: [
                  ReportsCard(
                      reportsId: content.reportsId,
                      rootBloc: widget.rootBloc,
                      username: content.userData!.username,
                      jabatan: content.userData!.jabatan,
                      profilePhotoUrl: content.userData!.profilePhotoUrl,
                      reportsDescription:
                          content.reportsData!.reportsDescription,
                      fixedDescription: content.reportsData!.fixedDescription,
                      campus: content.reportsData!.campus,
                      location: content.reportsData!.location,
                      status: content.reportsData?.status,
                      imageUrls: content.mediaUrl?.imageUrls,
                      videoUrl: content.mediaUrl?.videoUrl,
                      fixedImageUrls: content.mediaUrl?.fixedImageUrls,
                      fixedVideoUrl: content.mediaUrl?.fixedVideoUrl,
                      datePublished: content.datePublished,
                      fixedDate: content.updatedAt,
                      role: currentRole!,
                      fetchData: () {
                        fetchData();
                      }),
                  const Divider(thickness: 4)
                ]);
              }));
    } else if (status == "reported") {
      return const Center(
          child: Text("Tidak ada laporan dengan status dilapokan"));
    } else if (status == "confirmed") {
      return const Center(child: Text("Tidak ada laporan yang dikonfirmasi"));
    } else if (status == "rejected") {
      return const Center(child: Text("Tidak ada laporan yang ditolak"));
    } else {
      return const Center(
          child: Text("Belum ada laporan yang telah diperbaiki"));
    }
  }
}

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
