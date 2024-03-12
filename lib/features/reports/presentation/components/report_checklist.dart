import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:technischer_dienst/shared/presentation/components/td_check_box_tile.dart';

import '../../../../shared/domain/report_category.dart';

class ReportChecklist extends StatefulWidget {
  const ReportChecklist({
    super.key,
    required this.items,
    required this.valueChanged,
    required this.onTapped,
    this.readonly = false,
  });

  final List<CategoryItem> items;
  final Function(int index, CategoryItem item) valueChanged;
  final Function(int index, CategoryItem item) onTapped;
  final bool readonly;

  @override
  State<ReportChecklist> createState() => _ReportChecklistState();
}

class _ReportChecklistState extends State<ReportChecklist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            return CheckboxTileBoxOnly(
              title: Text(widget.items[index].itemName),
              value: widget.items[index].isChecked,
              onChanged: (bool? value) {
                  setState(() {
                    widget.items[index].isChecked = value;
                  });
                  widget.valueChanged(index, widget.items[index]);
              },
              onTap: () {
                debugPrint("Tapped");
               widget.onTapped(index, widget.items[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
