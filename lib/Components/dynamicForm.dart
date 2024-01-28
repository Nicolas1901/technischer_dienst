import 'package:flutter/material.dart';

typedef void StringCallback(String val);
typedef void IntCallback(int index);
typedef void IntStringCallback(int index, String val);

class dynamic_form extends StatefulWidget {
  dynamic_form({super.key, required this.templateData, required this.onAddedItem,required this.onDeletedItem, required this.onUpdateItem});

  @override
  State<StatefulWidget> createState() => _dynamic_formState();

  final String title = "Berichtsvorlage erstellen";
  List<String> templateData;
  final StringCallback onAddedItem;
  final IntCallback onDeletedItem;
  final IntStringCallback onUpdateItem;
}

class _dynamic_formState extends State<dynamic_form> with AutomaticKeepAliveClientMixin<dynamic_form>{
  List<FormFieldData> formFields = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState(){
    super.initState();
    for(String item in widget.templateData){
      formFields.add(FormFieldData(name: item));
    }
  }

  Future<void> buildDialog() {
    TextEditingController addController = TextEditingController();
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:const Text("Item hinzufügen"),
            content: TextFormField(
              controller: addController,
              autofocus: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Itemname eingeben";
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
                  setState(() {
                    formFields.add(FormFieldData(name: addController.text));
                    widget.onAddedItem(addController.text);
                  });
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

  @override
  Widget build(BuildContext context) {
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
                            onFocusChange: (hasFocus){
                              if(!hasFocus){
                                widget.onUpdateItem(index, formFields[index].controller.text);
                              }
                            },
                            child: formFields[index].buildFormField()
                        ),
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

  String getValue(){
    return controller.text;
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