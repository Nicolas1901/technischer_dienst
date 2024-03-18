import 'package:flutter/material.dart';
import 'package:technischer_dienst/shared/presentation/components/td_check_box_tile.dart';

import '../../domain/report_category.dart';

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
              title: widget.items[index].comment.isNotEmpty
                  ? Text(
                      widget.items[index].itemName,
                      style: const TextStyle(color: Colors.blueAccent),
                    )
                  : Text(widget.items[index].itemName),
              value: widget.items[index].isChecked,
              onChanged: (bool? value) {
                if (!widget.readonly) {
                  setState(() {
                    widget.items[index].isChecked = value;
                  });
                  widget.valueChanged(index, widget.items[index]);
                }
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
