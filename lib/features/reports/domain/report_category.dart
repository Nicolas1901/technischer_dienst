class ReportCategory {
  String categoryName;
  List<CategoryItem> items = List.empty(growable: true);

  ReportCategory({
    required this.categoryName,
    required List<String> itemData,
  }) {
    for (String item in itemData) {
      items.add(CategoryItem(itemName: item, isChecked: false));
    }
  }

  ReportCategory._copy({required this.categoryName, required this.items});

  ReportCategory.fromJson(Map<String, dynamic> json)
      : categoryName = json['categoryName'],
        items = List<dynamic>.from(json['items']).map((e) =>
            CategoryItem.fromJson(e)).toList();

  Map<String, dynamic> toJson() {
    return {"categoryName": categoryName, "items": items};
  }

  ReportCategory copyWith({String? categoryName, List<CategoryItem>? items}) {
    return ReportCategory._copy(
        categoryName: categoryName ?? this.categoryName,
        items: items ?? this.items);
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryName': this.categoryName,
      'items': List<Map<String, dynamic>>.from(items.map((c) => c.toMap()))
    };
  }
}

class CategoryItem {
  String itemName;
  bool? isChecked;
  String comment;

  CategoryItem({
    required this.itemName,
    required this.isChecked,
    this.comment = "",
  });

  CategoryItem.fromJson(Map<String, dynamic> json)
      : itemName = json['name'],
        isChecked = json['isChecked'],
        comment = json['comment'];

  Map<String, dynamic> toJson() {
    return {"name": itemName, "isChecked": isChecked, "comment": comment};
  }

  CategoryItem copyWith({String? itemName, bool? isChecked, String? comment}) {
    return CategoryItem(
        itemName: itemName ?? this.itemName,
        isChecked: isChecked ?? this.isChecked,
        comment: comment ?? this.comment);
  }

  Map<String, dynamic> toMap() {
    return {
      'itemName': this.itemName,
      'isChecked': this.isChecked,
      'comment': this.comment,
    };
  }
}