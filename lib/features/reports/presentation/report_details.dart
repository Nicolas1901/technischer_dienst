import 'dart:io';

import 'package:flutter/material.dart';
import 'package:technischer_dienst/features/reports/presentation/components/report_checklist.dart';
import 'package:technischer_dienst/Helper/mailer.dart';
import 'package:technischer_dienst/features/reports/domain/report_category.dart';
import '../../../Helper/pdf_helper.dart';
import '../../../shared/presentation/components/dialog.dart';
import '../domain/report.dart';

class ReportDetails extends StatefulWidget {
  final Report report;
  final String title;

  const ReportDetails({super.key, required this.report, required this.title});

  @override
  State<ReportDetails> createState() => _ReportDetailsState();
}

class _ReportDetailsState extends State<ReportDetails> {
  String formattedDate = "";

  @override
  void initState() {
    super.initState();
    DateTime reportDate = widget.report.from;
    formattedDate = '${reportDate.day}.${reportDate.month}.${reportDate.year}';

    setState(() {
      formattedDate;
    });
  }

  void buildDialog() {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(widget.title),
            contentPadding: const EdgeInsets.all(24),
            children: [
              Text("Prüfer: ${widget.report.inspector}"),
              Text("Vorlage: ${widget.report.ofTemplate}"),
            ],
          );
        });
  }

  Future<void> _commentaryDialog(CategoryItem item) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text("Bemerkung"),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: item.comment, readOnly: true, maxLines: null,),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: widget.report.categories.length,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme
                .of(context)
                .colorScheme
                .inversePrimary,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title),
                Text(formattedDate),
              ],
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    buildDialog();
                  },
                  icon: const Icon(Icons.info_outline))
            ],
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                for (ReportCategory c in widget.report.categories) ...{
                  Tab(
                    text: c.categoryName,
                  ),
                }
              ],
            ),
          ),
          body: TabBarView(
            children: [
              for (ReportCategory c in widget.report.categories) ...{
                ReportChecklist(
                  items: c.items,
                  valueChanged: (int index, CategoryItem item) {},
                  readonly: true,
                  onTapped: (int index, CategoryItem item) {
                    _commentaryDialog(item);
                  },
                )
              }
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              File file = await PdfHelper.createPdfFromReport(widget.report);
              SendMail.send(file.path);
            },
            tooltip: 'Berichtsvorlage erstellen',
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
