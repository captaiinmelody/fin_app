import 'package:fin_app/constant/color.dart';
import 'package:fin_app/features/auth/components/auth_button_component.dart';
import 'package:fin_app/features/root/bloc/root_bloc.dart';
import 'package:fin_app/features/root/components/display_media.dart';
import 'package:fin_app/routes/route_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:video_player/video_player.dart';

@immutable
class ReportsCard extends StatefulWidget {
  final RootBloc? rootBloc;

  final String? profilePhotoUrl,
      reportsId,
      username,
      location,
      detailLocation,
      reportsDescription,
      imageUrl,
      videoUrl;
  final int? totalLikes;
  final int? totalComments;
  final DateTime? datePublished;
  final int? status;
  final bool isHomePage;
  final bool isAdmin;

  final Function()? onLikeTap, onCommentTap, viewImage;

  const ReportsCard({
    Key? key,
    this.rootBloc,
    this.profilePhotoUrl,
    this.reportsId,
    this.username,
    this.totalLikes,
    this.totalComments,
    this.datePublished,
    this.location,
    this.detailLocation,
    this.reportsDescription,
    this.imageUrl,
    this.videoUrl,
    this.status,
    this.onLikeTap,
    this.onCommentTap,
    required this.isHomePage,
    this.isAdmin = false,
    this.viewImage,
  }) : super(key: key);

  static const isAlreadyLiking = true;

  @override
  State<ReportsCard> createState() => _ReportsCardState();
}

class _ReportsCardState extends State<ReportsCard> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) => ShowCaseWidget.of(context).startShowCase([
              globalKeyOne,
              globalKeyTwo,
              globalKeyThree,
              globalKeyFour,
              globalKeyFive,
              globalKeySix,
              globalKeySeven,
              globalKeyEight,
              globalKeyNine,
              globalKeyTen,
            ]));
    super.initState();
  }

  String getFormattedTimeSince(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays >= 7) {
      return '${difference.inDays ~/ 7} minggu yang lalu';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menid yang lalu';
    } else {
      return '${difference.inSeconds} detik yang lalu';
    }
  }

  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final formattedTimeSince = widget.datePublished != null
        ? getFormattedTimeSince(widget.datePublished!)
        : 'No Date';

    ButtonStyle beforeClicked = ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryColor,
      minimumSize: Size(size.width * 0.8, 46),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    );

    ButtonStyle afterClicked = ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      minimumSize: Size(size.width * 0.8, 46),
      side: const BorderSide(width: 4, color: AppColors.primaryColor),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    );
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Showcase(
            key: globalKeyOne,
            title: 'Foto profil',
            description: '',
            child: CircleAvatar(
              radius: 24.0,
              child: ClipOval(
                child: Image.network(
                  widget.profilePhotoUrl ??
                      'https://upload.wikimedia.org/wikipedia/commons/b/bc/Unknown_person.jpg',
                  fit: BoxFit
                      .cover, // You can adjust the fit as per your requirement
                  width: 48.0, // Set the desired width for the image
                  height: 48.0, // Set the desired height for the image
                ),
              ),
            ),
          ),
          const SizedBox(width: 16.0),
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
                        Showcase(
                          key: globalKeyTwo,
                          title: 'Nama anda',
                          description: '',
                          child: Text(
                            "@${widget.username!.toLowerCase()}",
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Showcase(
                          key: globalKeyThree,
                          title: 'Lokasi Pelaporan',
                          description:
                              'Kiri merupakan lokasi kampus dan Kanan merupakan detail lokasi',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Text(
                                  "${widget.location!.toLowerCase()} | ${widget.detailLocation!.toLowerCase()}",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.0,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Showcase(
                      key: globalKeyFour,
                      title: 'Status Pelaporan',
                      description: '',
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 12),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black45, width: 2),
                            borderRadius: BorderRadius.circular(8),
                            color: widget.status == 0
                                ? Colors.red
                                : widget.status == 1
                                    ? AppColors.primaryColor
                                    : Colors.green),
                        child: Center(
                          child: Text(
                            widget.status == 0
                                ? "Dilaporkan"
                                : widget.status == 1
                                    ? "Terkonfirmasi"
                                    : "Telah diperbaiki",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12.0),
                Showcase(
                  key: globalKeyFive,
                  title: 'Deskripsi pelaporan',
                  description: '',
                  child: Text(
                    widget.reportsDescription ?? 'tidak ada data',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ),
                const SizedBox(height: 12.0),
                Showcase(
                  key: globalKeySix,
                  title: 'Tampilan gambar dan atau video',
                  description:
                      'Tap gambar untuk memperbesar, jika terdapat gambar dan video anda bisa menggesernya untuk menampilkannya',
                  child: DisplayMedia(
                    imageUrl: widget.imageUrl,
                    videoUrl: widget.videoUrl,
                    dataSourceType: DataSourceType.network,
                  ),
                ),
                widget.isHomePage
                    ? const SizedBox(height: 24.0)
                    : const SizedBox(height: 12.0),
                if (widget.isHomePage)
                  Showcase(
                    key: globalKeySeven,
                    title: 'Suka, Berbagi, Komentar',
                    description: '',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: widget.onLikeTap,
                              splashColor: Colors.grey.withOpacity(0.25),
                              child: ReportsCard.isAlreadyLiking
                                  ? const Icon(Icons.favorite,
                                      color: Colors.red)
                                  : const Icon(Icons.favorite_outline,
                                      color: Colors.red),
                            ),
                            const SizedBox(width: 4.0),
                            Text(widget.totalLikes.toString()),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.share, color: Colors.green),
                            const SizedBox(width: 4.0),
                            Text(widget.totalLikes.toString()),
                          ],
                        ),
                        Row(
                          children: [
                            InkWell(
                                onTap: widget.onCommentTap,
                                splashColor: Colors.grey.withOpacity(0.25),
                                child: const Icon(Icons.comment,
                                    color: Colors.blue)),
                            const SizedBox(width: 4.0),
                            Text(widget.totalComments.toString()),
                          ],
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 12.0),
                Showcase(
                  key: globalKeyEight,
                  title: 'Durasi laporan',
                  description: 'Menampilkan sejak kapan laporan dibuat',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formattedTimeSince,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12.0),

                //if the role is admin
                if (widget.isAdmin)
                  widget.status == 0
                      ? Showcase(
                          key: globalKeyNine,
                          title: 'Perbaharui laporan',
                          description:
                              'Tekan tombol untuk memperbaharui laporan',
                          child: BlocConsumer<RootBloc, RootState>(
                            listener: (context, state) {
                              if (state is ButtonLoadedState) {
                                setState(() {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text(
                                          'Laporan telah terkonfirmasi, tolong segarkan halaman untuk memperbarui data'),
                                    ),
                                  );

                                  isClicked = true;
                                });
                              }
                            },
                            builder: (context, state) {
                              if (state is ButtonLoadingState) {
                                return Center(
                                  child: LoadingAnimationWidget
                                      .horizontalRotatingDots(
                                          color: AppColors.primaryColor,
                                          size: 20),
                                );
                              }
                              if (isClicked == false) {
                                return AuthButton(
                                  onTap: () {
                                    setState(() {
                                      isClicked = true;
                                    });
                                    widget.rootBloc!.add(
                                      AdminConfirmingReportsEvent(
                                        widget.reportsId!,
                                      ),
                                    );
                                  },
                                  textButton: 'Konfirmasi',
                                  buttonStyle: beforeClicked,
                                  textStyle: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                );
                              } else {
                                return AuthButton(
                                  onTap: () {},
                                  textButton: 'Terkonfirmasi',
                                  buttonStyle: afterClicked,
                                  textStyle: const TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 20,
                                  ),
                                );
                              }
                            },
                          ),
                        )
                      : widget.status == 1
                          ? Showcase(
                              key: globalKeyTen,
                              title: 'Perbaharui laporan',
                              description:
                                  'Tekan tombol untuk memperbaharui laporan',
                              child: BlocConsumer<RootBloc, RootState>(
                                listener: (context, state) {
                                  if (state is ButtonLoadedState) {
                                    setState(() {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          backgroundColor: Colors.green,
                                          content: Text(
                                              'Laporan telah diperbaiki, tolong segarkan halaman untuk memperbarui data'),
                                        ),
                                      );

                                      isClicked = true;
                                    });
                                  }
                                },
                                builder: (context, state) {
                                  if (state is ButtonLoadingState) {
                                    return Center(
                                      child: LoadingAnimationWidget
                                          .horizontalRotatingDots(
                                              color: AppColors.primaryColor,
                                              size: 20),
                                    );
                                  }
                                  if (isClicked == false) {
                                    return AuthButton(
                                      onTap: () {
                                        setState(() {
                                          isClicked = true;
                                        });
                                        widget.rootBloc!.add(
                                          AdminConfirmingReportsEvent(
                                            widget.reportsId!,
                                          ),
                                        );
                                      },
                                      textButton: 'Perbaiki sekarang',
                                      buttonStyle: beforeClicked,
                                      textStyle: const TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    );
                                  } else {
                                    return Showcase(
                                      key: globalKeyNine,
                                      title: 'Laporan berhasil di perbaharui',
                                      description: '',
                                      child: AuthButton(
                                        onTap: () {},
                                        textButton: 'Telah diperbaiki',
                                        buttonStyle: afterClicked,
                                        textStyle: const TextStyle(
                                          color: AppColors.primaryColor,
                                          fontSize: 20,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            )
                          : Container()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
