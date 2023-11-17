import 'package:fin_app/features/root/data/models/report_models.dart';
import 'package:tabler/tabler.dart';

class DebugFunction {
  void reportsModelDebug(ReportsModel reportsModel) {
    final table = Tabler(
      header: ['Field', 'Value'],
      data: [
        ['Reports ID', reportsModel.reportsId ?? ''],
        ['Date Published', reportsModel.datePublished?.toString() ?? ''],
        ['Updated At', reportsModel.updatedAt?.toString() ?? ''],
      ],
    );

    if (reportsModel.userData != null) {
      table.add(['User ID', reportsModel.userData!.userId ?? '']);
      table.add(['Username', reportsModel.userData!.username ?? '']);
      table.add(['Jabatan', reportsModel.userData!.jabatan ?? '']);
      table.add(
          ['Profile Photo URL', reportsModel.userData!.profilePhotoUrl ?? '']);
    }

    if (reportsModel.reportsData != null) {
      table.add(['Campus', reportsModel.reportsData!.campus ?? '']);
      table.add(['Location', reportsModel.reportsData!.location ?? '']);
      table.add(['Status', reportsModel.reportsData!.status ?? '']);
      table.add([
        'Reports Description',
        reportsModel.reportsData!.reportsDescription ?? ''
      ]);
      table.add([
        'Fixed Description',
        reportsModel.reportsData!.fixedDescription ?? ''
      ]);
    }

    if (reportsModel.mediaUrl != null) {
      if (reportsModel.mediaUrl!.imageUrls != null) {
        table.add(['Image URLs', reportsModel.mediaUrl!.imageUrls!.join('\n')]);
      }

      if (reportsModel.mediaUrl!.videoUrl != null) {
        table.add(['Video URL', reportsModel.mediaUrl!.videoUrl ?? '']);
      }

      if (reportsModel.mediaUrl!.fixedImageUrls != null) {
        table.add([
          'Fixed Image URLs',
          reportsModel.mediaUrl!.fixedImageUrls!.join('\n')
        ]);
      }

      if (reportsModel.mediaUrl!.fixedVideoUrl != null) {
        table.add(
            ['Fixed Video URL', reportsModel.mediaUrl!.fixedVideoUrl ?? '']);
      }
    }

    print('Reports Data:');
    print(table);
  }

  Future<void> listReportsModelDebug(
      List<ReportsModel> listReportsModel, String role,
      {String? username, String? campus}) async {
    try {
      final List<ReportsModel> listReportsData = listReportsModel;

      if (role == "all" || role == "admin") {
        print('Semua Data Laporan:');
      } else if (role == "pelapor") {
        print('Laporan yang dibuat oleh $username');
      } else if (role == "teknisi") {
        print('Laporan Di $campus');
      } else {
        throw ArgumentError("Invalid Role");
      }
      for (final reportsModel in listReportsData) {
        reportsModelDebug(reportsModel);
      }
    } catch (e) {
      print('Error fetching ReportsModels: $e');
    }
  }
}
