import 'package:flutter/material.dart';

import '../Models/ReportCategory.dart';

class ReportChecklist extends StatefulWidget {
  const ReportChecklist({super.key, required this.items, required this.valueChanged, this.readonly = false});

  final List<CategoryItem> items;
  final Function(int index, bool isChecked) valueChanged;
  final bool readonly;

  @override
  State<ReportChecklist> createState() => _ReportChecklistState();
}

class _ReportChecklistState extends State<ReportChecklist> {
  List<CategoryItem> checklist = List.empty(growable: true);

  @override
  void initState() {
    super.initState();

    setState(() {
      checklist = widget.items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: checklist.length,
          itemBuilder: (context, index) {
            return CheckboxListTile(
              title: Text(checklist[index].itemName),
              value: checklist[index].isChecked,
              onChanged: (bool? value) {
                if (value != null && !widget.readonly) {
                  setState(() {
                    checklist[index].isChecked = value;

                  });
                  widget.valueChanged(index, value);
                }
                },
            );
          },
        ),
      ),
    );
  }
}

