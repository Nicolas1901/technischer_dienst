import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../Helper/mailer.dart';
import '../../../../Helper/pdfHelper.dart';
import '../../domain/report.dart';
import '../createReportBloc/create_report_bloc.dart';

part 'reports_event.dart';
part 'reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  final CreateReportBloc createReportBloc;

  ReportsBloc({required this.createReportBloc}) : super(ReportsLoading()) {
    on<LoadReportsFromRepo>(_onLoadReports);
    on<AddReport>(_onAddReport);
    on<SendReportPerMail>(_onSendReportPerMail);

    createReportBloc.stream.listen((state) {

      if(state is SavedReport){
        add(AddReport(report: state.report));
      }
    });
  }

  FutureOr<void> _onLoadReports(LoadReportsFromRepo event, Emitter<ReportsState> emit) {
    emit(ReportsLoaded(reports: event.reports));
  }

  FutureOr<void> _onAddReport(AddReport event, Emitter<ReportsState> emit) {
    final state = this.state;

    if(state is ReportsLoaded){
      final List<Report> reports = state.reports;
      reports.add(event.report);

      emit(ReportsLoaded(reports: reports));
    }

  }

  Future<FutureOr<void>> _onSendReportPerMail(SendReportPerMail event, Emitter<ReportsState> emit) async {
    final state = this.state;

    if(state is ReportsLoaded){
      File file = await PdfHelper.createPdfFromReport(event.report);
      SendMail.send(file.path);
    }
  }
}
