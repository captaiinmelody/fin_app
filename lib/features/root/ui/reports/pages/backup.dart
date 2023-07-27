// import 'dart:io';
// import 'dart:async';

// import 'package:file_picker/file_picker.dart';
// import 'package:fin_app/constant/color.dart';
// import 'package:fin_app/features/reports/bloc/reports_bloc.dart';
// import 'package:fin_app/routes/route_const.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';

// class ReportsPage extends StatefulWidget {
//   const ReportsPage({super.key});

//   @override
//   State<ReportsPage> createState() => _ReportsPageState();
// }

// class _ReportsPageState extends State<ReportsPage> {
//   int start = 10;
//   late Timer timer;
//   PlatformFile? pickedFile;

//   TextEditingController descriptionController = TextEditingController();

//   void startTimer() {
//     const oneSec = Duration(seconds: 1);
//     timer = Timer.periodic(
//       oneSec,
//       (Timer timer) {
//         if (start == 0) {
//           setState(() {
//             timer.cancel();

//             GoRouter.of(context).goNamed(MyRouterConstant.adminHomeRouterName);
//           });
//         } else {
//           setState(() {
//             start--;
//           });
//         }
//       },
//     );
//   }

//   Future selectFile() async {
//     final result = await FilePicker.platform
//         .pickFiles(allowMultiple: false, type: FileType.any);
//     if (result == null) return;

//     setState(() {
//       pickedFile = result.files.single;
//     });
//   }

//   Future<void> clearImage() async {
//     setState(() {
//       pickedFile = null;
//     });
//   }

//   @override
//   void dispose() {
//     timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         actions: [ElevatedButton(onPressed: () {}, child: Container())],
//         leading: IconButton(
//           onPressed: () {
//             GoRouter.of(context).pop();
//           },
//           icon: const Icon(Icons.close, size: 36),
//         ),
//       ),
//       body: Column(
//         children: [
//           SingleChildScrollView(
//             child: Center(
//                 child: pickedFile == null
//                     ? Column(
//                         children: [
//                           const Icon(
//                             Icons.image_outlined,
//                             size: 300,
//                           ),
//                           const SizedBox(height: 50),
//                           ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppColors.primaryColor,
//                                 fixedSize: Size(size.width * 0.5, 50),
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12))),
//                             onPressed: () {},
//                             child: const Text(
//                               "Select an image",
//                               style: TextStyle(
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ],
//                       )
//                     : Column(
//                         children: [
//                           Container(
//                             color: Colors.lightBlue,
//                             child: Image.file(
//                               File(pickedFile!.path!),
//                               width: double.infinity,
//                               height: 350,
//                               fit: BoxFit.fitHeight,
//                             ),
//                           ),
//                           const SizedBox(height: 50),
//                           TextField(
//                             controller: descriptionController,
//                             maxLines: null,
//                             keyboardType: TextInputType.multiline,
//                             decoration: InputDecoration(
//                               labelText: 'Enter description',
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12)),
//                               focusedErrorBorder: OutlineInputBorder(
//                                 borderSide: const BorderSide(
//                                     color: Colors
//                                         .red), // Set the filled border color
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 24),
//                           BlocConsumer<ReportsBloc, ReportsState>(
//                             listener: (context, state) {
//                               if (state is ReportsLoaded) {
//                                 setState(() {
//                                   pickedFile = null;
//                                 });
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                       backgroundColor: Colors.green,
//                                       content: Text('Upload success')),
//                                 );
//                                 startTimer();
//                               } else if (state is ReportsError) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                       backgroundColor: Colors.redAccent,
//                                       content: Text(state.message)),
//                                 );
//                               }
//                             },
//                             builder: (context, state) {
//                               if (state is ReportsLoading) {
//                                 return Center(
//                                   child: LoadingAnimationWidget.prograssiveDots(
//                                     size: double.infinity,
//                                     color: AppColors.secondaryColor,
//                                   ),
//                                 );
//                               }
//                               return ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                     backgroundColor: AppColors.primaryColor,
//                                     fixedSize: Size(size.width * 0.5, 50),
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(12))),
//                                 onPressed: () async {
//                                   // context.read<ReportsBloc>().add(
//                                   //     ReportsPostEvent(
//                                   //         description:
//                                   //             descriptionController.text,
//                                   //         fileName: pickedFile!.name,
//                                   //         filePath: pickedFile!.path!));
//                                 },
//                                 child: const Text(
//                                   "Upload",
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                               );
//                             },
//                           ),
//                         ],
//                       )),
//           ),
//         ],
//       ),
//       bottomSheet: Container(
//         height: 60,
//         color: Colors.grey,
//         child: Container(
//           height: 50,
//           width: double.infinity,
//           margin: const EdgeInsets.only(top: 2),
//           color: Colors.white,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 IconButton(
//                   onPressed: () {
//                     selectFile();
//                   },
//                   icon: const Icon(Icons.image_outlined),
//                   color: AppColors.primaryColor,
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // void postImage() async {
//   //   setState(() {
//   //     _isLoading = true;
//   //   });

//   //   try {
//   //     String res = await ImageStoreMethod()
//   //         .uploadReports(descriptionController.text, _file);
//   //     if (res == 'success') {
//   //       setState(() {
//   //         _isLoading = false;
//   //       });
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         const SnackBar(
//   //             backgroundColor: Colors.blue, content: Text('Success')),
//   //       );
//   //       clearImage();
//   //     } else {
//   //       setState(() {
//   //         _isLoading = false;
//   //       });
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(backgroundColor: Colors.redAccent, content: Text(res)),
//   //       );
//   //     }
//   //   } catch (e) {
//   //     print(e.toString());
//   //   }
//   // }

//   // imageSelector(context) {
//   //   return showDialog(
//   //     context: context,
//   //     builder: (context) {
//   //       return SimpleDialog(
//   //         title: const Text('Select an image'),
//   //         children: [
//   //           SimpleDialogOption(
//   //             onPressed: () async {
//   //               GoRouter.of(context).pop();
//   //               Uint8List file = await pickImage(ImageSource.camera);
//   //               setState(() {
//   //                 _file = file;
//   //               });
//   //             },
//   //             child: const Text("Take a photo"),
//   //           ),
//   //           SimpleDialogOption(
//   //             onPressed: () async {
//   //               GoRouter.of(context).pop();
//   //               Uint8List file = await pickImage(ImageSource.gallery);
//   //               setState(() {
//   //                 _file = file;
//   //               });
//   //             },
//   //             child: const Text("Choose from gallery"),
//   //           )
//   //         ],
//   //       );
//   //     },
//   //   );
//   // }
// }
