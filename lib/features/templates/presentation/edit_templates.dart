import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:technischer_dienst/features/templates/application/editTemplateBloc/edit_template_bloc.dart';
import 'package:technischer_dienst/features/templates/domain/template.dart';
import '../../../shared/application/connection_bloc/connection_bloc.dart';
import '../../../shared/presentation/components/dialog.dart';
import '../domain/template_category.dart';
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
  bool isConnected = true;

  @override
  void initState() {
    setState(() {
      isConnected = context.read<NetworkBloc>().state is Connected;
    });

    super.initState();
    context.read<EditTemplateBloc>().add(
        EditTemplateLoad(template: widget.template));
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
                TemplateCategory category = TemplateCategory(
                    categoryName: addController.text, items: []);
                //this is needed to rebuild page and reflect current state properly
                setState(() {});

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
    return Scaffold(body: BlocConsumer<EditTemplateBloc, EditTemplateState>(
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
                    for (var (int index, TemplateCategory category)
                    in state.template.categories.indexed) ...{
                      Tab(
                        child: GestureDetector(
                            onLongPress: () {
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
                      templateData: category.items.map((e) {
                        debugPrint("editTemplate: ${jsonEncode(e)}");
                        return e;
                      }).toList(),
                      onAddedItem: (String itemName) {
                        context.read<EditTemplateBloc>().add(
                            AddItemToCategory(
                                item: itemName, categoryIndex: catIndex));
                      },
                      onDeletedItem: (int index) {
                        context.read<EditTemplateBloc>().add(
                            DeleteItemFromCategory(
                                categoryIndex: catIndex, itemIndex: index));
                      },
                      onUpdateItem: (int index, String itemName) {
                        category.items[index] = itemName;
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
              floatingActionButton: BlocListener<NetworkBloc, NetworkState>(
                listener: (context, state) {
                  if(state is Disconnected){
                    setState(() {
                      isConnected = false;
                    });
                  }
                  if(state is Connected){
                    setState(() {
                      isConnected = true;
                    });
                  }
                },
                child: FloatingActionButton(
                  foregroundColor: isConnected ? null : Theme.of(context).disabledColor,
                  backgroundColor: isConnected ? null : Theme.of(context).disabledColor,
                  child: const Icon(Icons.save),
                  onPressed: () {
                    if (isConnected) {
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
                    }
                  },
                ),
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
      listener: (BuildContext context, EditTemplateState state) {
        if (state is ActionFailed) {
          SnackBar(content: Text(state.message),);
        }
      },
    ));
  }

  Future<void> openChangeCategoryNameDialog(int index,
      TemplateCategory category) {
    TextEditingController categoryNameController = TextEditingController();
    categoryNameController.text = category.categoryName;

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            title: "Kategorie hinzufügen",
            child: Form(
              key: editCategoryKey,
              child: TextFormField(
                controller: categoryNameController,
                autofocus: true,
                decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: (){
                        context.read<EditTemplateBloc>().add(DeleteCategory(index: index));

                        //this is needed to rebuild page and reflect current state properly
                        setState(() {});
                        Navigator.of(context).pop();
                      },
                      child: const Icon(Icons.delete),
                    )
                ),
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
                TemplateCategory newCategory = category.copyWith(
                    categoryName: categoryNameController.text);
                //this is needed to rebuild page and reflect current state properly
                setState(() {});

                context.read<EditTemplateBloc>().add(UpdateCategory(
                    category: newCategory, categoryIndex: index));
                debugPrint("Added Categorie");
                Navigator.of(context).pop();
              }
            },
          );
        });
  }
}
