import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:technischer_dienst/Repositories/Repository.dart';

class ImageRepository implements Repository{

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  create(String filename) async {
    final path = await _localPath;

    File file = File("$path/$filename");
    file.create();
  }

  @override
  delete(String filename) async {
    final path = await _localPath;
    final File file = File("$path/$filename");
    file.delete();
  }

  @override
  Future<File> get(String filename) async {
    final path = await _localPath;
    final File file = File("$path/$filename");

    if(file.existsSync()){
      return file;
    } else{
      throw PathNotFoundException("$path/$filename", const OSError(), "file does not exist");
    }

  }

  @override
  update(String filename, data) async {
    final path = await _localPath;
    final File file = File("$path/$filename");

    file.writeAsBytes(data);

  }

  @override
  write(String filename, data) async {
    final path = await _localPath;
    final File file = File("$path/$filename");
    debugPrint("$path/$filename");
    file.writeAsBytes(data);
  }

  @override
  Future<bool> exists(String filename) async {
    final path = await _localPath;
    return File("$path/$filename").existsSync();
  }


}