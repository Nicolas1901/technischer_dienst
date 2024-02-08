import 'dart:convert';

class Report {
  final int id;
  final String reportName;
  final String inspector;
  final DateTime from;
  final List<ReportCategory> categories;

  Report(
      {required this.id,
      required this.reportName,
      required this.inspector,
      required this.from,
      required this.categories});

  Report.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        reportName = json['reportName'],
        inspector = json['inspector'],
        from = DateTime.parse(json['date']),
        categories = List<dynamic>.from(json['categoryList']).map((e) => ReportCategory.fromJson(e)).toList();

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "reportName": reportName,
      "inspector": inspector,
      "date": from.toString().replaceRange(19, null, ""),
      "categoryList": categories
    };
  }
}

class ReportCategory {
  String categoryName;
  List<CategoryItem> items = List.empty(growable: true);

  ReportCategory({
    required this.categoryName,
    required List<dynamic> itemData,
  }) {
    for (String item in itemData) {
      items.add(CategoryItem(itemName: item, isChecked: false));
    }
  }

  ReportCategory.fromJson(Map<String, dynamic> json)
      : categoryName = json['categoryName'],
        items = List<dynamic>.from(json['itemList']).map((e) => CategoryItem.fromJson(e)).toList();

  Map<String, dynamic> toJson() {
    return {"categoryName": categoryName, "itemList": jsonEncode(items)};
  }
}

class CategoryItem {
  String itemName;
  bool isChecked;

  CategoryItem({
    required this.itemName,
    required this.isChecked,
  });

  CategoryItem.fromJson(Map<String, dynamic> json)
      : itemName = json['name'],
        isChecked = json['isChecked'];

  Map<String, dynamic> toJson() {
    return {"name": itemName, "isChecked": isChecked};
  }
}
