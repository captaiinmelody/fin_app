import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_app/features/auth/data/localresources/auth_local_storage.dart';
import 'package:fin_app/features/root/data/models/report_models.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class ReportsDataSources {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> postReports(
    String? description,
    File? imageFiles,
    File? videoFiles,
    String? kampus,
    String? detailLokasi,
  ) async {
    try {
      MediaUrl? mediaUrl;

      if (imageFiles != null && videoFiles != null) {
        String imageUrl = await uploadFile(imageFiles);
        String videoUrl = await uploadFile(videoFiles);
        mediaUrl = MediaUrl(imageUrl: imageUrl, videoUrl: videoUrl);
      } else if (imageFiles != null) {
        String imageUrl = await uploadFile(imageFiles);
        mediaUrl = MediaUrl(imageUrl: imageUrl);
      } else if (videoFiles != null) {
        String videoUrl = await uploadFile(videoFiles);
        mediaUrl = MediaUrl(videoUrl: videoUrl);
      }

      String reportsId = const Uuid().v1();
      final userId = await AuthLocalStorage().getUserId();

      ReportsModels reports = ReportsModels(
        userId: userId,
        reportsId: reportsId,
        mediaUrl: mediaUrl,
        description: description,
        datePublished: DateTime.now(),
        totalLikes: 0,
        totalComments: 0,
        kampus: kampus,
        detailLokasi: detailLokasi,
        status: 0,
      );

      DocumentSnapshot userSnapshot =
          await firestore.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        String username = userSnapshot.get("username");
        final updatedReports = reports.copyWith(username: username);

        await firestore
            .collection('reports')
            .doc(reportsId)
            .set(updatedReports.toMap());

        return 'success';
      } else {
        return 'User document not found';
      }
    } catch (e) {
      return e.toString(); // Return error message as String
    }
  }

  Future<String> uploadFile(File file) async {
    String fileName = basename(file.path);
    Reference ref;

    String extention = file.path.toLowerCase();

    if (extention.endsWith('.mp4') ||
        extention.endsWith('.mov') ||
        extention.endsWith('.avi')) {
      ref = firebaseStorage.ref().child('reports/videos/$fileName');
    } else {
      ref = firebaseStorage.ref().child('reports/images/$fileName');
    }

    UploadTask task = ref.putFile(file);
    TaskSnapshot snapshot = await task.whenComplete(() => null);
    final downloadURL = await snapshot.ref.getDownloadURL();

    return downloadURL;
  }

  Future<List<ReportsModels>> getReports() async {
    try {
      final QuerySnapshot snapshot =
          await firestore.collection('reports').get();

      final List<ReportsModels> reportsModels = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ReportsModels.fromMap(data);
      }).toList();

      return reportsModels;
    } catch (e) {
      print('Error fetching ReportsModels: $e');
      throw Exception("Failed to fetch ReportsModels");
    }
  }

  Future<Position> getCurrentLocation() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      bool permissionRequested = await Geolocator.openLocationSettings();
      if (!permissionRequested) {
        // The user declined to enable location services
        throw 'Location service are disabled';
      }
    }

    // Check if the app has permission to access the location
    PermissionStatus permissionStatus =
        await Permission.locationWhenInUse.status;
    if (permissionStatus.isDenied) {
      // Permission has not been granted
      permissionStatus = await Permission.locationWhenInUse.request();
      if (permissionStatus != PermissionStatus.granted) {
        // Permission has been denied by the user
        throw 'Location permission has been denied';
      }
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return position;
  }
}
