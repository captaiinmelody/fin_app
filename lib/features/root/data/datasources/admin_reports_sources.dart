import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_app/features/root/data/models/report_models.dart';
import 'package:uuid/uuid.dart';

class AdminReportsDataSources {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String reportsCollectionName = 'reports';
  String usersCollectionName = 'users';
  String leaderboardsCollectionName = 'leaderboards';

  Future<ReportsModels> getReports(String documentId) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection(reportsCollectionName)
          .doc(documentId)
          .get();

      if (docSnapshot.exists) {
        return ReportsModels.fromMap(
            docSnapshot.data() as Map<String, dynamic>);
      } else {
        throw "Document not found";
      }
    } catch (e) {
      throw e.toString(); // Return error message as String
    }
  }

  Future<bool> reportsComfirmed(String documentId) async {
    try {
      final reportsSnapshot = await getReports(documentId);

      final reportsId = reportsSnapshot.reportsId;

      final userId = reportsSnapshot.userId;

      DocumentSnapshot userSnapshot =
          await firestore.collection('users').doc(userId).get();

      //badges fetch from users collection
      int currentBadges = userSnapshot.get('badges') ?? 0;
      int newBadges = currentBadges + 1;

      //totalReports fetch from users collection
      int currentTotalReports = userSnapshot.get('totalReports') ?? 0;
      int newTotalReports = currentTotalReports + 1;

      int currentStatus = reportsSnapshot.status!;
      int newStatus = currentStatus + 1;

      await firestore.collection('users').doc(userId).update({
        'badges': newBadges,
        'totalReports': newTotalReports,
        'updatedAt': DateTime.now(),
      });

      await firestore
          .collection('leaderboards')
          .doc(userId)
          .update({'badges': newBadges});

      await firestore
          .collection(reportsCollectionName)
          .doc(reportsId)
          .update({'status': newStatus});
      return true;
    } catch (e) {
      print('$e');

      throw e.toString();
    }
  }

  Future<void> reportsFixed(MediaUrl mediaUrl,
      {String? documentId, String? description}) async {
    String reportsFixedId = const Uuid().v1();

    try {
      final reports = await getReports(documentId!);

      final reportsId = reports.reportsId;

      await firestore.collection('reports_fixed').doc(reportsFixedId).set({
        'statusReportsId': reportsFixedId,
        'reportsId': reportsId,
        'mediaUrl': {mediaUrl.imageUrl, mediaUrl.videoUrl},
        'description': description,
      });

      await firestore
          .collection(reportsCollectionName)
          .doc(documentId)
          .update({'status': 2});
    } catch (e) {
      throw e.toString(); // Return error message as String
    }
  }
}
