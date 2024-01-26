import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:technischer_dienst/Controller/FileHandler.dart';

import '../Components/dynamicForm.dart';

class EditReportsPage extends StatefulWidget {
  const EditReportsPage(
      {super.key,
      this.templateFilename,
      this.title = "Berichtsvorlage erstellen"});

  @override
  State<StatefulWidget> createState() => _EditReportsPageState();

  final String title;
  final String? templateFilename;
}

class _EditReportsPageState extends State<EditReportsPage> {
  List<CategoryDataModel> tabs = List.empty(growable: true);

  @override
  void initState() {
    super.initState();

    if (widget.templateFilename != null) {
      getJsonFileData(widget.templateFilename!).then((value) {
        if (value != null) {
          for (var element in value) {
            tabs.add(CategoryDataModel(
                categoryName: element['name'], items: element['items']));
          }
          setState(() {
            tabs;
          });
        }
      });
    }
  }

  Future<void> buildDialog() {
    TextEditingController addController = TextEditingController();
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:const Text("Kategorie hinzufügen"),
            content: TextFormField(
              controller: addController,
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
    String filename = '${widget.title}Template';
    print(jsonEncode(tabs));
    writeToJson(jsonEncode(tabs), filename);
    await appendToJson( '{"templateName": "${widget.title}", "filename": "$filename"}', 'TemplateTracker');

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

   Map<String,dynamic> toJson() {
     return {'name' : categoryName, 'items' : items };
   }

}
