import '../data/templateRepository.dart';
import '../domain/template.dart';

class TemplateController {
  final TemplateRepository repository;

  TemplateController({required this.repository});

 Future<List<Template>> getTemplates() async {
   return await repository.getAll();
 }

}
