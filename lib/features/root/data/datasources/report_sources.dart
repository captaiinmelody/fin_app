import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_app/features/auth/data/localresources/auth_local_storage.dart';
import 'package:fin_app/features/root/data/models/leaderboards_models.dart';
import 'package:fin_app/features/root/data/models/report_models.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
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
      String leaderboardsId = const Uuid().v1();
      final userId = await AuthLocalStorage().getUserId();

      DocumentSnapshot userSnapshot =
          await firestore.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        //username fetch from users collection
        String username = userSnapshot.get("username");
        String profilePhotoUrl = userSnapshot.get('profilePhotoUrl');

        ReportsModels reports = ReportsModels(
          username: username,
          userId: userId,
          profilePhotoUrl: profilePhotoUrl,
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

        //totalReports fetch from users collection
        int currentTotalReports = userSnapshot.get('totalReports') ?? 0;
        int newTotalReports = currentTotalReports + 1;

        int badges = userSnapshot.get('badges');

        await firestore.collection('users').doc(userId).update({
          'totalReports': newTotalReports,
          'updatedAt': DateTime.now(),
        });

        await firestore
            .collection('reports')
            .doc(reportsId)
            .set(reports.toMap());

        //leaderboards models
        LeaderboardsModels leaderboards = LeaderboardsModels(
          leaderboardsId: leaderboardsId,
          userId: userId,
          profilePhotoUrl: profilePhotoUrl,
          username: username,
          badges: badges,
        );

        //get leaderboard for checkin if there is already userId in the leaderboards collection
        DocumentSnapshot leaderboardsSnapshot =
            await firestore.collection('leaderboards').doc(userId).get();

        //post to leaderboards collection
        if (leaderboardsSnapshot.exists) {
          return 'leaderboards already exist';
        } else {
          await firestore
              .collection('leaderboards')
              .doc(userId)
              .set(leaderboards.toMap());
        }

        return 'Upload Success';
      } else {
        return 'User document not found';
      }
    } catch (e) {
      throw e.toString(); // Return error message as String
    }
  }

  Future<String> reportsFixed(String? description, File? imageFiles,
      File? videoFiles, String reportsId) async {
    try {
      MediaUrl? mediaUrl;
      MediaUrl? existingMediaUrl;

      // Fetch the existing mediaUrl from the Firestore document
      DocumentSnapshot reportSnapshot =
          await firestore.collection('reports').doc(reportsId).get();
      if (reportSnapshot.exists) {
        existingMediaUrl = MediaUrl.fromMap(reportSnapshot.get('mediaUrl'));
      }

      if (imageFiles != null && videoFiles != null) {
        String imageUrl = await uploadFile(imageFiles);
        String videoUrl = await uploadFile(videoFiles);
        mediaUrl = MediaUrl(
          imageUrl: existingMediaUrl?.imageUrl, // Keep the existing imageUrl
          videoUrl: existingMediaUrl?.videoUrl, // Keep the existing videoUrl
          fixedImageUrl: imageUrl,
          fixedVideoUrl: videoUrl,
        );
      } else if (imageFiles != null) {
        String imageUrl = await uploadFile(imageFiles);
        mediaUrl = MediaUrl(
          imageUrl: existingMediaUrl?.imageUrl, // Keep the existing imageUrl
          videoUrl: existingMediaUrl?.videoUrl, // Keep the existing videoUrl
          fixedImageUrl: imageUrl,
        );
      } else if (videoFiles != null) {
        String videoUrl = await uploadFile(videoFiles);
        mediaUrl = MediaUrl(
          imageUrl: existingMediaUrl?.imageUrl, // Keep the existing imageUrl
          videoUrl: existingMediaUrl?.videoUrl, // Keep the existing videoUrl
          fixedVideoUrl: videoUrl,
        );
      }

      final userId = await AuthLocalStorage().getUserId();

      DocumentSnapshot userSnapshot =
          await firestore.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        int currentBadges = userSnapshot.get('badges');
        int newBadges = currentBadges + 1;

        await firestore.collection('users').doc(userId).update({
          'badges': newBadges,
          'updatedAt': DateTime.now(),
        });

        await firestore.collection('reports').doc(reportsId).update({
          'status': 2,
          'mediaUrl':
              mediaUrl?.toMap(), // Update the mediaUrl field in the document
        });

        //get leaderboard for checkin if there is already userId in the leaderboards collection
        DocumentSnapshot leaderboardsSnapshot =
            await firestore.collection('leaderboards').doc(userId).get();

        //post to leaderboards collection
        if (leaderboardsSnapshot.exists) {
          await firestore.collection('leaderboards').doc(userId).update({
            'badges': newBadges,
          });
        }
        return 'Upload Success';
      } else {
        return 'User document not found';
      }
    } catch (e) {
      print("$e");
      throw e.toString(); // Return error message as String
    }
  }

  Future<int> updateInt(String reportsId, String counter) async {
    final userId = await AuthLocalStorage().getUserId();

    DocumentSnapshot getReports =
        await firestore.collection('reports').doc(reportsId).get();
    final currentCounter = getReports.get(counter);
    final newCounter = currentCounter + 1;

    DocumentSnapshot getLeaderboards =
        await firestore.collection('leaderboards').doc(userId).get();
    final currentBadges = getLeaderboards.get('badges');
    final newBadges = currentBadges + 1;

    await firestore
        .collection('reports')
        .doc(reportsId)
        .update({counter: newCounter});

    await firestore
        .collection('leaderboards')
        .doc(userId)
        .update({'badges': newBadges});

    return newCounter;
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

      // Sort the reportsModels list by the newest datePublished
      reportsModels
          .sort((a, b) => b.datePublished!.compareTo(a.datePublished!));

      return reportsModels;
    } catch (e) {
      print('Error fetching ReportsModels: $e');
      throw Exception("Failed to fetch ReportsModels");
    }
  }

  Future<ReportsModels> getFixedReports(String reportsId) async {
    try {
      final DocumentSnapshot snapshot =
          await firestore.collection('fixed_reports').doc(reportsId).get();

      return ReportsModels.fromMap(snapshot.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception("Failed to fetch ReportsModels");
    }
  }

  Future<List<ReportsModels>> getReportsByUserId() async {
    try {
      final userId = await AuthLocalStorage().getUserId();

      final QuerySnapshot snapshot = await firestore
          .collection('reports')
          .where('userId', isEqualTo: userId)
          .get();

      final List<ReportsModels> reportsModels = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ReportsModels.fromMap(data);
      }).toList();

      // Sort the reportsModels list by the newest datePublished
      reportsModels
          .sort((a, b) => b.datePublished!.compareTo(a.datePublished!));

      return reportsModels;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching ReportsModels: $e');
      }
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
