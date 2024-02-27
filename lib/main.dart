import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:technischer_dienst/Components/dialog.dart';
import 'package:technischer_dienst/Components/report_card.dart';
import 'package:technischer_dienst/Constants/Filenames.dart';
import 'package:technischer_dienst/Models/template.dart';
import 'package:technischer_dienst/Models/templatesModel.dart';
import 'package:technischer_dienst/Pages/CreateReports.dart';
import 'package:technischer_dienst/Pages/ReportList.dart';
import 'package:technischer_dienst/Pages/editReports.dart';
import 'package:technischer_dienst/Repositories/FileRepository.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => TemplatesModel(),
    child: const MyApp(),
  ));
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
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fileRepo.createFile(Filenames.REPORTS);
    _fileRepo.createFile(Filenames.TEMPLATES);
    try {
      _fileRepo.readFile(Filenames.TEMPLATES).then((value) {
        List<Template> tmpList = List<dynamic>.from(jsonDecode(value))
            .map((e) => Template.fromJson(e))
            .toList();
        context.read<TemplatesModel>().setup(tmpList);
      });
    } on PathNotFoundException {
      debugPrint("TemplateTracker.json does not exist");
    }
  }

  void openEditReportPage(int id) {
    debugPrint(id.toString());
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => EditReportsPage(
                template: context.read<TemplatesModel>().getWhere(id),
                templateExists: true,
              )),
    );
  }

  deleteTemplateNew(Template template) {
    Provider.of<TemplatesModel>(context, listen: false).delete(template);
    _fileRepo.writeFile(
        Filenames.TEMPLATES,
        jsonEncode(
            Provider.of<TemplatesModel>(context, listen: false).templates));
  }

  //TODO refactor delete Method
  //Delete Function for popupmenu

  Future<void> buildDialog() {
    TextEditingController addController = TextEditingController();
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
              onSave: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditReportsPage(
                      template: Template(
                        id: 0,
                        name: addController.text,
                        image: "",
                        categories: [],
                      ),
                    ),
                  ));
                }
              },
              onAbort: () {
                Navigator.of(context).pop();
              },
              title: "Neue Vorlage",
              child: Form(
                key: formKey,
                child: TextFormField(
                  controller: addController,
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Titel darf nicht leer sein";
                    }
                    return null;
                  },
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Text("Technischer Dienst"),
            ),
            ListTile(
                title: const Text("Berichte"),
                leading: const Icon(Icons.file_copy),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ReportList()));
                })
          ],
        ),
      ),
      body: Center(
        child: Consumer<TemplatesModel>(
          builder:
              (BuildContext context, TemplatesModel model, Widget? child) =>
                  ListView(
            children: [
              for (Template tmp in model.templates) ...{
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CreateReportPage(
                        template: tmp,
                      ),
                    ));
                  },
                  child: CardExample(
                    reportTitle: tmp.name,
                    onEdit: () {
                      openEditReportPage(tmp.id);
                    },
                    onDelete: () {
                      deleteTemplateNew(tmp);
                    },
                  ),
                ),
              }
            ],
          ),
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
