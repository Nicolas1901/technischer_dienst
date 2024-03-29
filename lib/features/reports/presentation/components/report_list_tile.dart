import 'package:flutter/material.dart';

class ReportListTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final Function() onTapEmail;
  final Function() onTapPdf;
  final Function() onTapLock;
  final Function() onTapTile;
  final bool isLocked;

  const ReportListTile(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.isLocked,
      required this.onTapPdf,
      required this.onTapEmail,
      required this.onTapLock, required this.onTapTile});

  @override
  State<ReportListTile> createState() => _ReportListTileState();
}

class _ReportListTileState extends State<ReportListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      subtitle: Text(widget.subtitle),
      leading: const Icon(Icons.file_copy),
      trailing: Row(
        children: [
          GestureDetector(
            child: Icon(Icons.mail),
            onTap: widget.onTapEmail,
          ),
          GestureDetector(
            child: Icon(Icons.picture_as_pdf),
            onTap: widget.onTapPdf,
          ),
          GestureDetector(
            onTap: widget.onTapLock,
            child: widget.isLocked
                ? const Icon(Icons.lock)
                : const Icon(Icons.lock_open),
          ),
        ],
      ),
      onTap: widget.onTapTile(),
    );
  }
}
