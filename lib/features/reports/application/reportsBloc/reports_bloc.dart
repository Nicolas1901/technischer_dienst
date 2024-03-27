import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:technischer_dienst/features/reports/data/report_repository.dart';

import '../../../../Helper/mailer.dart';
import '../../../../Helper/pdf_helper.dart';
import '../../domain/report.dart';
import '../createReportBloc/create_report_bloc.dart';

part 'reports_event.dart';

part 'reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  final ReportRepository reportRepository;
  final CreateReportBloc createReportBloc;
  late StreamSubscription _createReportsSub;

  ReportsBloc({required this.createReportBloc, required this.reportRepository})
      : super(const ReportsLoading()) {
    on<LoadReportsFromRepo>(_onLoadReportsFromRepo);
    on<AddReport>(_onAddReport);
    on<SendReportPerMail>(_onSendReportPerMail);
    on<ChangeLockStatus>(_onChangeLockStatus);
    on<UpdateReport>(_onUpdateReport);

    _createReportsSub = createReportBloc.stream.listen((state) {
      if (state is SavedReport) {
        if(state.isNew){
          add(AddReport(report: state.report));
        } else{
          add(UpdateReport(report: state.report));
        }
      }
    });
  }

  FutureOr<void> _onLoadReportsFromRepo(
      LoadReportsFromRepo event, Emitter<ReportsState> emit) async {
    final state = this.state;

    try {
      List<Report> reports = await reportRepository.getAll();

      if (state is AddedLocalReport) {
        emit(ReportsLoaded(reports: reports));
      } else if (state is ReportsLoading) {
        emit(ReportsLoaded(reports: reports));
      }
    } on Exception catch (e) {
      emit(ReportsError(message: e.toString()));
    }
  }

  FutureOr<void> _onAddReport(AddReport event, Emitter<ReportsState> emit) async {
    final state = this.state;

    if (state is ReportsLoaded) {
      try {
        final snapshot = await reportRepository.add(event.report);

        final Report report = event.report.copyWith(id: snapshot.id);

        final List<Report> reports = state.reports;
        reports.add(report);
        emit(ReportsLoaded(reports: reports));
      } on Exception catch (e) {
        emit(ReportsError(message: e.toString()));
      }


    } else if (state is ReportsLoading) {
      try {
        final snapshot = await reportRepository.add(event.report);
        final Report report = event.report.copyWith(id: snapshot.id);

        emit(AddedLocalReport(reports: <Report>[report]));
      } on Exception catch (e) {
        emit(ReportsError(message: e.toString()));
      }

    } else if(state is AddedLocalReport){
      try {
        final snapshot = await reportRepository.add(event.report);
        final Report report = event.report.copyWith(id: snapshot.id);

        final List<Report> reports = state.reports;
        reports.add(report);

        emit(AddedLocalReport(reports: reports));
      } on Exception catch (e) {
        emit(ReportsError(message: e.toString()));
      }
    }
  }

  FutureOr<void> _onSendReportPerMail(
      SendReportPerMail event, Emitter<ReportsState> emit) async {
    final state = this.state;

    if (state is ReportsLoaded) {
      File file = await PdfHelper.createPdfFromReport(event.report);
      SendMail.send(file.path);
    }
  }



  FutureOr<void> _onChangeLockStatus(ChangeLockStatus event, Emitter<ReportsState> emit) {
    final state = this.state;

    if(state is ReportsLoaded){
      Report report = state.reports[event.index].copyWith(isLocked: event.isLocked);

      try {
        reportRepository.changeLockState(report.id, report.isLocked);
        state.reports[event.index] = report;
        emit(ReportsLoaded(reports: state.reports));
      } on Exception catch (e) {
        // TODO
      }
    }
  }



  FutureOr<void> _onUpdateReport(UpdateReport event, Emitter<ReportsState> emit) {
    try{
      debugPrint("updated");
      reportRepository.update(event.report);
    } on Exception{
      //TODO
    }
  }
}
