import 'package:fin_app/constant/text_styles.dart';
import 'package:fin_app/features/root/bloc/root_bloc.dart';
import 'package:fin_app/features/root/components/hideable_app_bar.dart';
import 'package:fin_app/features/root/data/models/leaderboards_models.dart';
import 'package:fin_app/features/root/ui/leaderboards/components/leaderboards_card.dart';
import 'package:fin_app/features/root/ui/leaderboards/components/leaderboards_card_skeleton.dart';
import 'package:fin_app/features/root/ui/leaderboards/components/users_rank.dart';
import 'package:fin_app/routes/route_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:showcaseview/showcaseview.dart';

class LeaderboardsPage extends StatefulWidget {
  const LeaderboardsPage({super.key});

  @override
  State<LeaderboardsPage> createState() => _LeaderboardsPageState();
}

class _LeaderboardsPageState extends State<LeaderboardsPage> {
  @override
  void initState() {
    fetchData();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) =>
        ShowCaseWidget.of(context).startShowCase([globalKeyOne]));
    super.initState();
  }

  Future<void> fetchData() async {
    context.read<RootBloc>().add(LeaderboardsEvent());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
              return Shimmer.fromColors(
                baseColor: Colors.grey.withOpacity(0.5),
                highlightColor: Colors.white,
                child: Column(
                  children: [
                    Container(
                      width: size.width,
                      height: 20,
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    ListView.builder(
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return const LeaderboardsCardsSkeleton();
                      },
                    ),
                  ],
                ),
              );
            } else if (state is LeaderboardsLoadedState) {
              return Showcase(
                key: globalKeyOne,
                title: 'Informasi peringkat anda',
                description: '',
                child: Container(
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
                          itemCount:
                              state.listOfLeaderboardsModels?.length ?? 5,
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
