import 'package:technischer_dienst/features/reports/domain/report_category.dart';

import '../../domain/template.dart';
import '../../domain/template_category.dart';

class MockTemplates{
  static List<Template> generate(){
    return [
      Template(
          id: "1",
          name: "HLF",
          categories: [
            const TemplateCategory(
                categoryName: "Kategorie1",
                items: ["HLF1", "HLF2", "HLF3"]
            ),
            const TemplateCategory(
                categoryName: "Kategorie2",
                items: ["HLF2.1", "HLF2.2", "HLF2.3"]
            )
      ]),
      Template(
          id: "2",
          name: "MTF",
          categories: [
            const TemplateCategory(
                categoryName: "KategorieMTF1",
                items: ["MTF1", "MTF2", "MTF3"]),
            const TemplateCategory(
                categoryName: "KategorieMTF2",
                items: ["MTF2.1", "MTF2.2", "MTF2.3"])
          ])
    ];
  }
}