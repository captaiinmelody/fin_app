import 'package:fin_app/features/root/bloc/root_bloc.dart';
import 'package:fin_app/features/root/components/hideable_app_bar.dart';
import 'package:fin_app/features/root/ui/profile/components/logout_confirmation.dart';
import 'package:fin_app/features/root/ui/profile/components/profile_app_bar.dart';
import 'package:fin_app/features/root/ui/profile/components/profile_menu_parent.dart';
import 'package:fin_app/routes/route_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    context.read<RootBloc>().add(ProfileEventGetUser());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // Use FutureBuilder to handle async data fetching
            HideableAppBar(
                height: 300,
                child: BlocBuilder<RootBloc, RootState>(
                  builder: (context, state) {
                    if (state is LoadingState) {
                      // Show a loading indicator while waiting for data
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ErrorState) {
                      // Show an error message if data fetching fails
                      return const Text('Error saat pengambilan data');
                    } else if (state is ProfileLoadedState) {
                      // Data fetched successfully, update ProfileAppBar
                      return ProfileAppBar(
                        email: state.userResponseModels!.email,
                        username: state.userResponseModels!.username,
                      );
                    } else {
                      return const Center(
                        child: Text('error'),
                      );
                    }
                  },
                ))
          ];
        },

        //   FutureBuilder<UserResponseModels>(
        //     future: userData, // The future that will resolve to user data
        //     builder: (context, snapshot) {
        //       if (snapshot.connectionState == ConnectionState.waiting) {
        //         // Show a loading indicator while waiting for data
        //         return const Center(child: CircularProgressIndicator());
        //       } else if (snapshot.hasError) {
        //         // Show an error message if data fetching fails
        //         return Text('Error fetching user data');
        //       } else {
        //         // Data fetched successfully, update ProfileAppBar
        //         final userResponse = snapshot.data!;
        //         return ProfileAppBar(
        //           email: userResponse.email,
        //           username: userResponse.username,
        //         );
        //       }
        //     },
        //   ),
        // ),
        body: RefreshIndicator(
          key: refreshIndicatorKey,
          onRefresh: fetchData,
          child: ProfileMenuParent(
            logoutOnTap: () {
              showDialog(
                  context: context,
                  builder: (context) => const LogoutConfirmation());
            },
          ),
        ),
      ),
    );
  }
}
