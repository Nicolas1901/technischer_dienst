import 'ReportCategory.dart';

class Template implements Comparable<Template> {

  final int id;
  final String name;
  final String image;
  final List<ReportCategory> categories;

  Template({
    required this.id,
    required this.name,
    required this.image,
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

  @override
  int compareTo(Template other) {
    if(id < other.id){
      return -1;
    } else if(id > other.id){
      return 1;
    }
    return 0;
  }
}