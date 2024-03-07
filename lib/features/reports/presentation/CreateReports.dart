import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:technischer_dienst/features/reports/application/createReportBloc/create_report_bloc.dart';
import 'package:technischer_dienst/features/reports/presentation/components/report_checklist.dart';
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
  final List<ReportCategory> _reportData = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    context
        .read<CreateReportBloc>()
        .add(LoadReportFromTemplate(template: widget.template));
  }

  Future<void> buildDialog(Report report) {
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
                  Report newReport = report.copyWith(
                      reportName: reportNameController.text,
                      inspector: inspectorNameController.text);
                  debugPrint(newReport.reportName);
                  context.read<CreateReportBloc>().add(SaveReport(report: newReport));
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CreateReportBloc, CreateReportState>(
        builder: (context, state) {
          if (state is CreateReportLoading) {
            return const CircularProgressIndicator();
          }

          if (state is TemplateLoaded) {
            return DefaultTabController(
              length: state.report.categories.length,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  title: Text(state.report.ofTemplate),
                  bottom: TabBar(
                    isScrollable: true,
                    tabs: [
                      for (ReportCategory category
                          in state.report.categories) ...{
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
                          for (ReportCategory category
                              in state.report.categories) ...{
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
                    buildDialog(state.report);
                  },
                ),
              ),
            );
          }
          if (state is FailedLoading) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const Center(
              child: Text("Etwas ist schief gelaufen"),
            );
          }
        },
      ),
    );
  }
}
