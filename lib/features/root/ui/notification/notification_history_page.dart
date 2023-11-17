// import 'package:fin_app/constant/color.dart';
// import 'package:fin_app/features/root/components/custom_button.dart';
// import 'package:fin_app/features/auth/data/localresources/auth_local_storage.dart';
// import 'package:fin_app/features/root/bloc/root_bloc.dart';
// import 'package:fin_app/features/root/ui/reports/pages/reports_detail_page.dart';
// import 'package:fin_app/routes/route_const.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:intl/intl.dart';
// import 'package:intl/date_symbol_data_local.dart';

// class NotificationHistory extends StatefulWidget {
//   const NotificationHistory({super.key});

//   @override
//   State<NotificationHistory> createState() => _NotificationHistoryState();
// }

// class _NotificationHistoryState extends State<NotificationHistory> {
//   String? currentRole;
//   Future<void> fetchData() async {
//     final userId = await AuthLocalStorage().getUserId();
//     final role = await AuthLocalStorage().getRole();

//     currentRole = role;
//     // ignore: use_build_context_synchronously
//     context.read<RootBloc>().add(GetNotificationHistoryEvent(userId));
//   }

//   @override
//   void initState() {
//     fetchData();
//     initializeDateFormatting('id_ID', null);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Riwayat Notifikasi'),
//           centerTitle: true,
//           leading: Builder(
//             builder: (context) {
//               return IconButton(
//                 icon: const Icon(Icons.arrow_back),
//                 onPressed: () {
//                   context.goNamed(MyRouterConstant.homeRouterName);
//                 },
//               );
//             },
//           ),
//         ),
//         body: BlocBuilder<RootBloc, RootState>(
//           builder: (context, state) {
//             if (state is NotificationState &&
//                 state.isLoading &&
//                 !state.isError) {
//               return Center(
//                   child: LoadingAnimationWidget.horizontalRotatingDots(
//                       color: AppColors.primaryColor, size: 24));
//             } else if (state is NotificationState &&
//                 !state.isLoading &&
//                 !state.isError) {
//               return RefreshIndicator(
//                 onRefresh: fetchData,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8),
//                   child: ListView.builder(
//                     itemCount: state.listNotification?.length,
//                     itemBuilder: (context, index) {
//                       final data = state.listNotification?[index];
//                       return Container(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 8, horizontal: 12),
//                         margin: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           boxShadow: [
//                             BoxShadow(
//                                 color: Colors.grey
//                                     .withOpacity(0.5), // Shadow color
//                                 spreadRadius: 2,
//                                 blurRadius: 5,
//                                 offset: const Offset(0, 3)),
//                           ],
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     data?.notification?.title ??
//                                         "tidak ada data",
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 20,
//                                         color: Colors.black),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   SizedBox(
//                                     width:
//                                         MediaQuery.of(context).size.width * 0.6,
//                                     child: Text(
//                                       data?.notification?.body ??
//                                           "tidak ada data",
//                                       style: const TextStyle(
//                                         fontSize: 16,
//                                         color: Colors.black54,
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                       "${DateFormat('EEEE, M/d/y, HH:mm', 'id_ID').format(data!.createdAt!)} ${data.createdAt!.timeZoneName}",
//                                       style: const TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.black45,
//                                       )),
//                                 ]),
//                             CustomButton(
//                               width: MediaQuery.of(context).size.width * 0.2,
//                               textButton: "Detail",
//                               onTap: () {
//                                 showDialog(
//                                   context: context,
//                                   builder: (context) {
//                                     return ReportsDetailPage(
//                                         reportsId: data.data!.reportsId!);
//                                   },
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               );
//             } else if (state is NotificationState &&
//                 !state.isLoading &&
//                 state.isError) {
//               return RefreshIndicator(
//                 onRefresh: fetchData,
//                 child: Center(
//                   child: Text(state.message!),
//                 ),
//               );
//             } else {
//               return RefreshIndicator(
//                 onRefresh: fetchData,
//                 child: const Center(
//                   child: Text("An error occurred when fetching the data..."),
//                 ),
//               );
//             }
//           },
//         ));
//   }
// }
