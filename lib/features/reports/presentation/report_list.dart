import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:technischer_dienst/features/reports/application/reportsBloc/reports_bloc.dart';
import 'package:technischer_dienst/features/reports/presentation/show_report.dart';
import 'package:technischer_dienst/features/templates/presentation/show_templates.dart';

import '../application/reportsBloc/MockReports.dart';

class ReportList extends StatefulWidget {
  const ReportList({super.key});

  @override
  State<ReportList> createState() => _ReportListState();
}

class _ReportListState extends State<ReportList> {

  @override
  void initState() {
    super.initState();
    context.read<ReportsBloc>().add(LoadReportsFromRepo(reports: MockReports.generate()));

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
          child: BlocBuilder<ReportsBloc, ReportsState>(
  builder: (context, state) {

    if(state is ReportsLoading){
      return const Center(child: CircularProgressIndicator(),);
    }

    if(state is ReportsLoaded){
      return ListView.builder(
        itemCount: state.reports.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(state.reports[index].reportName),
            subtitle: Text(
                state.reports[index].from.toString().replaceRange(19, null, "")),
            leading: const Icon(Icons.file_copy),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ShowReport(
                      report: state.reports[index],
                      title: state.reports[index].reportName)));
            },
          );
        },
      );
    }
    if(state is ReportsError){
      return Center(child: Text(state.message),);
    } else{
      return const Center(child: Text("Etwas ist schief gelaufen"),);
    }


  },
),
        ));
  }
}
