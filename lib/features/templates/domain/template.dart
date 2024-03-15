import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pocketbase/pocketbase.dart';

import '../../../shared/domain/report_category.dart';
import 'template_category.dart';

class Template {
  final String id;
  final String name;
  final String image;
  final List<TemplateCategory> categories;

  Template({
    required this.id,
    required this.name,
    this.image = "",
    required this.categories,
  });

  Template.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        name = json['name'],
        image = json['image'],
        categories = List<dynamic>.from(json['categoryList'])
            .map((e) => TemplateCategory.fromMap(e))
            .toList();

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'image': image, 'categoryList': categories};
  }

  factory Template.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return Template(
        id: snapshot.reference.id,
        name: data?['name'],
        image: data?['image'],
        categories: List<dynamic>.from(data?['categories']).map((e) => TemplateCategory.fromMap(e)).toList());
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "image": image,
      "categories": List<Map<String, dynamic>>.from(categories
          .map((c) => [c.categoryName, c.items]))
    };
  }

  setImage(String url) {
    Template(
        id: this.id, name: this.name, categories: this.categories, image: url);
  }

  Template copyWith(
      {String? name, String? image, List<TemplateCategory>? categories}) {
    return Template(
        id: this.id,
        name: name ?? this.name,
        categories: categories ?? this.categories,
        image: image ?? this.image);
  }
}
