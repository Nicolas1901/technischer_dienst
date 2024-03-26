import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'report_category.dart';

class Report {
  final String id;
  final String reportName;
  final String inspector;
  final String ofTemplate;
  final DateTime from;
  final bool isLocked;
  final List<ReportCategory> categories;

  Report(
      {required this.id,
      required this.reportName,
      required this.inspector,
      required this.ofTemplate,
      required this.from,
      required this.categories,
      required this.isLocked});

  Report.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        reportName = json['reportName'],
        inspector = json['inspector'],
        from = DateTime.parse(json['date']),
        categories = List<dynamic>.from(json['categoryList'])
            .map((e) => ReportCategory.fromJson(e))
            .toList(),
        ofTemplate = json['template'],
        isLocked = json['isLocked'];

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "reportName": reportName,
      "inspector": inspector,
      "template": ofTemplate,
      "date": from.toString().replaceRange(19, null, ""),
      "categoryList": jsonEncode(categories),
      "isLocked": isLocked
    };
  }

  factory Report.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Report(
        reportName: data?['reportName'],
        id: snapshot.reference.id,
        inspector: data?['inspector'],
        ofTemplate: data?['template'],
        from: DateTime.parse(data?['date']),
        categories: List<dynamic>.from(jsonDecode(data?['categoryList']))
            .map((e) => ReportCategory.fromJson(e))
            .toList(),
        isLocked: data?['isLocked']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "reportName": reportName,
      "inspector": inspector,
      "template": ofTemplate,
      "date": from.toString().replaceRange(19, null, ""),
      "categories":
          List<Map<String, dynamic>>.from(categories.map((c) => c.toMap())),
      "isLocked": isLocked,
    };
  }

  Report copyWith(
      {String? id,
      String? reportName,
      String? inspector,
      String? ofTemplate,
      DateTime? from,
      List<ReportCategory>? categories,
      bool? isLocked}) {
    return Report(
        id: id ?? this.id,
        reportName: reportName ?? this.reportName,
        inspector: inspector ?? this.inspector,
        ofTemplate: ofTemplate ?? this.ofTemplate,
        from: from ?? this.from,
        categories: categories ?? this.categories,
        isLocked: isLocked ?? this.isLocked);
  }
}
