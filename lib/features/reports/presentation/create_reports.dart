import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:technischer_dienst/features/reports/application/createReportBloc/create_report_bloc.dart';
import 'package:technischer_dienst/features/reports/presentation/components/report_checklist.dart';
import 'package:technischer_dienst/shared/presentation/components/dialog.dart';
import '../../../shared/application/connection_bloc/connection_bloc.dart';
import '../domain/report_category.dart';
import '../domain/report.dart';
import '../../templates/domain/template.dart';

//TODO add Support for Maps from existing reports
class CreateReportPage extends StatefulWidget {
  const CreateReportPage({super.key, this.template, this.report});

  final Template? template;
  final Report? report;

  @override
  State<StatefulWidget> createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  bool changesSaved = true;
  bool isConnected = false;
  final _saveReportKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    isConnected = context.read<NetworkBloc>().state is Connected;

    if (widget.template != null) {
      context
          .read<CreateReportBloc>()
          .add(LoadReportFromTemplate(template: widget.template!));
    } else if(widget.report != null){
      context
          .read<CreateReportBloc>()
          .add(LoadReport(report: widget.report!));
    }
  }

  @override
  dispose() {
    debugPrint("createReports disposed");
    super.dispose();
  }

  Future<void> buildDialog(Report report) {
    TextEditingController reportNameController = TextEditingController(text: report.reportName);
    TextEditingController inspectorNameController = TextEditingController(text: report.inspector);

    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Bericht speichern"),
            content: Form(
              key: _saveReportKey,
              child: Column(
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
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('abbrechen'),
                onPressed: () {
                  inspectorNameController.dispose();
                  reportNameController.dispose();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('speichern'),
                onPressed: () {
                  if (_saveReportKey.currentState!.validate()) {
                    Report newReport = report.copyWith(
                        reportName: reportNameController.text,
                        inspector: inspectorNameController.text);

                    context
                        .read<CreateReportBloc>()
                        .add(SaveReport(report: newReport));

                    setState(() {
                      changesSaved = true;
                    });
                    inspectorNameController.dispose();
                    reportNameController.dispose();

                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }
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
            return PopScope(
              canPop: changesSaved,
              onPopInvoked: (didPop) {
                if (didPop) {
                  return;
                }
                _buildUnsavedChangesDialog(state.report);
              },
              child: DefaultTabController(
                length: state.report.categories.length,
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
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
                            for (var (int catIndex, ReportCategory category)
                                in state.report.categories.indexed) ...{
                              ReportChecklist(
                                items: category.items,
                                valueChanged: (int index, CategoryItem item) {
                                  setState(() {
                                    changesSaved = false;
                                  });

                                  context.read<CreateReportBloc>().add(
                                      UpdateItemState(
                                          categoryIndex: catIndex,
                                          itemIndex: index,
                                          item: item));
                                },
                                onTapped: (int index, CategoryItem item) {
                                  _addCommentaryDialog(index, catIndex, item);
                                },
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
                  floatingActionButton: BlocListener<NetworkBloc, NetworkState>(
                    listener: (context, state) {
                      if(state is Disconnected){
                        setState(() {
                          isConnected = false;
                        });
                      }
                      if(state is Connected){
                        setState(() {
                          isConnected = true;
                        });
                      }
                    },
                    child: FloatingActionButton(
                      foregroundColor: isConnected ? null : Theme.of(context).disabledColor,
                      backgroundColor: isConnected ? null : Theme.of(context).disabledColor,
                      child: const Icon(Icons.save),
                      onPressed: () {
                        if (isConnected) {
                          buildDialog(state.report);
                        }
                      },
                    ),
                  ),
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

  Future<void> _buildUnsavedChangesDialog(Report report) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Warnung"),
            content: const Text(
                "Alle Änderungen gehen verloren. Wollen Sie den Bericht verlassen?"),
            actions: [
              TextButton(
                  onPressed: () {
                    context.read<CreateReportBloc>().add(ResetReport());

                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Bericht verlassen")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("abbrechen")),
            ],
          );
        });
  }

  Future<void> _addCommentaryDialog(
      int index, int catIndex, CategoryItem item) {
    final TextEditingController commentController = TextEditingController();
    commentController.text = item.comment;

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            onSave: () {
              CategoryItem newItem =
                  item.copyWith(comment: commentController.text);
              context.read<CreateReportBloc>().add(
                    UpdateItemState(
                        categoryIndex: catIndex,
                        itemIndex: index,
                        item: newItem),
                  );

              setState(() {
                changesSaved = false;
              });
              Navigator.of(context).pop();
            },
            onAbort: () {
              Navigator.of(context).pop();
            },
            title: "Bemerkung",
            child: TextFormField(
              maxLines: null,
              controller: commentController,
              autofocus: true,
            ),
          );
        });
  }
}
