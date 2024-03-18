import 'package:technischer_dienst/features/templates/domain/template.dart';

class TemplateCategory{
  final String categoryName;
  final List<String> items;

//<editor-fold desc="Data Methods">
  const TemplateCategory({
    required this.categoryName,
    required this.items,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TemplateCategory &&
          runtimeType == other.runtimeType &&
          categoryName == other.categoryName &&
          items == other.items);

  @override
  int get hashCode => categoryName.hashCode ^ items.hashCode;

  @override
  String toString() {
    return 'TemplateCategory{' + ' categoryName: $categoryName,' + ' items: $items,' + '}';
  }

  TemplateCategory copyWith({
    String? categoryName,
    List<String>? items,
  }) {
    return TemplateCategory(
      categoryName: categoryName ?? this.categoryName,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryName': this.categoryName,
      'items': this.items,
    };
  }

  factory TemplateCategory.fromMap(Map<String, dynamic> map) {
    return TemplateCategory(
      categoryName: map['categoryName'] as String,
      items: List<String>.from(map['items']),
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'categoryName': this.categoryName,
      'items': this.items,
    };
  }

  TemplateCategory.fromJson(Map<String, dynamic> json)
    : categoryName = json['categoryName'] as String,
      items = List<String>.from(json['items']);



//</editor-fold>
}