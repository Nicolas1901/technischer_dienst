import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:technischer_dienst/features/templates/application/editTemplateBloc/edit_template_bloc.dart';
import 'package:technischer_dienst/features/templates/application/templateBloc/template_bloc.dart';
import 'package:technischer_dienst/shared/domain/ReportCategory.dart';
import 'package:technischer_dienst/features/templates/domain/template.dart';
import '../../../shared/presentation/components/dialog.dart';
import 'components/dynamicForm.dart';

class EditTemplatePage extends StatefulWidget {
  const EditTemplatePage(
      {super.key, this.templateExists = false, required this.template});

  @override
  State<StatefulWidget> createState() => _EditTemplatePageState();

  final bool templateExists;
  final Template template;
}

class _EditTemplatePageState extends State<EditTemplatePage> {
  List<ReportCategory> tabs = List.empty(growable: true);
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    setState(() {
      tabs = widget.template.categories;
    });
  }

  Future<void> buildDialog(EditTemplateBloc editTemplateBloc) {
    TextEditingController addController = TextEditingController();
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            title: "Kategorie hinzufügen",
            child: Form(
              key: formKey,
              child: TextFormField(
                controller: addController,
                autofocus: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Kategoriename darf nicht leer sein";
                  }
                  return null;
                },
              ),
            ),
            onAbort: () {
              Navigator.of(context).pop();
            },
            onSave: () {
              if (formKey.currentState!.validate()) {
                ReportCategory category = ReportCategory(
                    categoryName: addController.text, itemData: []);
                
                editTemplateBloc.add(AddCategory(category: category));
                debugPrint("Added Categorie");
                //addCategory(addController.text);
                Navigator.of(context).pop();
              }
            },
          );
        });
  }

  void addCategory(String name) {
    setState(() {
      tabs.add(ReportCategory(categoryName: name, itemData: []));
    });
  }

  createTemplateJson() {
    Template tmp;
    if (widget.templateExists) {
      tmp = Template(
          id: widget.template.id,
          name: widget.template.name,
          image: widget.template.image,
          categories: widget.template.categories);
      context.read<TemplateBloc>().add(UpdateTemplate(template: tmp));
    } else {
      tmp = Template(
          id: "",
          name: widget.template.name,
          image: widget.template.image,
          categories: widget.template.categories);
      context.read<TemplateBloc>().add(AddTemplate(template: tmp));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          EditTemplateBloc()..add(EditTemplateLoad(template: widget.template)),
      child: Scaffold(body: BlocBuilder<EditTemplateBloc, EditTemplateState>(
        builder: (context, state) {
          if (state is EditTemplatesLoaded) {
            return DefaultTabController(
              length: state.template.categories.length + 1,
              child: Scaffold(
                appBar: AppBar(
                  title: Text(state.template.name),
                  bottom: TabBar(
                    isScrollable: true,
                    tabs: [
                      for (ReportCategory category
                          in state.template.categories) ...{
                        Tab(
                          text: category.categoryName,
                        ),
                      },
                      Tab(
                        child: TextButton(
                          child: const Text("Kategorie hinzufügen +"),
                          onPressed: () {
                            buildDialog(context.read<EditTemplateBloc>());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    for (final (catIndex, category)
                        in state.template.categories.indexed) ...{
                      dynamic_form(
                        templateData:
                            category.items.map((e) => e.itemName).toList(),
                        onAddedItem: (String itemName) {
                          final item = CategoryItem(
                              itemName: itemName, isChecked: false);

                          setState(() {
                            category.items.add(item);
                          });

                          context.read<EditTemplateBloc>().add(
                              AddItemToCategory(item: item, index: catIndex));
                        },
                        onDeletedItem: (int index) {
                          setState(() {
                            category.items.removeAt(index);
                          });
                          context.read<EditTemplateBloc>().add(
                              DeleteItemFromCategory(
                                  categoryIndex: catIndex, itemIndex: index));
                        },
                        onUpdateItem: (int index, String itemName) {
                          category.items[index].itemName = itemName;
                          context.read<EditTemplateBloc>().add(
                              UpdateItemInCategory(
                                  categoryIndex: catIndex,
                                  itemIndex: index,
                                  itemName: itemName));
                        },
                      ),
                    },
                    TextButton(
                      child: const Text("Kategorie hinzufügen +"),
                      onPressed: () {
                        buildDialog(context.read<EditTemplateBloc>());
                      },
                    ),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  child: const Icon(Icons.save),
                  onPressed: () {
                    createTemplateJson();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            );
          }

          if (state is EditTemplateLoading) {
            return const CircularProgressIndicator();
          } else {
            return const Text("Etwas ist schief gelaufen");
          }
        },
      )),
    );
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
