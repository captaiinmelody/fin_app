// import 'package:fin_app/constant/color.dart';
// import 'package:fin_app/features/auth/data/localresources/auth_local_storage.dart';
// import 'package:fin_app/features/root/bloc/root_bloc.dart';
// import 'package:fin_app/features/root/components/reports_card.dart';
// import 'package:fin_app/routes/route_config.dart';
// import 'package:fin_app/routes/route_const.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';

// class ReportsDetailPage extends StatefulWidget {
//   final String reportsId;
//   const ReportsDetailPage({super.key, required this.reportsId});

//   @override
//   State<ReportsDetailPage> createState() => _ReportsDetailPageState();
// }

// class _ReportsDetailPageState extends State<ReportsDetailPage> {
//   RootBloc rootBloc = RootBloc(
//       adminReportsDataSources: adminReportsDataSources,
//       reportsDataSources: reportsDataSources,
//       notificationSources: notificationSources);
//   String? currentRole;

//   Future<void> getRole() async {
//     final role = await AuthLocalStorage().getRole();

//     currentRole = role;
//   }

//   Future<void> fetchData() async {
//     await getRole();
//     rootBloc.add(GetReportsDetailEvent(widget.reportsId));
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Detail Pelaporan'),
//           centerTitle: true,
//           leading: Builder(
//             builder: (context) {
//               return IconButton(
//                 icon: const Icon(Icons.arrow_back),
//                 onPressed: () {
//                   GoRouter.of(context).goNamed(MyRouterConstant.rootRouterName);
//                   GoRouter.of(context).pop();
//                 },
//               );
//             },
//           ),
//         ),
//         body: BlocProvider(
//             create: (context) => rootBloc,
//             child: BlocBuilder<RootBloc, RootState>(
//               builder: (context, state) {
//                 if (state is LoadingState) {
//                   return Center(
//                       child: LoadingAnimationWidget.horizontalRotatingDots(
//                           color: AppColors.primaryColor, size: 24));
//                 } else if (state is ReportsDetailState) {
//                   final content = state.reportsModel;
//                   return ReportsCard(
//                     reportsId: content.reportsId,
//                     rootBloc: rootBloc,
//                     username: content.userData!.username,
//                     jabatan: content.userData!.jabatan,
//                     profilePhotoUrl: content.userData!.profilePhotoUrl,
//                     reportsDescription: content.reportsData!.reportsDescription,
//                     fixedDescription: content.reportsData!.fixedDescription,
//                     campus: content.reportsData!.campus,
//                     location: content.reportsData!.location,
//                     status: content.reportsData?.status,
//                     imageUrls: content.mediaUrl?.imageUrls,
//                     videoUrl: content.mediaUrl?.videoUrl,
//                     fixedImageUrls: content.mediaUrl?.fixedImageUrls,
//                     fixedVideoUrl: content.mediaUrl?.fixedVideoUrl,
//                     datePublished: content.datePublished,
//                     fixedDate: content.updatedAt,
//                     role: currentRole!,
//                     fetchData: () {
//                       fetchData();
//                     },
//                   );
//                 } else {
//                   return const Center(
//                     child: Text(
//                         "Data berhasil dikonfirmasi, kembari ke halaman utama"),
//                   );
//                 }
//               },
//             )));
//   }
// }
