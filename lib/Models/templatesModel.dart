import 'package:flutter/cupertino.dart';
import 'package:technischer_dienst/Models/template.dart';

class TemplatesModel with ChangeNotifier{
  int _maxId = 0;
  List<Template> templates = List.empty(growable: true);

  int get setId{
    _maxId++;
    return _maxId;
  }

  void setup(List<Template> list){
    templates = list;
    templates.sort();
    if(templates.isNotEmpty){
      _maxId = templates.last.id;
    }
    notifyListeners();
  }

  void add(Template template){
    templates.add(template);
    notifyListeners();
  }

  void delete(Template template){
    templates.removeWhere((element) => element.id == template.id);
    notifyListeners();
  }

  void update(Template template){
    int index = templates.indexWhere((element) => element.id == template.id);

    if (index != -1) {
      templates[index] = template;
      notifyListeners();
    } else {
      //notify is already done in add method
      add(template);
    }
  }

}