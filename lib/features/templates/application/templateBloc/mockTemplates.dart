import 'package:technischer_dienst/shared/domain/report_category.dart';

import '../../domain/template.dart';

class MockTemplates{
  static List<Template> generate(){
    return [
      Template(
          id: "1",
          name: "HLF",
          categories: [
            ReportCategory(
                categoryName: "Kategorie1",
                itemData: ["HLF1", "HLF2", "HLF3"]
            ),
            ReportCategory(
                categoryName: "Kategorie2",
                itemData: ["HLF2.1", "HLF2.2", "HLF2.3"]
            )
      ]),
      Template(
          id: "2",
          name: "MTF",
          categories: [
            ReportCategory(
                categoryName: "KategorieMTF1",
                itemData: ["MTF1", "MTF2", "MTF3"]),
            ReportCategory(
                categoryName: "KategorieMTF2",
                itemData: ["MTF2.1", "MTF2.2", "MTF2.3"])
          ])
    ];
  }
}