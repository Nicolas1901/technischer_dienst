import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:technischer_dienst/Constants/Filenames.dart';
import 'package:technischer_dienst/features/templates/domain/template.dart';

class TemplateRepository{
  final String filename = Filenames.TEMPLATES;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return "${directory.path}/$filename";
  }

  Future<List<Template>> retrieveData() async {
    String path = await _localPath;

    final File file = File(path);
    List<Template> templates = jsonDecode(file.readAsStringSync());

    return templates;
  }

  Future<void> writeData(List<Template> templates) async {
    String path = await _localPath;
    final File file = File(path);

    file.writeAsString(jsonEncode(templates));
  }
}