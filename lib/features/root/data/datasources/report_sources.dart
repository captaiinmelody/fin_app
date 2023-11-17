import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_app/features/auth/data/localresources/auth_local_storage.dart';
import 'package:fin_app/features/root/data/datasources/debug_function.dart';
import 'package:fin_app/features/root/data/datasources/notification_sources.dart';
import 'package:fin_app/features/root/data/models/report_models.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

class ReportsRepository {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  FirebaseFirestore firestore;
  DebugFunction debugFunction = DebugFunction();
  ReportsRepository({
    FirebaseFirestore? firestore,
  }) : firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get collection => firestore.collection('reports');

  //admin service start
  Future<ReportsModel> getReportsById(String documentId) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('reports')
          .doc(documentId)
          .get();

      ReportsModel reportsModel =
          ReportsModel.fromMap(docSnapshot.data() as Map<String, dynamic>);

      debugFunction.reportsModelDebug(reportsModel);

      return reportsModel;
    } catch (e) {
      print("gagal mwngambil data by reprts id: $e");
      throw e.toString();
    }
  }

  Future<String> reportsConfirmation(
    String documentId,
    String status,
    String? targetRole,
  ) async {
    ReportsModel reportsSnapshot = await getReportsById(documentId);
    String? reportsId = reportsSnapshot.reportsId;
    String? teknisiNotifToken;
    String? userNotifToken;
    String userId = reportsSnapshot.userData!.userId!;
    DocumentSnapshot userSnapshot =
        await firestore.collection("users").doc(userId).get();
    userNotifToken = userSnapshot.get('notificationToken');
    String teknisiId = targetRole == "krt_kampus_1"
        ? "18EYE6amrDfKnSwE1eVMkKtx2Ev2"
        : targetRole == "krt_kampus_2"
            ? "iuceH3NLnsSpqfUoxMXNSzXZ4mM2"
            : targetRole == "krt_kampus_3"
                ? "7uqAy9nIkUhMoZNfotpwYHgV0TY2"
                : targetRole == "krt_kampus_4"
                    ? "1SjYYIEmT0NGvlBdtyhET0I7xdB2"
                    : targetRole == "krt_kampus_5"
                        ? "lJl5deDhQzYgngun7CNgMzlkaug2"
                        : "d0mhlSZ3RYZFfGiBoWdpWMON0Uj1";
    DocumentSnapshot teknisiSnapshot =
        await firestore.collection("users").doc(teknisiId).get();

    teknisiNotifToken = teknisiSnapshot.get("notificationToken");
    try {
      if (status == "rejected") {
        try {
          await firestore
              .collection('reports')
              .doc(reportsId)
              .update({'reportsData.status': "rejected"});

          //Take the updated data
          DocumentSnapshot updatedReportSnapshot =
              await firestore.collection('reports').doc(reportsId).get();

          final updatedReportsData = ReportsModel.fromMap(
              updatedReportSnapshot.data() as Map<String, dynamic>);

          debugFunction.reportsModelDebug(updatedReportsData);

          try {
            await NotificationSources().sendNotification(
              userNotifToken!,
              "Laporan Anda Ditolak",
              'Laporan anda tidak valid',
              reportsId!,
              userId,
            );
          } catch (e) {
            print("notifikasi gagal dikirim dengan error: $e");
            throw e.toString();
          }
        } catch (e) {
          print("Menolak laporan gagal dengan error: $e");
          throw e.toString();
        }
        return "ditolak";
      } else {
        try {
          await firestore
              .collection('reports')
              .doc(reportsId)
              .update({'reportsData.status': "confirmed"});
          try {
            await NotificationSources().sendNotification(
              teknisiNotifToken!,
              "Tugas Baru",
              'Ada pekerjaan untuk memperbaiki fasilitas',
              reportsId!,
              teknisiId,
            );
            await NotificationSources().sendNotification(
              userNotifToken!,
              "Laporan Telah Dikonfirmasi",
              'Laporan anda sudah di konfirmasi dan sedang ditangani',
              reportsId,
              userId,
            );
          } catch (e) {
            print("notifikasi gagal dikirim dengan error: $e");
            throw e.toString();
          }
        } catch (e) {
          print("Konfirmasi Laporan Gagal dengan error: $e");
          throw e.toString();
        }

        return "dikonfirmasi";
      }
    } catch (e) {
      return "error";
    }
  }

  Future<String> deleteReports(reportsId) async {
    try {
      ReportsModel reportsSnapshot = await getReportsById(reportsId);

      String? userId = reportsSnapshot.userData?.userId;

      DocumentSnapshot userSnapshot =
          await firestore.collection('users').doc(userId).get();
      int currentTotalReports = userSnapshot.get('totalReports');
      int newTotalReports = currentTotalReports - 1;

      try {
        await firestore.collection('reports').doc(reportsId).delete();
        try {
          await firestore.collection('users').doc(userId).update({
            'totalReports': newTotalReports,
            'updatedAt': DateTime.now(),
          });
        } catch (e) {
          print("gagal mengurangi jumlah laporan pada users : $e");
          return e.toString();
        }
      } catch (e) {
        print("Gagal Menghapus Laporan : $e");
        return e.toString();
      }

      return 'Laporan berhasil di hapus';
    } catch (e) {
      print("Error saat menghapus laporan : $e");
      throw e.toString();
    }
  }

  //admin service end

  //reporter service start
  Future<String> postReports(
    String? inputDescription,
    List<File?>? imageFiles,
    File? videoFiles,
    String? campus,
    String? location,
  ) async {
    MediaUrl? mediaUrl;

    if (imageFiles != null && videoFiles != null) {
      List<String> imageUrls = await uploadFiles(imageFiles);
      String videoUrl = await uploadFile(videoFiles);
      mediaUrl = MediaUrl(imageUrls: imageUrls, videoUrl: videoUrl);
    } else if (imageFiles != null) {
      List<String> imageUrls = await uploadFiles(imageFiles);
      mediaUrl = MediaUrl(imageUrls: imageUrls);
    } else if (videoFiles != null) {
      String videoUrl = await uploadFile(videoFiles);
      mediaUrl = MediaUrl(videoUrl: videoUrl);
    }

    ///data membuat laporan baru
    String reportsId = const Uuid().v1();
    final userId = await AuthLocalStorage().getUserId();
    DocumentSnapshot userSnapshot =
        await firestore.collection('users').doc(userId).get();
    if (userSnapshot.exists) {
      String username = userSnapshot.get("username");
      String jabatan = userSnapshot.get("jabatan");
      String profilePhotoUrl = userSnapshot.get('profilePhotoUrl');
      int currentTotalReports = userSnapshot.get('totalReports') ?? 0;
      int newTotalReports = currentTotalReports + 1;

      ReportsModel reports = ReportsModel(
        reportsId: reportsId,
        userData: UserData(
          userId: userId,
          username: username,
          jabatan: jabatan,
          profilePhotoUrl: profilePhotoUrl,
        ),
        reportsData: ReportsData(
          reportsDescription: inputDescription,
          fixedDescription: "",
          campus: campus,
          location: location,
          status: "reported",
        ),
        mediaUrl: mediaUrl,
        datePublished: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      ///end data laporan baru

      /// data untuk mengirim notifikasi ke admin
      String? notificationToken;
      String? targetId = "EosD1TZy5XZT0vQpSeBl5pokJEn2";
      DocumentSnapshot targetSnapshot =
          await firestore.collection("users").doc(targetId).get();
      notificationToken = targetSnapshot.get("notificationToken");

      ///end data admin

      try {
        ///membuat data laporan baru
        await firestore
            .collection('reports')
            .doc(reportsId)
            .set(reports.toMap());

        ///jika laporan berhasil dibuat maka:
        try {
          ///menambahkan total laporan ke data user
          await firestore.collection('users').doc(userId).update({
            'totalReports': newTotalReports,
            'updatedAt': DateTime.now(),
          });

          ///jika berhasil melakukan update user data maka:
          try {
            ///mengirim notifikasi ke admin
            await NotificationSources().sendNotification(
              notificationToken!,
              "Laporan Baru",
              '$username membuat laporan baru di $campus',
              reportsId,
              targetId,
            );
          } catch (e) {
            print("Gagar mengirim notifikasi dengan error: $e");
            return "Gagal mengirimkan notifikasi";
          }
          return "Berhasil memperbarui data user dan mengirimkan notifikasi ke admin";
        } catch (e) {
          print(
              "Gagal menambahkan total laporan ke data user dengan error: $e");
          return e.toString();
        }
      } catch (e) {
        print("Gagal membuat data laporan baru dengan error: $e");
        return e.toString();
      }
    }

    return "Laporan Berhasil dibuat";
  }

  //reporter services end

  //teknisi services start
  Future<String> reportsFixConfirmation(
    String? inputDescription,
    List<File?>? imageFiles,
    File? videoFiles,
    String reportsId,
  ) async {
    DocumentSnapshot reportSnapshot =
        await firestore.collection('reports').doc(reportsId).get();
    final initialReportsData =
        ReportsModel.fromMap(reportSnapshot.data() as Map<String, dynamic>);

    debugFunction.reportsModelDebug(initialReportsData);

    Map<String, dynamic>? existingReportsData =
        initialReportsData.reportsData!.toMap();

    MediaUrl? mediaUrl;
    MediaUrl? existingMediaUrl;
    String? adminNotifToken;
    String? userNotifToken;
    String adminId = "EosD1TZy5XZT0vQpSeBl5pokJEn2";
    String userId = initialReportsData.userData!.userId!;

    DocumentSnapshot targetSnapshot =
        await firestore.collection("users").doc(adminId).get();
    DocumentSnapshot userSnapshot =
        await firestore.collection("users").doc(userId).get();

    adminNotifToken = targetSnapshot.get("notificationToken");
    userNotifToken = userSnapshot.get("notificationToken");

    existingReportsData['fixedDescription'] = inputDescription;
    existingReportsData['status'] = 'fixed';

    if (reportSnapshot.exists) {
      existingMediaUrl = MediaUrl.fromMap(reportSnapshot.get('mediaUrl'));
    }
    if (imageFiles != null && videoFiles != null) {
      List<String> imageUrl = await uploadFiles(imageFiles);
      String videoUrl = await uploadFile(videoFiles);
      mediaUrl = MediaUrl(
        imageUrls: existingMediaUrl?.imageUrls,
        videoUrl: existingMediaUrl?.videoUrl,
        fixedImageUrls: imageUrl,
        fixedVideoUrl: videoUrl,
      );
    } else if (imageFiles != null) {
      List<String> imageUrls = await uploadFiles(imageFiles);
      mediaUrl = MediaUrl(
        imageUrls: existingMediaUrl?.imageUrls,
        videoUrl: existingMediaUrl?.videoUrl,
        fixedImageUrls: imageUrls,
      );
    } else if (videoFiles != null) {
      String videoUrl = await uploadFile(videoFiles);
      mediaUrl = MediaUrl(
        imageUrls: existingMediaUrl?.imageUrls,
        videoUrl: existingMediaUrl?.videoUrl,
        fixedVideoUrl: videoUrl,
      );
    }

    try {
      await firestore.collection('reports').doc(reportsId).update({
        'reportsData': existingReportsData,
        'mediaUrl': mediaUrl?.toMap(),
        'updatedAt': DateTime.now()
      });

      ///Take the updated data
      DocumentSnapshot updatedReportSnapshot =
          await firestore.collection('reports').doc(reportsId).get();

      final updatedReportsData = ReportsModel.fromMap(
          updatedReportSnapshot.data() as Map<String, dynamic>);

      debugFunction.reportsModelDebug(updatedReportsData);

      try {
        /// notifikasi untuk admin atau teknisi
        await NotificationSources().sendNotification(
          adminNotifToken!,
          "Fasilitas Telah Diperbaiki",
          'KRT Sudah melakukan perbaikan',
          reportsId,
          adminId,
        );

        /// notifikasi untuk user
        await NotificationSources().sendNotification(
          userNotifToken!,
          "Laporan Selesai",
          'Fasilitas yang anda laporkan sudah diperbaiki',
          reportsId,
          userId,
        );
      } catch (e) {
        print("Gagal mengirim notifikasi dengan error: $e");
        return e.toString();
      }

      return "Berhasil mengirim data dan notifikasi";
    } catch (e) {
      print("Error saat update laporan ke Firestore : $e");
      throw e.toString();
    }
  }

  //teknisi services end

  //uploading service start
  Future<String> uploadFile(File file) async {
    String fileName = p.basename(file.path);
    String extention = file.path.toLowerCase();
    Reference ref;

    if (extention.endsWith('.mp4') ||
        extention.endsWith('.mov') ||
        extention.endsWith('.avi')) {
      ref = firebaseStorage.ref().child('reports/videos/$fileName');
    } else {
      ref = firebaseStorage.ref().child('reports/images/$fileName');
    }

    try {
      UploadTask task = ref.putFile(file);
      TaskSnapshot snapshot = await task.whenComplete(() => null);
      final fileURL = await snapshot.ref.getDownloadURL();

      print("Upload file berhasil, URL File: $fileURL");

      return fileURL;
    } catch (e) {
      print("Error saat upload file ke Firebase Storage : $e");
      return e.toString();
    }
  }

  Future<List<String>> uploadFiles(List<File?> files) async {
    List<String> urls = [];

    for (final file in files) {
      String url = await uploadFile(file!);
      urls.add(url);
    }

    return urls;
  }

  //uploading services end

  //fetching reports data start
  Future<List<ReportsModel>> getAllReports() async {
    try {
      final QuerySnapshot snapshot =
          await firestore.collection('reports').get();

      final List<ReportsModel> reportsModels = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ReportsModel.fromMap(data);
      }).toList();

      reportsModels
          .sort((a, b) => b.datePublished!.compareTo(a.datePublished!));

      debugFunction.listReportsModelDebug(reportsModels, "all");
      return reportsModels;
    } catch (e) {
      print('Error fetching all reports data: $e');
      throw Exception("Failed to fetch ReportsModels");
    }
  }

  Future<List<ReportsModel>> getReportsByCampus(String campus) async {
    try {
      final QuerySnapshot snapshot = await firestore
          .collection('reports')
          .where('reportsData.campus', isEqualTo: campus)
          .get();

      final List<ReportsModel> reportsModels = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ReportsModel.fromMap(data);
      }).toList();

      reportsModels
          .sort((a, b) => b.datePublished!.compareTo(a.datePublished!));

      debugFunction.listReportsModelDebug(reportsModels, "teknisi",
          campus: campus);

      return reportsModels;
    } catch (e) {
      print('Error fetching reports by campus: $e');
      throw Exception("Failed to fetch ReportsModels");
    }
  }

  Future<List<ReportsModel>> getReportsByReporterId() async {
    try {
      final userId = await AuthLocalStorage().getUserId();

      final QuerySnapshot snapshot = await firestore
          .collection('reports')
          .where('userData.userId', isEqualTo: userId)
          .get();

      final List<ReportsModel> reportsModels = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ReportsModel.fromMap(data);
      }).toList();

      reportsModels
          .sort((a, b) => b.datePublished!.compareTo(a.datePublished!));

      String username = reportsModels.first.userData!.username!;

      debugFunction.listReportsModelDebug(reportsModels, "pelapor",
          username: username);
      return reportsModels;
    } catch (e) {
      print('Error fetching reports by reporter id: $e');
      throw Exception("Failed to fetch ReportsModels");
    }
  }

  Future<ReportsModel> getReportsDetail(reportsId) async {
    try {
      final response =
          await firestore.collection('reports').doc(reportsId).get();

      final reportsData =
          ReportsModel.fromMap(response.data() as Map<String, dynamic>);

      return reportsData;
    } catch (e) {
      print(e);
      throw Exception("Failed to fetch ReportsModels");
    }
  }

  //fetching reports data end
}
