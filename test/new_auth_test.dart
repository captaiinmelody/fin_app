import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_app/features/root/data/datasources/report_sources.dart';
import 'package:fin_app/features/root/data/models/report_models.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:mockito/mockito.dart';

import 'mocks.dart';

class MockFirestore extends Mock implements FirebaseFirestore {}

void main() {
  // TestWidgetsFlutterBinding.ensureInitialized(); Gets called in setupFirebaseAuthMocks()
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  test('noteStream returns Stream containing List of Note objects', () async {
    //Define parameters and objects

    final FakeFirebaseFirestore fakeFirebaseFirestore = FakeFirebaseFirestore();

    final ReportsRepository reportsRepository =
        ReportsRepository(firestore: fakeFirebaseFirestore);

    final CollectionReference mockCollectionReference =
        fakeFirebaseFirestore.collection(reportsRepository.collection.path);

    final List<ReportsModel> reportsList = [ReportsModel()];

    // Add data to mock Firestore collection
    for (ReportsModel mockReports in reportsList) {
      await mockCollectionReference.add(mockReports.toMap());
    }

    // Get data from ReportsRepository's noteStream i.e the method being tested
    final Future<List<ReportsModel>> reportStreamFromRepository =
        reportsRepository.getAllReports();

    final List<ReportsModel> actualNoteList =
        await reportStreamFromRepository.asStream().first;

    final List<ReportsModel> expectedNoteList = reportsList;

    // Assert that the actual data matches the expected data
    expect(actualNoteList, expectedNoteList);
  });
}
