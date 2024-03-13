import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog(
      {super.key,
      required this.onSave,
      required this.onAbort,
      required this.title,
      required this.child});

  final Function() onSave;
  final Function() onAbort;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: child,
      actions: [
        TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            onPressed: onSave,
            child: const Text('speichern')
        ),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          onPressed: onAbort,
          child: const Text('abbrechen'),
        ),
      ],
    );
  }
}
