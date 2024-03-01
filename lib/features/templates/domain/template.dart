import 'dart:convert';

import 'package:pocketbase/pocketbase.dart';

import '../../../shared/domain/ReportCategory.dart';

class Template{

  final String id;
  final String name;
  final String image;
  final List<ReportCategory> categories;

  Template({
    required this.id,
    required this.name,
    this.image = "",
    required this.categories,
  });

  Template.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        image = json['image'],
        categories = List<dynamic>.from(json['categoryList']).map((e) => ReportCategory.fromJson(e)).toList();

  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'name': name,
      'image': image,
      'categoryList': categories
    };
  }

  factory Template.fromRecord(RecordModel record, url){
    return Template(
        id: record.getStringValue('id'),
        name: record.getStringValue('name'),
        categories: List.from(jsonDecode(record.getStringValue('categories'))).map((e) => ReportCategory.fromJson(e)).toList(),
        image: url
    );
  }

  setImage(String url){
    Template(id: this.id, name: this.name, categories: this.categories, image: url);
  }

}