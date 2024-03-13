import 'package:technischer_dienst/shared/domain/report_category.dart';

import '../../domain/report.dart';

class MockReports {
  static List<Report> generate() {
    final List<Report> mockReports = [
      Report(
          id: "1",
          reportName: "Bericht1",
          inspector: "Nico",
          ofTemplate: "HLF",
          from: DateTime.now(),
          categories: [
            ReportCategory(
                categoryName: "Kategorie1",
                itemData: ["Item1", "Item2", "Item3", "Item4", "Item5"]),
            ReportCategory(
                categoryName: "Kategorie2",
                itemData: ["Item1", "Item2", "Item3", "Item4", "Item5"])
          ]),
      Report(
          id: "2",
          reportName: "Bericht2",
          inspector: "Raphael",
          ofTemplate: "MTF",
          from: DateTime.now(),
          categories: [
            ReportCategory(
                categoryName: "Kategorie1",
                itemData: ["Item1", "Item2", "Item3", "Item4", "Item5"]),
            ReportCategory(
                categoryName: "Kategorie2",
                itemData: ["Item1", "Item2", "Item3", "Item4", "Item5"]),
            ReportCategory(
                categoryName: "Kategorie3",
                itemData: ["Item1", "Item2", "Item3", "Item4", "Item5","Item6", "Item7", "Item8", "Item9", "Item10"])
          ]),
    ];

    mockReports[0].categories[0].items[0].isChecked = true;
    mockReports[0].categories[0].items[0].comment = "Kommentar";
    mockReports[0].categories[0].items[3].isChecked = true;
    mockReports[1].categories[2].items[0].isChecked = true;
    mockReports[1].categories[2].items[1].isChecked = true;
    mockReports[1].categories[2].items[2].isChecked = true;
    mockReports[1].categories[2].items[5].isChecked = true;
    mockReports[1].categories[2].items[7].isChecked = true;
    mockReports[1].categories[2].items[9].isChecked = true;

    return mockReports;
  }
}
