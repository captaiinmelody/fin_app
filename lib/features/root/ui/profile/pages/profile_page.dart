import 'package:fin_app/features/root/bloc/root_bloc.dart';
import 'package:fin_app/features/root/components/confirmation_modal.dart';
import 'package:fin_app/features/root/components/hideable_app_bar.dart';
import 'package:fin_app/features/root/ui/profile/components/profile_app_bar.dart';
import 'package:fin_app/features/root/ui/profile/components/profile_menu_parent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> fetchData() async {
    context.read<RootBloc>().add(GetProfileEvent());
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
            onRefresh: fetchData,
            child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                HideableAppBar(
                    height: 300,
                    child: BlocBuilder<RootBloc, RootState>(
                        builder: (context, state) {
                      if (state is ProfileState &&
                          state.isLoading &&
                          !state.isError) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ProfileState &&
                          !state.isLoading &&
                          state.isError) {
                        return const Text('Error saat pengambilan data');
                      } else if (state is ProfileState &&
                          !state.isLoading &&
                          !state.isError) {
                        return ProfileAppBar(
                            email: state.userResponseModels!.email,
                            jabatan: state.userResponseModels!.jabatan,
                            username: state.userResponseModels!.username);
                      } else {
                        return const Center(child: Text('error'));
                      }
                    }))
              ];
            }, body: ProfileMenuParent(logoutOnTap: () {
              showDialog(
                  context: context,
                  builder: (context) => const ConfirmationModal());
            }))));
  }
}
