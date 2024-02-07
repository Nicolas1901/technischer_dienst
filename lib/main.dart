import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:technischer_dienst/Components/report_card.dart';
import 'package:technischer_dienst/Pages/CreateReports.dart';
import 'package:technischer_dienst/Pages/editReports.dart';
import 'package:technischer_dienst/Repositories/FileRepository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Vorlagen'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _fileRepo = FileRepository();
  List templatePaths = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    try {
      _fileRepo.readFile("TemplateTracker.json").then((value) {
        setState(() {
          templatePaths = jsonDecode(value);
        });
      });
    } on PathNotFoundException catch (e) {
      _fileRepo.writeFile("TemplateTracker.json", '[]');
      debugPrint("TemplateTracker.json does not exist");
    }
  }

  void openEditReportPage(String filename, String templateName) {
    debugPrint(filename);
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => EditReportsPage(
                templateFilename: filename,
                title: templateName,
                templateExists: true,
              )),
    );
  }

  //Delete Function for popupmenu
  void deleteTemplate(String filename) {
    _fileRepo.removeFile(filename);
    _fileRepo.readFile('TemplateTracker.json').then((value) {
      List<dynamic> templates = jsonDecode(value);
      templates.removeWhere((element) {
        return element['filename'] == filename;
      });
      debugPrint(templates.toString());
      _fileRepo.writeFile('TemplateTracker.json', jsonEncode(templates));
      setState(() {
        templatePaths = templates;
      });
    });
  }

  Future<void> buildDialog() {
    TextEditingController addController = TextEditingController();
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Berichtstitel"),
            content: TextFormField(
              controller: addController,
              autofocus: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Titel darf nicht leer sein";
                }
                return null;
              },
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('erstellen'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                    builder: (context) => EditReportsPage(
                      templateFilename: addController.text,
                      title: addController.text,
                    ),
                  ))
                      .then((value) {
                    _fileRepo.readFile("TemplateTracker.json").then((value) {
                      setState(() {
                        templatePaths = jsonDecode(value);
                      });
                    });
                  });
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('abbrechen'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: [
            for (var template in templatePaths) ...{
              GestureDetector(
                onTap: () {
                  debugPrint("Bericht erstellen");
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CreateReportPage(
                        title: template['templateName'],
                        filename: template['filename']),
                  ));
                },
                child: CardExample(
                  reportTitle: template['templateName'],
                  onEdit: () {
                    debugPrint("bearbeiten: ${template['templateName']}");
                    openEditReportPage(
                        template['filename'], template['templateName']);
                  },
                  onDelete: () {
                    debugPrint("löschen: ${template['templateName']}");
                    deleteTemplate(template['filename']);
                  },
                ),
              ),
            }
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          buildDialog();
        },
        tooltip: 'Berichtsvorlage erstellen',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
