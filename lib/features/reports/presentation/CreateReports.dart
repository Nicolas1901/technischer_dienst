import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:technischer_dienst/features/reports/application/createReportBloc/create_report_bloc.dart';
import 'package:technischer_dienst/features/reports/presentation/components/report_checklist.dart';
import 'package:technischer_dienst/Constants/Filenames.dart';
import 'package:technischer_dienst/Repositories/FileRepository.dart';
import '../../../shared/domain/ReportCategory.dart';
import '../domain/report.dart';
import '../../templates/domain/template.dart';

//TODO add Support for Maps from existing reports
class CreateReportPage extends StatefulWidget {
  const CreateReportPage({super.key, required this.template});

  final Template template;

  @override
  State<StatefulWidget> createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  final FileRepository _fileRepo = FileRepository();
  final List<ReportCategory> _reportData = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    setState(() {
      _reportData.addAll(widget.template.categories);
    });
  }


  Future<void> buildDialog() {
    TextEditingController reportNameController = TextEditingController();
    TextEditingController inspectorNameController = TextEditingController();

    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Bericht speichern"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: "Berichtname"),
                  controller: reportNameController,
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name eingeben";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Prüfer"),
                  controller: inspectorNameController,
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name eingeben";
                    }
                    return null;
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('abbrechen'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('speichern'),
                onPressed: () {
                  createReport(
                      reportNameController.text, inspectorNameController.text);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<void> createReport(String reportName, String inspector) async {
    Report report = Report(
        id: "",
        reportName: reportName,
        inspector: inspector,
        ofTemplate: widget.template.name,
        from: DateTime.now(),
        categories: _reportData);
    context.read<CreateReportBloc>().add(SaveReport(report: report));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CreateReportBloc, CreateReportState>(
        buildWhen: (previousState, state){
          return (previousState is CreateReportLoading && state is TemplateLoaded);
        },
        builder: (context, state) {
          context.read<CreateReportBloc>().add(LoadReportFromTemplate(template: widget.template));
          if(state is CreateReportLoading){
            return const CircularProgressIndicator();
          }

          if(state is TemplateLoaded){
            return DefaultTabController(
              length: state.report.categories.length,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  title: Text(state.report.ofTemplate),
                  bottom: TabBar(
                    isScrollable: true,
                    tabs: [
                      for (ReportCategory category in state.report.categories) ...{
                        Tab(
                          text: category.categoryName,
                        ),
                      }
                    ],
                  ),
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: TabBarView(
                        children: [
                          for (ReportCategory category in state.report.categories) ...{
                            ReportChecklist(
                              items: category.items,
                              valueChanged: (int index, bool isChecked) {},
                            ),
                          }
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  child: const Icon(Icons.save),
                  onPressed: () {
                    buildDialog();
                  },
                ),
              ),
            );
          } if(state is FailedLoading){
            return Center(child: Text(state.message),);
          } else{
            return const Center(child: Text("Etwas ist schief gelaufen"),);

          }

        },
      ),
    );
  }
}
