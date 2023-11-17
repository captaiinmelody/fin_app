import 'package:fin_app/constant/color.dart';
import 'package:fin_app/constant/text_styles.dart';
import 'package:fin_app/features/root/bloc/root_bloc.dart';
import 'package:fin_app/features/root/components/hideable_app_bar.dart';
import 'package:fin_app/features/root/data/models/report_models.dart';
import 'package:fin_app/features/root/components/reports_card.dart';
import 'package:fin_app/routes/route_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomePage extends StatefulWidget {
  final RootBloc rootBloc;
  const HomePage({super.key, required this.rootBloc});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<void> fetchData() async {
    context.read<RootBloc>().add(GetReportsEvent("all", "home"));
  }

  @override
  void initState() {
    fetchData();
    super.initState();
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
                          margin: const EdgeInsets.only(top: 20, right: 20),
                          child: IconButton(
                              onPressed: () async {
                                GoRouter.of(context).goNamed(
                                    MyRouterConstant.notificationRouterName);
                              },
                              icon: const Icon(Icons.notifications,
                                  color: Colors.white)))
                    ],
                    child: Text('Beranda',
                        style:
                            TextStyles.titleText.copyWith(color: Colors.white)))
              ];
            },
            body: RefreshIndicator(
                key: refreshIndicatorKey,
                onRefresh: fetchData,
                child:
                    BlocBuilder<RootBloc, RootState>(builder: (context, state) {
                  if (state is HomeState && state.isLoading) {
                    return Center(
                        child: LoadingAnimationWidget.horizontalRotatingDots(
                            color: AppColors.primaryColor, size: 24));
                  } else if (state is HomeState &&
                      !state.isLoading &&
                      !state.isError) {
                    return ListView.builder(
                        itemCount: state.reportsData!.length,
                        itemBuilder: (context, index) {
                          ReportsModel content = state.reportsData![index];
                          state.reportsData?.sort((a, b) =>
                              b.datePublished!.compareTo(a.datePublished!));
                          return Column(children: [
                            ReportsCard(
                                username: content.userData!.username,
                                jabatan: content.userData!.jabatan,
                                profilePhotoUrl:
                                    content.userData!.profilePhotoUrl,
                                reportsDescription:
                                    content.reportsData!.reportsDescription,
                                fixedDescription:
                                    content.reportsData!.fixedDescription,
                                campus: content.reportsData!.campus,
                                location: content.reportsData!.location,
                                status: content.reportsData!.status,
                                imageUrls: content.mediaUrl?.imageUrls,
                                videoUrl: content.mediaUrl?.videoUrl,
                                fixedImageUrls:
                                    content.mediaUrl?.fixedImageUrls,
                                fixedVideoUrl: content.mediaUrl?.fixedVideoUrl,
                                datePublished: content.datePublished,
                                fixedDate: content.updatedAt,
                                fetchData: () {
                                  fetchData();
                                }),
                            const Divider(thickness: 4)
                          ]);
                        });
                  } else if (state is HomeState &&
                      !state.isLoading &&
                      state.isError) {
                    return Center(
                      child: Text(state.message!),
                    );
                  } else {
                    return const Center(
                      child: Text("error saat melakukan pengambilan data"),
                    );
                  }
                }))));
  }
}
