import 'package:technischer_dienst/features/templates/data/templateRepository.dart';

import '../domain/template.dart';

class TemplateService {
  final TemplateRepository repo;

  int _maxId = 0;
  final List<Template> templates = List.empty(growable: true);

  TemplateService({required this.repo}) {
    repo.retrieveData().then((value) {
      templates.addAll(value);
      templates.sort();
      _maxId = templates.last.id;
    });
  }

  add(Template template) {
    Template newTemplate = Template(
        id: _maxId + 1,
        name: template.name,
        image: template.image,
        categories: template.categories);

    templates.add(newTemplate);
    templates.sort();
    _maxId++;
  }

  delete(Template template) {
    templates.removeWhere((e) => e.id == template.id);
  }

  bool exists(Template template) {
    return templates.any((e) => e.id == template.id);
  }

  Template getById(int id) {
    return templates.firstWhere((e) => e.id == id);
  }

  List<Template> getAll() {
    return templates;
  }

  update(Template template) {
    int index = templates.indexWhere((element) => element.id == template.id);

    if(index == -1){
      add(template);
    } else{
      templates[index] = template;
    }
  }

  saveImage(){}
}
