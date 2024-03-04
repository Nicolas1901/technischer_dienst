import 'dart:io';

import 'package:pocketbase/pocketbase.dart';
import 'package:technischer_dienst/features/templates/domain/template.dart';
import 'package:http/http.dart';

class TemplateRepository {
  final PocketBase pb;
  final String tableName = 'templates';

  TemplateRepository({
    required this.pb,
  });

  void add(Template template) {
    if(template.image.isEmpty){
      pb.collection(tableName).create(body: template.toJson(),);
    } else{
      final File image = File(template.image);
      pb.collection(tableName).create(body: template.toJson(), files: [
        MultipartFile.fromBytes('image', image.readAsBytesSync()),
      ]);
    }

  }

  void update(Template template, {File? file}) {
    if(file == null){
      pb.collection(tableName).update(template.id, body: template.toJson(),);
    }else{
      final File image = File(template.image);
      pb.collection(tableName).update(template.id, body: template.toJson(), files: [
        MultipartFile.fromBytes('image', file.readAsBytesSync(),),
      ]);
    }

  }

  void delete(String id) {
    pb.collection(tableName).delete(id);
  }

  Future<Template> get(String id) async {
    final record = (await pb.collection(tableName).getOne(id));
    final String url = pb.files.getUrl(record, record.getStringValue('image')).path;

    Template tmp = Template.fromRecord(record, url);

    return tmp;
  }

  Future<List<Template>> getAll() async {
    final List<RecordModel> record =
        (await pb.collection(tableName).getFullList());

    List<Template> templates = List<RecordModel>.from(record)
        .map((e) => Template.fromRecord(e, pb.files.getUrl(e, e.getStringValue('image')).path))
        .toList();
    return templates;
  }
}
