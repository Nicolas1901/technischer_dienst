import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../Helper/mailer.dart';
import '../../../../Helper/pdfHelper.dart';
import '../../domain/report.dart';
import '../createReportBloc/create_report_bloc.dart';

part 'reports_event.dart';

part 'reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  final CreateReportBloc createReportBloc;
  late StreamSubscription _createReportsSub;

  ReportsBloc({required this.createReportBloc}) : super(const ReportsLoading()) {
    on<LoadReportsFromRepo>(_onLoadReportsFromRepo);
    on<AddReport>(_onAddReport);
    on<SendReportPerMail>(_onSendReportPerMail);

    _createReportsSub = createReportBloc.stream.listen((state) {
      if (state is SavedReport) {
        debugPrint("State is SavedReport");
        add(AddReport(report: state.report));
      }
    });
  }

  FutureOr<void> _onLoadReportsFromRepo(
      LoadReportsFromRepo event, Emitter<ReportsState> emit) {
    final state = this.state;

    if (state is AddedLocalReport) {
      List<Report> reports = state.reports;
      reports.addAll(event.reports);
      emit(ReportsLoaded(reports: reports));

    } else if (state is ReportsLoading) {
      emit(ReportsLoaded(reports: event.reports));
    }
  }

  FutureOr<void> _onAddReport(AddReport event, Emitter<ReportsState> emit) {
    final state = this.state;

    if (state is ReportsLoaded) {
      final List<Report> reports = state.reports;
      reports.add(event.report);
      emit(ReportsLoaded(reports: reports));

    } else if (state is ReportsLoading) {
      emit(AddedLocalReport(reports: <Report>[event.report]));
    }
  }

  Future<FutureOr<void>> _onSendReportPerMail(
      SendReportPerMail event, Emitter<ReportsState> emit) async {
    final state = this.state;

    if (state is ReportsLoaded) {
      File file = await PdfHelper.createPdfFromReport(event.report);
      SendMail.send(file.path);
    }
  }
}
