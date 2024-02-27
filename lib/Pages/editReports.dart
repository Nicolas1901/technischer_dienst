import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:technischer_dienst/Constants/Filenames.dart';
import 'package:technischer_dienst/Models/ReportCategory.dart';
import 'package:technischer_dienst/Models/template.dart';
import 'package:technischer_dienst/Models/templatesModel.dart';
import 'package:technischer_dienst/Repositories/FileRepository.dart';
import '../Components/dynamicForm.dart';

class EditReportsPage extends StatefulWidget {
  const EditReportsPage(
      {super.key, this.templateExists = false, required this.template});

  @override
  State<StatefulWidget> createState() => _EditReportsPageState();

  final bool templateExists;
  final Template template;
}

class _EditReportsPageState extends State<EditReportsPage> {
  List<ReportCategory> tabs = List.empty(growable: true);

  final FileRepository _fileRepository = FileRepository();

  @override
  void initState() {
    super.initState();

    setState(() {
      tabs = widget.template.categories;
    });
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
      tabs.add(ReportCategory(categoryName: name, itemData: []));
    });
  }

  Future<void> createTemplateJson() async {
    TemplatesModel model = context.read<TemplatesModel>();
    Template tmp;
    if (widget.templateExists) {
       tmp = Template(
          id: widget.template.id,
          name: widget.template.name,
          image: widget.template.image,
          categories: widget.template.categories);
    } else{
      tmp = Template(
          id: model.setId,
          name: widget.template.name,
          image: widget.template.image,
          categories: widget.template.categories);
    }
    model.update(tmp);
    _fileRepository.writeFile(Filenames.TEMPLATES, jsonEncode(model.templates));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
      length: tabs.length + 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.template.name),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              for (ReportCategory category in tabs) ...{
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
            for (ReportCategory category in tabs) ...{
              dynamic_form(
                templateData: category.items.map((e) => e.itemName).toList(),
                onAddedItem: (String itemName) {
                  setState(() {
                    category.items.add(
                        CategoryItem(itemName: itemName, isChecked: false));
                  });
                },
                onDeletedItem: (int index) {
                  setState(() {
                    category.items.removeAt(index);
                  });
                },
                onUpdateItem: (int index, String itemName) {
                  category.items[index].itemName = itemName;
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
            createTemplateJson().then((value) {
              Navigator.of(context).pop();
            });
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
