import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:technischer_dienst/features/reports/presentation/ShowReport.dart';
import 'package:technischer_dienst/Repositories/FileRepository.dart';
import 'package:technischer_dienst/features/templates/presentation/showTemplates.dart';

import '../domain/report.dart';

class ReportList extends StatefulWidget {
  const ReportList({super.key});

  @override
  State<ReportList> createState() => _ReportListState();
}

class _ReportListState extends State<ReportList> {
  final FileRepository _fileRepo = FileRepository();

  List<Report> _reports = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    _fileRepo.readFile("reports.json").then((value) {
      List<dynamic> json = jsonDecode(value);
      debugPrint(json.toString());
      _reports =
          List<dynamic>.from(json).map((e) => Report.fromJson(e)).toList();

      setState(() {
        _reports;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Berichte"),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: const Text("Technischer Dienst"),
              ),
              ListTile(
                  title: const Text("Vorlagen"),
                  leading: const Icon(Icons.file_copy),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            const ShowTemplates(title: "Vorlagen")));
                  })
            ],
          ),
        ),
        body: Center(
          child: ListView.builder(
            itemCount: _reports.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(_reports[index].reportName),
                subtitle: Text(
                    _reports[index].from.toString().replaceRange(19, null, "")),
                leading: const Icon(Icons.file_copy),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ShowReport(
                          report: _reports[index],
                          title: _reports[index].reportName)));
                },
              );
            },
          ),
        ));
  }
}
