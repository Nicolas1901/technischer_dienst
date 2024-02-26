import 'package:flutter/cupertino.dart';
import 'package:technischer_dienst/Models/template.dart';

class TemplatesModel with ChangeNotifier{
  List<Template> templates = List.empty(growable: true);

  void setup(List<Template> list){
    templates = list;
    templates.sort();
  }

  void add(Template template){
    templates.add(template);
  }

  void delete(Template template){
    templates.removeWhere((element) => element.id == template.id);
  }

  void update(Template template){
    templates.indexWhere((element) => element.id == template.id);
  }

}