import 'dart:io';
import 'package:path_provider/path_provider.dart';
//TODO if platform is Windows erstelle einen Ordner für Templates und Reports
class FileRepository {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  void createFile(String filename) async{
    final path = await _localPath;
    File('$path/$filename').create(exclusive: true).then((value){
      writeFile(filename, "[]");
    }).onError((error, stackTrace) => null);
  }

  Future<File> writeFile(String filename, String data,
      {bool append = false}) async {
    final path = await _localPath;
    final file = File('$path/$filename');
    if (append) {
      return file.writeAsString(data, mode: FileMode.append);
    }
    return file.writeAsString(data);
  }

  Future<String> readFile(String filename) async {
    final path = await _localPath;
    final file = File('$path/$filename');
    try {
      return await file.readAsString();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeFile(String filename) async {
    final path = await _localPath;
    final file = File('$path/$filename');

    if (await file.exists()) {
      file.delete();
    } else {
      throw PathNotFoundException(path, const OSError(), "File does not exist");
    }
  }

  bool fileExists(String filename){
    if(File('$_localPath/$filename').existsSync()){
      return true;
    }
    return false;
  }
}
