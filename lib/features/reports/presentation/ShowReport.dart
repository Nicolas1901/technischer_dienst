import 'dart:io';

import 'package:flutter/material.dart';
import 'package:technischer_dienst/features/reports/presentation/components/report_checklist.dart';
import 'package:technischer_dienst/Helper/mailer.dart';
import 'package:technischer_dienst/shared/domain/ReportCategory.dart';
import '../../../Helper/pdfHelper.dart';
import '../domain/report.dart';

class ShowReport extends StatefulWidget {
  final Report report;
  final String title;

  const ShowReport({super.key, required this.report, required this.title});

  @override
  State<ShowReport> createState() => _ShowReportState();
}

class _ShowReportState extends State<ShowReport> {
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
            contentPadding: EdgeInsets.all(24),
            children: [
              Text("Prüfer: ${widget.report.inspector}"),
              Text("Vorlage: ${widget.report.ofTemplate}"),
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
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
                  icon: const Icon(Icons.more_vert))
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
                  valueChanged: (int index, bool isChecked) {},
                  readonly: true,
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
