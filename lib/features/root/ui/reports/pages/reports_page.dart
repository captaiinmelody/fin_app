import 'dart:io';
import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:fin_app/constant/color.dart';
import 'package:fin_app/features/root/components/custom_form.dart';
import 'package:fin_app/features/auth/data/localresources/auth_local_storage.dart';
import 'package:fin_app/features/root/bloc/root_bloc.dart';
import 'package:fin_app/features/root/components/display_image.dart';
import 'package:fin_app/features/root/components/display_video.dart';
import 'package:fin_app/features/root/components/show_case_view.dart';
import 'package:fin_app/features/root/data/localstorage/root_local_storage.dart';
import 'package:fin_app/features/root/ui/reports/components/button_media.dart';
import 'package:fin_app/features/root/components/dropdown_field.dart';
import 'package:fin_app/routes/route_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:video_compress_plus/video_compress_plus.dart';
import 'package:video_player/video_player.dart';

class ReportsPage extends StatefulWidget {
  final RootBloc rootBloc;
  final String role;
  final String reportsId;
  const ReportsPage({
    Key? key,
    required this.rootBloc,
    required this.role,
    required this.reportsId,
  }) : super(key: key);

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final ImagePicker picker = ImagePicker();
  List<File?>? imageFiles;
  File? videoFiles;
  PlatformFile? profilePhoto;
  String? selectedCampus;
  int currentPage = 0;
  double? heightPhoto;
  double? widthPhoto;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationDetailController = TextEditingController();
  PageController pageController = PageController(initialPage: 0);

  Future<void> selectVideo() async {
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false, type: FileType.video, allowCompression: true);
    final selectedFile = File(result!.files.single.path!);
    final videoPlayerController = VideoPlayerController.file(selectedFile);
    await videoPlayerController.initialize();
    final duration = videoPlayerController.value.duration;
    await videoPlayerController.dispose();
    const maxDurationInSeconds = 60;
    if (duration.inSeconds <= maxDurationInSeconds) {
      final compressedVideo = await compressVideo(selectedFile);
      setState(() {
        videoFiles = compressedVideo;
      });
    } else {
      showVideoDurationError();
    }
  }

  void showVideoDurationError() {
    const snackBar = SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          'Video yang dipilih harus dibawah 1 menit.',
          style: TextStyle(fontSize: 18),
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> recordVideoFromCamera() async {
    final pickedFile = await picker.pickVideo(
        source: ImageSource.camera, maxDuration: const Duration(minutes: 1));
    final videoFile = File(pickedFile!.path);
    setState(() {
      videoFiles = videoFile;
    });
  }

  Future<void> captureImageFromCamera() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    if (pickedFile == null) return; // Cancelled

    final selectedImage = File(pickedFile.path);

    final compressedImage = await compressImage(selectedImage);

    setState(() {
      imageFiles ??= [];
      imageFiles!.add(compressedImage);
    });
  }

  Future<void> selectImage() async {
    const maxAllowedFiles = 3;

    final result = await FilePicker.platform.pickFiles(
        allowMultiple: true, type: FileType.image, allowCompression: true);
    if (result == null) return;
    final selectedFiles =
        result.files.map((platformFile) => File(platformFile.path!)).toList();

    final compressedImages = await Future.wait(
        selectedFiles.map((selectedFile) => compressImage(selectedFile)));

    setState(() {
      imageFiles ??= [];
      if (imageFiles!.length + compressedImages.length > maxAllowedFiles) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text("Gambar tidak bisa lebih dari 3")));
        final excessCount =
            imageFiles!.length + compressedImages.length - maxAllowedFiles;
        compressedImages.removeRange(
            compressedImages.length - excessCount, compressedImages.length);
      }
      imageFiles!.addAll(compressedImages);
    });
  }

  Future<File?> compressVideo(File videoFile) async {
    try {
      final compressedData = await VideoCompress.compressVideo(
        videoFile.path,
        quality: VideoQuality.LowQuality,
        deleteOrigin: false,
      );
      return compressedData!.file;
    } catch (e) {
      return null;
    }
  }

  Future<File?> compressImage(File imageFile) async {
    try {
      final compressedData = await FlutterImageCompress.compressWithFile(
          imageFile.path,
          quality: 30);
      final compressedImage = File(imageFile.path)
        ..writeAsBytesSync(compressedData!);
      return compressedImage;
    } catch (e) {
      return null;
    }
  }

  startShowCase() async {
    final getReportsShowCase =
        await RootLocalStorgae().getReportsPageShowCase();

    if (getReportsShowCase == false) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        ShowCaseWidget.of(context)
            .startShowCase([key3, key4, key5, key6, key7]);
      });
    }
  }

  adminStartShowCase() async {
    final getAdminReportsShowCase =
        await RootLocalStorgae().getAdminReportsPageShowCase();

    if (getAdminReportsShowCase == false) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        ShowCaseWidget.of(context)
            .startShowCase([key3, key4, key5, key6, key7]);
      });
    }
  }

  String? currentRole;

  getRole() async {
    final role = await AuthLocalStorage().getRole();
    setState(() {
      currentRole = role;
    });
  }

  initGetRole() async {
    await getRole();
    if (currentRole!.startsWith("krt")) {
      adminStartShowCase();
    } else {
      startShowCase();
    }
  }

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        currentPage = pageController.page!.round();
      });
    });
    initGetRole();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar(context),
        body: reportsPage(size));
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
        actions: [
          Container(
              margin: const EdgeInsets.only(right: 16),
              child: BlocConsumer<RootBloc, RootState>(
                  bloc: widget.rootBloc,
                  listener: (context, state) {
                    if (state is CreateReportsState &&
                        !state.isLoading &&
                        !state.isError) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(state.message.toString())));
                      setState(() {
                        imageFiles = null;
                        videoFiles = null;
                      });

                      GoRouter.of(context).pop();
                    } else if (state is CreateReportsState &&
                        !state.isLoading &&
                        state.isError) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.redAccent,
                          content: Text(
                            state.message!,
                            style: TextStyle(fontSize: 18),
                          )));
                    }
                  },
                  builder: (context, state) {
                    if (state is CreateReportsState &&
                        state.isLoading &&
                        !state.isError) {
                      return Center(
                          child: LoadingAnimationWidget.horizontalRotatingDots(
                              color: AppColors.primaryColor, size: 20));
                    }
                    return ShowCaseView(
                        globalKey: key7,
                        description: 'Tekan tombol ini untuk melakukan laporan',
                        child: Builder(builder: (context) {
                          return ElevatedButton(
                              onPressed: () {
                                if (widget.role == "reporter") {
                                  widget.rootBloc.add(CreateReportsEvent(
                                    description: descriptionController.text,
                                    imageFiles: imageFiles,
                                    videoFiles: videoFiles,
                                    kampus: selectedCampus,
                                    detailLokasi: locationDetailController.text,
                                  ));
                                } else {
                                  widget.rootBloc.add(ConfirmingFixingEvent(
                                    description: descriptionController.text,
                                    imageFiles: imageFiles,
                                    videoFiles: videoFiles,
                                    reportsId: widget.reportsId,
                                  ));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor),
                              child: Text(
                                  currentRole!.startsWith("krt")
                                      ? "Konfirmasi"
                                      : 'Laporkan',
                                  style: const TextStyle(color: Colors.white)));
                        }));
                  }))
        ],
        leading: IconButton(
            onPressed: () {
              GoRouter.of(context).pop();
            },
            icon: const Icon(Icons.close, size: 36)));
  }

  SingleChildScrollView reportsPage(Size size) {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  width: size.width,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShowCaseView(
                            globalKey: key3,
                            description:
                                'Tambahkan deskripsi pelaporan seperti kondisi kerusakan, tingkat urgensi, dll',
                            child: Builder(builder: (context) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextField(
                                      controller: descriptionController,
                                      maxLines: null,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Deskripsi pelaporan',
                                      )),
                                  const Text(
                                      "*Contoh: Beberapa bangku kakinya patah",
                                      style: TextStyle(
                                        color: Colors.red,
                                      )),
                                  const SizedBox(height: 24)
                                ],
                              );
                            })),
                        displayMedia(),
                        const SizedBox(height: 24),
                        ShowCaseView(
                            globalKey: key4,
                            description:
                                'Tambahkan gambar atau video untuk memperjelas pelaporan',
                            child: Builder(builder: (context) {
                              return ButtonMedia(
                                  imageFile: imageFiles,
                                  videoFile: videoFiles,
                                  onSelectImageTap: () {
                                    selectImage();
                                  },
                                  onSelectVideoTap: () {
                                    selectVideo();
                                  },
                                  onTakeImageTap: () async {
                                    captureImageFromCamera();
                                  },
                                  onTakeVideoTap: () async {
                                    recordVideoFromCamera();
                                  });
                            })),
                        if (widget.role == "reporter")
                          Column(children: [
                            Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: ShowCaseView(
                                    globalKey: key5,
                                    description:
                                        'Pilih di kampus mana kerusakan fasilitas terjadi',
                                    child: Builder(builder: (context) {
                                      return DropdownField(
                                          page: "pembuatan_laporan",
                                          labelText: 'Pilih Kampus',
                                          icon: const Icon(
                                              Icons.apartment_outlined),
                                          isEnabled: false,
                                          onChanged: (selectedValue) {
                                            setState(() {
                                              selectedCampus = selectedValue;
                                            });
                                          });
                                    }))),
                            Container(
                                margin: const EdgeInsets.only(top: 24),
                                child: ShowCaseView(
                                    globalKey: key6,
                                    description:
                                        'Tambahkan lokasi spesifik dari fasilitas yang rusak seperti nama gedung, lantai, ruangan, dll.\nContoh: Gedung Laboratorium, lantai 4, kamar mandi bagian barat.',
                                    child: Builder(builder: (context) {
                                      return Column(children: [
                                        CustomForm(
                                            obscureText: false,
                                            controller:
                                                locationDetailController,
                                            labelText:
                                                'Detail Lokasi: gedung, lantai, ruangan, dll',
                                            prefixIcon: const Icon(
                                                Icons.location_on_outlined)),
                                        const SizedBox(height: 12),
                                        const Text(
                                            "*Contoh: Gedung Laboratorium, Lantai 4, Ruangan Lab Multimedia Sistem Informasi (barat)",
                                            style: TextStyle(color: Colors.red))
                                      ]);
                                    })))
                          ])
                      ])))
        ]));
  }

  displayMedia() {
    final mediaCount = imageFiles?.length ?? 0;
    final hasVideo = videoFiles != null;

    if (mediaCount == 0 && !hasVideo) {
      return const Text(
        "Gambar atau Video diperlukan!\nAnda bisa menyertakan 3 gambar!",
        style: TextStyle(color: Colors.redAccent, fontSize: 16),
      );
    }

    if (mediaCount + (hasVideo ? 1 : 0) > 1) {
      return Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.26,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(bottom: 12),
            child: PageView.builder(
              controller: pageController,
              itemCount: mediaCount + (hasVideo ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < mediaCount) {
                  return DisplayImage(
                    url: imageFiles![index]!.path,
                    dataSourceType: DataSourceType.file,
                    showButtonRemove: true,
                    onPressed: () {
                      setState(() {
                        imageFiles!.removeAt(index);
                        if (imageFiles!.isEmpty && videoFiles == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.redAccent,
                              content: Text("Gambar atau Video diperlukan"),
                            ),
                          );
                        }
                      });
                    },
                  );
                } else if (hasVideo && index == mediaCount) {
                  return DisplayVideo(
                    url: videoFiles!.path,
                    dataSourceType: DataSourceType.file,
                    onPressed: () {
                      setState(() {
                        videoFiles = null;
                      });
                    },
                  );
                }
                return Container();
              },
              onPageChanged: (index) {
                setState(() {});
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buildPageIndicator(),
          ),
        ],
      );
    } else {
      // Return only the media without the page indicator.
      return Container(
        height: MediaQuery.of(context).size.height * 0.26,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(bottom: 12),
        child: PageView.builder(
          controller: pageController,
          itemCount: mediaCount + (hasVideo ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < mediaCount) {
              return DisplayImage(
                url: imageFiles![index]!.path,
                dataSourceType: DataSourceType.file,
                showButtonRemove: true,
                onPressed: () {
                  setState(() {
                    imageFiles!.removeAt(index);
                    if (imageFiles!.isEmpty && videoFiles == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.redAccent,
                          content: Text("Gambar atau Video diperlukan"),
                        ),
                      );
                    }
                  });
                },
              );
            } else if (hasVideo && index == mediaCount) {
              return DisplayVideo(
                url: videoFiles!.path,
                dataSourceType: DataSourceType.file,
                onPressed: () {
                  setState(() {
                    videoFiles = null;
                  });
                },
              );
            }
            return Container();
          },
          onPageChanged: (index) {
            setState(() {});
          },
        ),
      );
    }
  }

  List<Widget> buildPageIndicator() {
    List<Widget> indicators = [];

    final mediaCount = imageFiles?.length ?? 0;
    final hasVideo = videoFiles != null;

    // Check if there is more than one media item (images or video).
    if (mediaCount + (hasVideo ? 1 : 0) > 1) {
      for (int i = 0; i < mediaCount + (hasVideo ? 1 : 0); i++) {
        indicators.add(Container(
          width: 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i == currentPage ? AppColors.primaryColor : Colors.black45,
          ),
        ));
      }
    }

    return indicators;
  }
}
