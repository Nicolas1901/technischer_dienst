import 'package:flutter/material.dart';

class CheckboxTileBoxOnly extends StatefulWidget {
  final Widget title;
  final bool? value;
  final Function(bool? value) onChanged;
  final Function() onTap;
  final bool tristate = true;

  const CheckboxTileBoxOnly({super.key,
    required this.title,
    required this.value,
    required this.onChanged, required this.onTap});

  @override
  State<CheckboxTileBoxOnly> createState() => _CheckboxTileBoxOnlyState();
}

class _CheckboxTileBoxOnlyState extends State<CheckboxTileBoxOnly> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: widget.title,
      trailing: Checkbox(
        activeColor: _setColor(widget.value),
        value: widget.value,
        tristate: widget.tristate,
        onChanged: widget.onChanged,
      ),
      onTap: widget.onTap,
    );
  }
}

Color? _setColor(bool? value){
  if(value == null){
    return Colors.red;
  } else{
    if(value){
      return Colors.green;
    }
    return null;
  }
}