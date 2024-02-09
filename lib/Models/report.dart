import 'dart:convert';

import 'ReportCategory.dart';

class Report {
  final int id;
  final String reportName;
  final String inspector;
  final String ofTemplate;
  final DateTime from;
  final List<ReportCategory> categories;

  Report(
      {required this.id,
      required this.reportName,
      required this.inspector,
      required this.ofTemplate,
      required this.from,
      required this.categories});

  Report.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        reportName = json['reportName'],
        inspector = json['inspector'],
        from = DateTime.parse(json['date']),
        categories = List<dynamic>.from(json['categoryList'])
            .map((e) => ReportCategory.fromJson(e))
            .toList(),
        ofTemplate = json['template'];

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "reportName": reportName,
      "inspector": inspector,
      "template": ofTemplate,
      "date": from.toString().replaceRange(19, null, ""),
      "categoryList": categories
    };
  }
}
