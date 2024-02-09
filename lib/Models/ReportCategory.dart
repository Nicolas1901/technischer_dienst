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
    return {"categoryName": categoryName, "itemList": items};
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