import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef void StringCallback(String val);
typedef void IntCallback(int index);

class dynamic_form extends StatefulWidget {
  dynamic_form({super.key, this.templateData, required this.onAddedItem,required this.onDeletedItem});

  @override
  State<StatefulWidget> createState() => _dynamic_formState();

  final String title = "Berichtsvorlage erstellen";
  List<String>? templateData;
  final StringCallback onAddedItem;
  final IntCallback onDeletedItem;
}

class _dynamic_formState extends State<dynamic_form> with AutomaticKeepAliveClientMixin<dynamic_form>{
  List<FormFieldData> formFields = [];

  @override
  bool get wantKeepAlive => true;

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
                        child: formFields[index].buildFormField(),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
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
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  formFields.add(FormFieldData());
                  widget.onAddedItem("ItemName");
                });
              },
              child: const Text('Add Field'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle form submission
                // You can access the entered values from formFields list
                for (var field in formFields) {
                  print('Field Name: ${field.name}, Value: ${field.controller.text}');
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class FormFieldData {
  late TextEditingController controller;
  late String name;

  FormFieldData() {
    controller = TextEditingController();
    name = 'Field ${DateTime
        .now()
        .microsecondsSinceEpoch}';
  }

  Widget buildFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: name,
        ),

      ),
    );
  }
}