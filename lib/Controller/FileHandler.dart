import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<List?> getJsonFileData(String filename) async {
  String jsonData = await readFile(filename);
  final List parsedJson;
  if (jsonData.isNotEmpty) {
    parsedJson = jsonDecode(jsonData);
    print(parsedJson);

    return parsedJson;
  }
  return null;
}

Future<String> readFile(String filename) async {
  try {
    final path = await _localPath;
    final file = File('$path/$filename');

    return await file.readAsString();
  } catch (e) {
    return "";
  }
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> writeToJson(String jsonData, String filename) async {
  final path = await _localPath;
  final file = File('$path/$filename.json');
  return file.writeAsString(jsonData);
}

Future<void> removeFile(String filename) async {
  final path = await _localPath;
  final file = File('$path/$filename.json');
  if(file.existsSync()) {
    file.delete();
  }
  getJsonFileData('templateTracker.json').then((value) => {
        if (value != null)
          {
            value.removeWhere(
                (element) => element['filename'].toString() == filename)
          }
      });
}
