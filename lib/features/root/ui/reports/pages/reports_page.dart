import 'dart:io';
import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:fin_app/constant/color.dart';
import 'package:fin_app/features/auth/components/auth_input_components.dart';
import 'package:fin_app/features/auth/data/localresources/auth_local_storage.dart';
import 'package:fin_app/features/root/bloc/root_bloc.dart';
import 'package:fin_app/features/root/components/display_image.dart';
import 'package:fin_app/features/root/components/display_video.dart';
import 'package:fin_app/features/root/components/show_case_view.dart';
import 'package:fin_app/features/root/data/localstorage/root_local_storage.dart';
import 'package:fin_app/features/root/ui/reports/components/button_media.dart';
import 'package:fin_app/features/root/ui/reports/components/campus_selection.dart';
import 'package:fin_app/routes/route_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:video_player/video_player.dart';
// import 'package:path_provider/path_provider.dart' as p;

class ReportsPage extends StatefulWidget {
  final RootBloc rootBloc;
  final bool isAdmin;
  final String reportsId;
  const ReportsPage({
    Key? key,
    required this.rootBloc,
    required this.isAdmin,
    required this.reportsId,
  }) : super(key: key);

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final ImagePicker picker = ImagePicker();

  File? imageFiles;
  File? videoFiles;
  PlatformFile? profilePhoto;
  String? selectedDropdownItem;

  int currentPage = 0;

  double? heightPhoto;
  double? widthPhoto;

  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationDetailController = TextEditingController();
  PageController pageController = PageController(initialPage: 0);

  Future<void> selectVideo() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.video,
      allowCompression: true,
    );

    if (result == null) return;

    final selectedFile = File(result.files.single.path!);

    final videoPlayerController = VideoPlayerController.file(selectedFile);
    await videoPlayerController.initialize();
    final duration = videoPlayerController.value.duration;
    await videoPlayerController.dispose();

    // Limit video duration to 1 minute (60 seconds)
    const maxDurationInSeconds = 60;

    if (duration.inSeconds <= maxDurationInSeconds) {
      setState(() {
        videoFiles = selectedFile;
      });
    } else {
      // Show the error message outside the method using a custom SnackBar
      showVideoDurationError();
    }
  }

  void showVideoDurationError() {
    const snackBar = SnackBar(
      backgroundColor: Colors.red,
      content: Text('Selected video exceeds the maximum duration of 1 minute.'),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> recordVideoFromCamera() async {
    final pickedFile = await picker.pickVideo(
        source: ImageSource.camera, maxDuration: const Duration(minutes: 1));
    if (pickedFile == null) return;

    final videoFile = File(pickedFile.path);
    setState(() {
      videoFiles = videoFile;
    });
  }

  Future<void> pickImageFromCamera() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (pickedFile == null) return;

    final imageFile = await compressImage(File(pickedFile.path));

    setState(() {
      imageFiles = imageFile;
    });
  }

  Future<void> selectImage() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
      allowCompression: true,
    );

    if (result == null) return;

    final selectedFile = File(result.files.single.path!);

    if (selectedFile.existsSync()) {
      print('Selected image file path: ${selectedFile.path}');
      final compressedImage = await compressImage(selectedFile);

      if (compressedImage != null) {
        setState(() {
          imageFiles = compressedImage;
        });
      } else {
        print('Image compression failed');
      }
    } else {
      print('Selected image file does not exist: ${selectedFile.path}');
    }
  }

  Future<File?> compressImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();

      final kb = bytes.length / 1024;
      final mb = kb / 1024;

      if (kDebugMode) {
        print('original file size $mb');
      }

      final compressedData = await FlutterImageCompress.compressWithFile(
        imageFile.path,
        quality: 30, // Set the image quality (0 to 100)
      );

      // Create a new File with the compressed data and return it
      final compressedImage = File(imageFile.path)
        ..writeAsBytesSync(compressedData!);

      final data = await compressedImage.readAsBytes();
      final newKb = data.length / 1024;
      final newMb = newKb / 1024;

      if (kDebugMode) {
        print('compressed image size: $newMb');
      }
      return compressedImage;
    } catch (e) {
      print('Error compressing image: $e');
      return null;
    }
  }

  startShowCase() async {
    final getReportsShowCase =
        await RootLocalStorgae().getReportsPageShowCase();

    if (getReportsShowCase == false) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        ShowCaseWidget.of(context).startShowCase(
          [key3, key4, key5, key6, key7],
        );
      });
    }
  }

  adminStartShowCase() async {
    final getAdminReportsShowCase =
        await RootLocalStorgae().getAdminReportsPageShowCase();

    if (getAdminReportsShowCase == false) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        ShowCaseWidget.of(context).startShowCase(
          [key3, key4, key5, key6, key7],
        );
      });
    }
  }

  bool? currentIsAdmin;

  getRole() async {
    final isAdmin = await AuthLocalStorage().isRoleAdmin();
    setState(() {
      currentIsAdmin = isAdmin;
    });
  }

  initGetRole() async {
    await getRole();

    if (currentIsAdmin == true) {
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
      appBar: customAppBar(context),
      body: appBody(size),
    );
  }

  AppBar customAppBar(BuildContext context) {
    return AppBar(
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: BlocConsumer<RootBloc, RootState>(
            bloc: widget.rootBloc,
            listener: (context, state) {
              if (state is LoadedState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(state.response.toString())),
                );
                setState(() {
                  imageFiles = null;
                  videoFiles = null;
                });

                GoRouter.of(context).pop();
              } else if (state is ErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      backgroundColor: Colors.redAccent,
                      content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              if (state is LoadingState) {
                return Center(
                  child: LoadingAnimationWidget.horizontalRotatingDots(
                      color: AppColors.primaryColor, size: 20),
                );
              }
              return ShowCaseView(
                globalKey: key7,
                description: 'Tekan tombol ini untuk melakukan laporan',
                child: Builder(builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      if (widget.isAdmin == false) {
                        widget.rootBloc.add(ReportsEventPost(
                          description: descriptionController.text,
                          imageFiles: imageFiles,
                          videoFiles: videoFiles,
                          kampus: selectedDropdownItem,
                          detailLokasi: locationDetailController.text,
                        ));
                      } else if (widget.isAdmin == true) {
                        widget.rootBloc.add(AdminFixingReportsEventPost(
                            description: descriptionController.text,
                            imageFiles: imageFiles,
                            videoFiles: videoFiles,
                            reportsId: widget.reportsId));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    child: const Text(
                      'Report',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ],
      leading: IconButton(
        onPressed: () {
          GoRouter.of(context).pop();
        },
        icon: const Icon(Icons.close, size: 36),
      ),
    );
  }

  appBody(Size size) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
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
                      return TextField(
                        controller: descriptionController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Tambahkan deskripsi pelaporan',
                        ),
                      );
                    }),
                  ),
                  if (imageFiles != null || videoFiles != null)
                    displayMedia()
                  else
                    const Text(
                      "Gambar atau Video diperlukan",
                      style: TextStyle(color: Colors.redAccent),
                    ),
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
                            pickImageFromCamera();
                          },
                          onTakeVideoTap: () async {
                            recordVideoFromCamera();
                          });
                    }),
                  ),
                  if (widget.isAdmin == false)
                    Column(
                      children: [
                        ShowCaseView(
                          globalKey: key5,
                          description:
                              'Pilih di kampus mana kerusakan fasilitas terjadi',
                          child: Builder(builder: (context) {
                            return CampusSelection(
                              isEnabled: false,
                              onChanged: (selectedValue) {
                                setState(() {
                                  selectedDropdownItem = selectedValue;
                                });
                              },
                            );
                          }),
                        ),
                        ShowCaseView(
                          globalKey: key6,
                          description:
                              'Tambahkan lokasi spesifik dari fasilitas yang rusak seperti nama gedung, lantai, ruangan, dll.',
                          child: Builder(builder: (context) {
                            return Container(
                              margin: const EdgeInsets.only(top: 12),
                              child: AuthForm(
                                controller: locationDetailController,
                                labelText: 'Location details...',
                                prefixIcon:
                                    const Icon(Icons.location_on_outlined),
                              ),
                            );
                          }),
                        )
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget displayMedia() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.26,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 12),
      child: Stack(
        children: [
          PageView(
            controller: pageController,
            children: [
              if (imageFiles != null)
                DisplayImage(
                  url: imageFiles!.path,
                  dataSourceType: DataSourceType.file,
                  onPressed: () {
                    setState(() {
                      imageFiles = null;
                    });
                  },
                ),
              if (videoFiles != null)
                DisplayVideo(
                  url: videoFiles!.path,
                  dataSourceType: DataSourceType.file,
                  onPressed: () {
                    setState(() {
                      videoFiles = null;
                    });
                  },
                ),
            ],
            onPageChanged: (index) {
              setState(() {}); // Update the page indicator
            },
          ),
          if (imageFiles != null && videoFiles != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: buildPageIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> buildPageIndicator() {
    List<Widget> indicators = [];

    for (int i = 0; i < 2; i++) {
      indicators.add(
        Container(
          width: 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i == currentPage ? AppColors.primaryColor : Colors.black45,
          ),
        ),
      );
    }
    return indicators;
  }
}
