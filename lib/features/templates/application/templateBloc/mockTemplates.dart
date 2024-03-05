import 'package:technischer_dienst/shared/domain/ReportCategory.dart';

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
                itemData: ["Item1", "Item2", "Item3"]
            ),
            ReportCategory(
                categoryName: "Kategorie2",
                itemData: ["Item1", "Item2", "Item3"]
            )
      ]),
      Template(
          id: "2",
          name: "MTF",
          categories: [
            ReportCategory(
                categoryName: "KategorieMTF1",
                itemData: ["Item1", "Item2", "Item3"]),
            ReportCategory(
                categoryName: "KategorieMTF2",
                itemData: ["Item1", "Item2", "Item3"])
          ])
    ];
  }
}