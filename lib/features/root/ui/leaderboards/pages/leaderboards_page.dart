import 'package:fin_app/constant/color.dart';
import 'package:fin_app/constant/text_styles.dart';
import 'package:fin_app/features/root/bloc/root_bloc.dart';
import 'package:fin_app/features/root/components/hideable_app_bar.dart';
import 'package:fin_app/features/root/data/models/leaderboards_models.dart';
import 'package:fin_app/features/root/ui/leaderboards/components/leaderboards_card.dart';
import 'package:fin_app/features/root/ui/leaderboards/components/users_rank.dart';
import 'package:fin_app/routes/route_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LeaderboardsPage extends StatefulWidget {
  const LeaderboardsPage({super.key});

  @override
  State<LeaderboardsPage> createState() => _LeaderboardsPageState();
}

class _LeaderboardsPageState extends State<LeaderboardsPage> {
  final key3 = GlobalKey();

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    context.read<RootBloc>().add(LeaderboardsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            HideableAppBar(
                child: Text('Peringkat',
                    style: TextStyles.titleText.copyWith(color: Colors.white))),
          ];
        },
        body: RefreshIndicator(
          key: refreshIndicatorKey,
          onRefresh: fetchData,
          child: BlocBuilder<RootBloc, RootState>(builder: (context, state) {
            if (state is LoadingState) {
              return Center(
                child: LoadingAnimationWidget.horizontalRotatingDots(
                    color: AppColors.primaryColor, size: 24),
              );
            } else if (state is LeaderboardsLoadedState) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    UserRank(
                      username:
                          '@${state.leaderboardsModels?.username!.toLowerCase()}',
                      rank: state.leaderboardsModels?.rank.toString(),
                      badges: state.leaderboardsModels?.badges.toString(),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.listOfLeaderboardsModels?.length ?? 5,
                        itemBuilder: (context, index) {
                          LeaderboardsModels? leaderboards =
                              state.listOfLeaderboardsModels?[index];
                          return LeaderboardsCards(
                            userName:
                                '@${leaderboards?.username!.toLowerCase()}',
                            badges: leaderboards?.badges,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: Text(
                    "Buat laporan terlebih dahulu untuk melihat peringkat anda"),
              );
            }
          }),
        ),
      ),
    );
  }
}
