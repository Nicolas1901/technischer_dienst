import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:technischer_dienst/features/reports/application/createReportBloc/create_report_bloc.dart';
import 'package:technischer_dienst/features/reports/presentation/components/report_checklist.dart';
import 'package:technischer_dienst/features/reports/domain/report_category.dart';
import '../../../shared/application/connection_bloc/connection_bloc.dart';
import '../../../shared/presentation/components/dialog.dart';
import '../domain/report.dart';

class ReportDetails extends StatefulWidget {
  final Report report;
  final String title;
  final bool isLocked;

  const ReportDetails(
      {super.key,
      required this.report,
      required this.title,
      required this.isLocked});

  @override
  State<ReportDetails> createState() => _ReportDetailsState();
}

class _ReportDetailsState extends State<ReportDetails> {
  String formattedDate = "";

  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    isConnected = context.read<NetworkBloc>().state is Connected;
    DateTime reportDate = widget.report.from;
    formattedDate = '${reportDate.day}.${reportDate.month}.${reportDate.year}';

    if (!widget.isLocked) {
      context.read<CreateReportBloc>().add(LoadReport(report: widget.report));
    }

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
                  initialValue: item.comment,
                  readOnly: true,
                  maxLines: null,
                ),
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
              for (var (catIndex, c) in widget.report.categories.indexed) ...{
                ReportChecklist(
                  items: c.items,
                  valueChanged: (int index, CategoryItem item) {
                    context.read<CreateReportBloc>().add(UpdateItemState(
                        categoryIndex: catIndex, itemIndex: index, item: item));
                  },
                  readonly: widget.isLocked,
                  onTapped: (int index, CategoryItem item) {
                    if (widget.isLocked) {
                      _commentaryDialog(item);
                    } else {
                      _addCommentaryDialog(index, catIndex, item);
                    }
                  },
                )
              }
            ],
          ),
          floatingActionButton: BlocListener<NetworkBloc, NetworkState>(
            listener: (context, state) {
              if (state is Disconnected) {
                setState(() {
                  isConnected = false;
                });
              }
              if (state is Connected) {
                setState(() {
                  isConnected = true;
                });
              }
            },
            child: FloatingActionButton(
              foregroundColor: isConnected && !widget.isLocked
                  ? null
                  : Theme.of(context).disabledColor,
              backgroundColor: isConnected && !widget.isLocked
                  ? null
                  : Theme.of(context).disabledColor,
              child: const Icon(Icons.save),
              onPressed: () {
                if (isConnected && !widget.isLocked) {
                  var state = context.read<CreateReportBloc>().state;
                  if (state is TemplateLoaded) {
                    context
                        .read<CreateReportBloc>()
                        .add(SaveReport(report: state.report, isNew: false));
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
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
