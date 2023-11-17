import 'package:fin_app/constant/color.dart';
import 'package:fin_app/features/root/components/custom_button.dart';
import 'package:fin_app/features/root/bloc/root_bloc.dart';
import 'package:fin_app/features/root/components/confirmation_modal.dart';
import 'package:fin_app/features/root/components/display_media.dart';
import 'package:fin_app/features/root/data/localstorage/root_local_storage.dart';
import 'package:fin_app/features/root/ui/reports/pages/reports_page.dart';
import 'package:fin_app/routes/route_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:video_player/video_player.dart';

@immutable
class ReportsCard extends StatefulWidget {
  final RootBloc? rootBloc;
  final String? profilePhotoUrl,
      reportsId,
      username,
      jabatan,
      campus,
      location,
      reportsDescription,
      fixedDescription,
      videoUrl,
      fixedVideoUrl,
      status;
  final List<String?>? imageUrls, fixedImageUrls;
  final DateTime? datePublished, fixedDate;
  final String role;
  final Function()? fetchData;
  const ReportsCard({
    Key? key,
    this.rootBloc,
    this.profilePhotoUrl,
    this.reportsId,
    this.username,
    this.jabatan,
    this.datePublished,
    this.fixedDate,
    this.campus,
    this.location,
    this.reportsDescription,
    this.imageUrls,
    this.videoUrl,
    this.fixedImageUrls,
    this.fixedVideoUrl,
    this.status,
    this.role = "reporter",
    this.fetchData,
    this.fixedDescription,
  }) : super(key: key);

  static const isAlreadyLiking = true;

  @override
  State<ReportsCard> createState() => _ReportsCardState();
}

class _ReportsCardState extends State<ReportsCard> {
  @override
  void initState() {
    super.initState();
  }

  String getFormattedTimeSince(DateTime dateTime, String label) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays >= 31) {
      return '$label ${difference.inDays ~/ 31} bulan yang lalu';
    } else if (difference.inDays >= 7) {
      return '$label ${difference.inDays} minggu yang lalu';
    } else if (difference.inDays > 0) {
      return '$label ${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 0) {
      return '$label ${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      return '$label ${difference.inMinutes} menit yang lalu';
    } else {
      return '$label ${difference.inSeconds} detik yang lalu';
    }
  }

  bool isClicked = false;
  String buttonStatus = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final reportsCreatedAt = widget.datePublished != null
        ? getFormattedTimeSince(widget.datePublished!, "Laporan diunggah ")
        : 'No Date';
    final reportsFixedAt = widget.fixedDate != null
        ? getFormattedTimeSince(widget.fixedDate!, "Fasilitas diperbaiki ")
        : 'No Date';

    ButtonStyle declineButton = ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        minimumSize: Size(size.width * 0.3, 46),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))));
    ButtonStyle confirmButton = ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        minimumSize: Size(size.width * 0.3, 46),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))));
    ButtonStyle afterClicked = ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: Size(size.width * 0.8, 46),
        side: const BorderSide(width: 4, color: AppColors.primaryColor),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))));
    return Container(
        padding: const EdgeInsets.only(top: 12, left: 14.0, right: 20.0),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CircleAvatar(
              radius: 24.0,
              child: ClipOval(
                  child: Image.network(
                      widget.profilePhotoUrl ??
                          'https://upload.wikimedia.org/wikipedia/commons/b/bc/Unknown_person.jpg',
                      fit: BoxFit.cover,
                      width: 48.0,
                      height: 48.0))),
          const SizedBox(width: 14.0),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "${widget.username!.split(" ").first.toLowerCase()} | ${widget.jabatan!.toLowerCase()}",
                                style: const TextStyle(fontSize: 18.0)),
                            const SizedBox(height: 6),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.location_on_outlined,
                                      size: 14, color: Colors.grey),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Text(
                                          "${widget.campus!.toLowerCase()} | ${widget.location!.toLowerCase()}",
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14.0),
                                          maxLines: 2))
                                ])
                          ]),
                      Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 12),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black45, width: 2),
                              borderRadius: BorderRadius.circular(8),
                              color: widget.status == "rejected"
                                  ? Colors.red
                                  : widget.status == "reported"
                                      ? AppColors.primaryColor
                                      : widget.status == "confirmed"
                                          ? AppColors.primaryColor
                                          : Colors.green),
                          child: Center(
                              child: Text(
                                  widget.status == "rejected"
                                      ? "Ditolak"
                                      : widget.status == "reported"
                                          ? "Dilaporkan"
                                          : widget.status == "confirmed"
                                              ? "Terkonfirmasi"
                                              : "Telah diperbaiki",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16))))
                    ]),
                const SizedBox(height: 12.0),
                Text(widget.reportsDescription ?? 'tidak ada data',
                    style: const TextStyle(fontSize: 18.0)),
                const SizedBox(height: 12.0),
                DisplayMedia(
                    imageUrls: widget.imageUrls,
                    videoUrl: widget.videoUrl,
                    dataSourceType: DataSourceType.network),
                const SizedBox(height: 12.0),
                Text(reportsCreatedAt,
                    style: const TextStyle(color: Colors.grey)),
                if (widget.fixedImageUrls != null &&
                        widget.fixedImageUrls! != [] &&
                        widget.fixedImageUrls!.first!.startsWith("http") ||
                    widget.fixedVideoUrl != null &&
                        widget.fixedVideoUrl!.startsWith('http'))
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        const Text("Kondisi setelah diperbaiki:",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green)),
                        const SizedBox(height: 12),
                        Text(widget.fixedDescription ?? 'tidak ada data',
                            style: const TextStyle(fontSize: 18.0)),
                        const SizedBox(height: 12),
                        DisplayMedia(
                            imageUrls: widget.fixedImageUrls,
                            videoUrl: widget.fixedVideoUrl,
                            dataSourceType: DataSourceType.network),
                        const SizedBox(height: 12),
                        Text(reportsFixedAt,
                            style: const TextStyle(color: Colors.grey))
                      ]),
                const SizedBox(height: 12.0),
                if (widget.role == "admin" && widget.status == "reported")
                  BlocConsumer<RootBloc, RootState>(listener: (context, state) {
                    if (state is ButtonState) {
                      setState(() {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text(
                                'Laporan telah terkonfirmasi, tolong segarkan halaman untuk memperbarui data')));
                        isClicked = true;
                        buttonStatus = "ditolak";
                      });
                    }
                  }, builder: (context, state) {
                    if (state is ButtonState &&
                        state.isLoading &&
                        !state.isError) {
                      return Center(
                          child: LoadingAnimationWidget.horizontalRotatingDots(
                              color: AppColors.primaryColor, size: 20));
                    }
                    if (!isClicked) {
                      return Column(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomButton(
                                  onTap: () async {
                                    setState(() {
                                      isClicked = true;
                                      buttonStatus = "ditolak";
                                    });
                                    widget.rootBloc!.add(ConfirmingReportsEvent(
                                        widget.reportsId!, "rejected", "user"));
                                  },
                                  textButton: 'Tolak',
                                  buttonStyle: declineButton,
                                  textStyle: const TextStyle(
                                      color: Colors.white, fontSize: 20)),
                              CustomButton(
                                  onTap: () {
                                    setState(() {
                                      isClicked = true;
                                      buttonStatus = "dikonfirmasi";
                                    });
                                    widget.rootBloc!.add(ConfirmingReportsEvent(
                                        widget.reportsId!,
                                        "confirmed",
                                        widget.campus == "Kampus 1"
                                            ? "krt_kampus_1"
                                            : widget.campus == "Kampus 2"
                                                ? "krt_kampus_2"
                                                : widget.campus == "Kampus 3"
                                                    ? "krt_kampus_3"
                                                    : widget.campus ==
                                                            "Kampus 4"
                                                        ? "krt_kampus_4"
                                                        : widget.campus ==
                                                                "Kampus 5"
                                                            ? "krt_kampus_5"
                                                            : "krt_kampus_6"));
                                  },
                                  textButton: 'Konfirmasi',
                                  buttonStyle: confirmButton,
                                  textStyle: const TextStyle(
                                      color: Colors.white, fontSize: 20))
                            ]),
                        SizedBox(height: 12),
                        CustomButton(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => ConfirmationModal(
                                      title: 'Hapus Laporan',
                                      description:
                                          'Anda yakin ingin menghapus laporan?',
                                      onPressed: () {
                                        setState(() {
                                          widget.rootBloc!.add(
                                              DeleteReportsEvent(
                                                  widget.reportsId!));
                                        });
                                        GoRouter.of(context).pop();
                                        widget.fetchData;
                                      }));
                            },
                            textButton: 'Hapus',
                            buttonStyle: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                minimumSize: Size(size.width * 0.8, 46),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)))),
                            textStyle: const TextStyle(
                                color: Colors.white, fontSize: 20))
                      ]);
                    } else {
                      return CustomButton(
                          onTap: () {},
                          textButton: buttonStatus,
                          buttonStyle: afterClicked,
                          textStyle: const TextStyle(
                              color: AppColors.primaryColor, fontSize: 20));
                    }
                  }),
                if (widget.role.startsWith('krt') &&
                    widget.status == "confirmed")
                  BlocConsumer<RootBloc, RootState>(listener: (context, state) {
                    if (state is ButtonState) {
                      setState(() {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text(
                                'Laporan telah diperbaiki, tolong segarkan halaman untuk memperbarui data')));
                        isClicked = true;
                      });
                    }
                  }, builder: (context, state) {
                    if (state is ButtonState &&
                        state.isLoading &&
                        !state.isError) {
                      return Center(
                          child: LoadingAnimationWidget.horizontalRotatingDots(
                              color: AppColors.primaryColor, size: 20));
                    }
                    return CustomButton(
                        onTap: () async {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return ShowCaseWidget(
                                    onComplete: (p0, p1) async {
                                  if (p0 == 1) {
                                    await RootLocalStorgae()
                                        .adminReportsPageShowCase(true);
                                  }
                                }, builder: Builder(builder: (context) {
                                  return ReportsPage(
                                      rootBloc: rootBloc,
                                      role: widget.role,
                                      reportsId: widget.reportsId!);
                                }));
                              });
                        },
                        textButton: 'Konfirmasi Perbaikan',
                        buttonStyle: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            minimumSize: Size(size.width * 0.8, 46),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
                        textStyle:
                            const TextStyle(color: Colors.white, fontSize: 20));
                  })
              ]))
        ]));
  }
}
