import 'package:accordion/accordion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditReportsPage extends StatefulWidget {
  EditReportsPage({super.key, this.templateData});

  @override
  State<StatefulWidget> createState() => _EditReportsPageState();

  final String title = "Berichtsvorlage erstellen";
  List? templateData;
}

class _EditReportsPageState extends State<EditReportsPage> {
  late TextEditingController titleTextController;

  /*@override
  void initState() {
    super.initState();
    titleTextController = TextEditingController(text: "Berichtstitel");
  }*/

  List<FormFieldData> formFields = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Form Example'),
      ),
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
                });
              },
              child: Text('Add Field'),
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
              child: Text('Submit'),
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