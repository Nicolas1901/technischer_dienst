import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:technischer_dienst/Repositories/FileRepository.dart';
import '../Components/dynamicForm.dart';

class EditReportsPage extends StatefulWidget {
  const EditReportsPage(
      {super.key,
      this.templateFilename,
      this.title = "Berichtsvorlage erstellen",
      this.templateExists = false});

  @override
  State<StatefulWidget> createState() => _EditReportsPageState();

  final String title;
  final String? templateFilename;
  final bool templateExists;
}

class _EditReportsPageState extends State<EditReportsPage> {
  List<CategoryDataModel> tabs = List.empty(growable: true);

  final FileRepository _fileRepository = FileRepository();

  @override
  void initState() {
    super.initState();

    if (widget.templateExists) {
      _fileRepository.readFile(widget.templateFilename!).then((value) {
        List<dynamic> jsonData = jsonDecode(value);
        for (var category in jsonData) {
          List<dynamic> items = category['items'];
          tabs.add(CategoryDataModel(
              categoryName: category['name'], items: items.cast<String>()));
        }
        setState(() {
          tabs;
        });
      });
    }
  }

  Future<void> buildDialog() {
    TextEditingController addController = TextEditingController();
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Kategorie hinzufügen"),
            content: TextFormField(
              controller: addController,
              autofocus: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Kategoriename eingeben";
                }
                return null;
              },
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('hinzufügen'),
                onPressed: () {
                  addCategory(addController.text);
                  Navigator.of(context).pop();
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

  void addCategory(String name) {
    setState(() {
      tabs.add(CategoryDataModel(categoryName: name, items: []));
    });
  }

  Future<void> createTemplateJson() async {
    String filename = '${widget.title}Template.json';
    debugPrint('Tabs: ${jsonEncode(tabs)}');

    _fileRepository.writeFile(filename,jsonEncode(tabs));

    //if template is new then write template name and path to TemplateTracker.json
    if (!widget.templateExists) {
      String trackerData = '{"templateName": "${widget.templateFilename}","filename": "$filename"}';
     await _fileRepository.readFile('TemplateTracker.json').then((value) async {
       if(value.isEmpty || value == "[]"){
         debugPrint("file is empty");
         return await _fileRepository.writeFile('TemplateTracker.json','[$trackerData]');
       }
       value = value.replaceFirst(RegExp('}]'), '},$trackerData]');
       return await _fileRepository.writeFile('TemplateTracker.json', value);
     });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
      length: tabs.length + 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              for (CategoryDataModel category in tabs) ...{
                Tab(
                  text: category.categoryName,
                ),
              },
              Tab(
                child: TextButton(
                  child: const Text("Kategorie hinzufügen +"),
                  onPressed: () {
                    buildDialog();
                  },
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            for (CategoryDataModel category in tabs) ...{
              dynamic_form(
                templateData: category.items,
                onAddedItem: (String val) {
                  setState(() {
                    category.items.add(val);
                  });
                },
                onDeletedItem: (int index) {
                  setState(() {
                    category.items.removeAt(index);
                  });
                },
                onUpdateItem: (int index, String val) {
                  category.items[index] = val;
                },
              ),
            },
            TextButton(
              child: const Text("Kategorie hinzufügen +"),
              onPressed: () {
                buildDialog();
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.save),
          onPressed: () {
            createTemplateJson().then((value) => Navigator.of(context).pop());
          },
        ),
      ),
    ));
  }
}

class CategoryDataModel {
  CategoryDataModel({required this.categoryName, required this.items});

  String categoryName;
  List<String> items;

  CategoryDataModel.fromJson(Map<String, dynamic> json)
      : categoryName = json['name'],
        items = json['items'];

  Map<String, dynamic> toJson() {
    return {'name': categoryName, 'items': items};
  }
}
