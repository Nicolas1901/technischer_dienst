import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:technischer_dienst/features/templates/application/editTemplateBloc/edit_template_bloc.dart';
import 'package:technischer_dienst/shared/domain/report_category.dart';
import 'package:technischer_dienst/features/templates/domain/template.dart';
import '../../../shared/presentation/components/dialog.dart';
import 'components/dynamic_form.dart';

class EditTemplatePage extends StatefulWidget {
  const EditTemplatePage(
      {super.key, this.templateExists = false, required this.template});

  @override
  State<StatefulWidget> createState() => _EditTemplatePageState();

  final bool templateExists;
  final Template template;
}

class _EditTemplatePageState extends State<EditTemplatePage> {
  final formKey = GlobalKey<FormState>();
  final editCategoryKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    debugPrint("editTemplate init: ${jsonEncode(widget.template)}");
  }

  Future<void> buildDialog() {
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

                context
                    .read<EditTemplateBloc>()
                    .add(AddCategory(category: category));
                debugPrint("Added Categorie");
                Navigator.of(context).pop();
              }
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<EditTemplateBloc, EditTemplateState>(
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
                    for (var (int index, ReportCategory category)
                        in state.template.categories.indexed) ...{
                      Tab(
                          child: GestureDetector(
                              onLongPress: (){
                                openChangeCategoryNameDialog(index, category);
                              },
                              child: Text(category.categoryName)),
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
                  for (final (catIndex, category)
                      in state.template.categories.indexed) ...{
                    DynamicForm(
                      templateData:
                          category.items.map((e) {
                            debugPrint("editTemplate: ${jsonEncode(e)}");
                            return e.itemName;
                          }).toList(),
                      onAddedItem: (String itemName) {
                        final item =
                            CategoryItem(itemName: itemName, isChecked: false);

                        context.read<EditTemplateBloc>().add(
                            AddItemToCategory(item: item, index: catIndex));
                      },
                      onDeletedItem: (int index) {
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
                      buildDialog();
                    },
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.save),
                onPressed: () {
                  if (widget.templateExists) {
                    context
                        .read<EditTemplateBloc>()
                        .add(SaveModifiedTemplate(template: state.template));
                  } else {
                    context
                        .read<EditTemplateBloc>()
                        .add(SaveNewTemplate(template: state.template));
                  }
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
    ));
  }

  Future<void> openChangeCategoryNameDialog(int index, ReportCategory category) {
    TextEditingController categoryNameController = TextEditingController();
    categoryNameController.text = category.categoryName;
    
    return showDialog(context: context, builder: (BuildContext context){
      return CustomDialog(
        title: "Kategorie hinzufügen",
        child: Form(
          key: editCategoryKey,
          child: TextFormField(
            controller: categoryNameController,
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
          if (editCategoryKey.currentState!.validate()) {
            ReportCategory newCategory = category.copyWith(
                categoryName: categoryNameController.text);

            context
                .read<EditTemplateBloc>()
                .add(UpdateCategory(category: newCategory, categoryIndex: index));
            debugPrint("Added Categorie");
            Navigator.of(context).pop();
          }
        },
      );
    });
  }

}
