import 'package:fin_app/features/firebase/auth/data/models/response/user_response_models.dart';
import 'package:fin_app/features/root/bloc/root_bloc.dart';
import 'package:fin_app/features/root/components/hideable_app_bar.dart';
import 'package:fin_app/features/root/ui/leaderboards/components/leaderboards_card.dart';
import 'package:fin_app/features/root/ui/leaderboards/components/leaderboards_card_skeleton.dart';
import 'package:fin_app/routes/route_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class LeaderboardsPage extends StatefulWidget {
  const LeaderboardsPage({super.key});

  @override
  State<LeaderboardsPage> createState() => _LeaderboardsPageState();
}

class _LeaderboardsPageState extends State<LeaderboardsPage> {
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
                title: "Leaderboards",
                onPressed: () {},
              ),
            ];
          },
          body: RefreshIndicator(
            key: refreshIndicatorKey,
            onRefresh: fetchData,
            child: BlocBuilder<RootBloc, RootState>(
              builder: (context, state) {
                if (state is LoadingState) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.withOpacity(0.5),
                    highlightColor: Colors.white,
                    child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return const LeaderboardsCardsSkeleton();
                      },
                    ),
                  );
                } else if (state is LoadedState) {
                  return ListView.builder(
                    itemCount: state.userResponseModels!.length,
                    itemBuilder: (context, index) {
                      UserResponseModels userResponseModels =
                          state.userResponseModels![index];
                      return LeaderboardsCards(
                        profilePhoto: userResponseModels.profilePhotoUrl,
                        userName: userResponseModels.username,
                        badges: userResponseModels.badges,
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          )),
    );
  }
}
