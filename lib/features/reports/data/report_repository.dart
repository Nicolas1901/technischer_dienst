import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/report.dart';

class ReportRepository {
  final FirebaseFirestore firestore;
  late final CollectionReference<Report> _reportsRef;

  ReportRepository({required this.firestore}) {
    _reportsRef = firestore.collection('reports').withConverter(
        fromFirestore: Report.fromFirestore,
        toFirestore: (Report report, _) => report.toJson());
  }

  Future<Report> get(String uid) async {
    try {
      final snapshot = await _reportsRef.doc(uid).get();

      final Report report = snapshot.data()!;
      return report;
    } on Exception {
      rethrow;
    }
  }

  Future<List<Report>> getAll() async {
    try {
      final reportQuery = await _reportsRef.get();

      final List<Report> templates = List.empty(growable: true);

      for (QueryDocumentSnapshot<Report> snapshot in reportQuery.docs) {
        templates.add(snapshot.data());
      }
      return templates;
    } on Exception {
      rethrow;
    }
  }

  update(Report report) {
    _reportsRef.doc(report.id).set(report);
  }

  Future<DocumentReference> add(Report report) async {
    try {
      return await _reportsRef.add(report);
    } on Exception {
      rethrow;
    }
  }

  delete(String uid) {
    try {
      _reportsRef.doc(uid).delete();
    } on Exception {
      rethrow;
    }
  }

  changeLockState(String uid, bool isLocked){
    try{
      _reportsRef.doc(uid).update({"isLocked": isLocked});
    } on Exception{
      rethrow;
    }
  }
}
