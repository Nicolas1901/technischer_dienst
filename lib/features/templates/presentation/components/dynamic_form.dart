import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../shared/presentation/components/dialog.dart';

class DynamicForm extends StatefulWidget {
  const DynamicForm(
      {super.key,
      required this.templateData,
      required this.onAddedItem,
      required this.onDeletedItem,
      required this.onUpdateItem});

  @override
  State<StatefulWidget> createState() => _DynamicFormState();

  final String title = "Berichtsvorlage erstellen";
  final List<String> templateData;
  final Function(String val) onAddedItem;
  final Function(int index) onDeletedItem;
  final Function(int index, String val) onUpdateItem;
}

class _DynamicFormState extends State<DynamicForm>
    with AutomaticKeepAliveClientMixin<DynamicForm> {
  List<FormFieldData> formFields = [];

  final formKey = GlobalKey<FormState>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    debugPrint(jsonEncode(widget.templateData));
    for (String item in widget.templateData) {
      formFields.add(FormFieldData(name: item));
    }
  }

  Future<void> buildDialog() {
    TextEditingController addController = TextEditingController();
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            title: "Item hinzufügen",
            child: Form(
              key: formKey,
              child: TextFormField(
                controller: addController,
                autofocus: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Feld darf nicht leer sein";
                  }
                  return null;
                },
              ),
            ),
            onSave: () {
              if (formKey.currentState!.validate()) {
                setState(() {
                  formFields.add(FormFieldData(name: addController.text));
                  widget.onAddedItem(addController.text);
                });
                Navigator.of(context).pop();
              }
            },
            onAbort: () {
              Navigator.of(context).pop();
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: formFields.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: Focus(
                            onFocusChange: (hasFocus) {
                              if (!hasFocus) {
                                widget.onUpdateItem(
                                    index, formFields[index].controller.text);
                              }
                            },
                            child: formFields[index].buildFormField()),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            formFields.removeAt(index);
                            widget.onDeletedItem(index);
                          });
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                buildDialog();
              },
              child: const Text('Add Field'),
            ),
          ],
        ),
      ),
    );
  }
}

class FormFieldData {
  late TextEditingController controller;

  FormFieldData({required String name}) {
    controller = TextEditingController();
    controller.text = name;
  }

  Widget buildFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
      ),
    );
  }
}
