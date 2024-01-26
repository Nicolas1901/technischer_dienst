import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

Future<List?> getJsonFileData(String filename) async {
  String jsonData = await readFile(filename);
  final List parsedJson;
  if (jsonData.isNotEmpty) {
    parsedJson = jsonDecode(jsonData);
    print(parsedJson);

    return parsedJson;
  } else{
    return List.empty();
  }
  //return null when file is empty
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
  debugPrint("Wrote to file: $filename");
  return file.writeAsString(jsonData);
}

Future<void> removeFile(String filename) async {
  final path = await _localPath;
  final file = File('$path/$filename.json');
  if(file.existsSync()) {
    file.delete();
  }
  getJsonFileData('templateTracker.json').then((value) => {
        if (value != null && value.isNotEmpty)
          {
            value.removeWhere(
                (element) => element['filename'].toString() == filename),
            writeToJson(value.toString(), 'templateTracker')
          }
      });
}

Future<File> appendToJson(String jsonData, String filename) async {
  final path = await _localPath;
  final file = File('$path/$filename.json');
  return await readFile('$filename.json').then((trackerData) {
    if(trackerData.isEmpty){
      debugPrint("file is empty");
      return file.writeAsString('[$jsonData]');
    }
    trackerData = trackerData.replaceFirst(RegExp('}]'), '},$jsonData]');
    return file.writeAsString(trackerData);
  });

}