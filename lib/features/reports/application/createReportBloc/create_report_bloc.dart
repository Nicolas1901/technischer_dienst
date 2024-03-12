import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:technischer_dienst/shared/domain/report_category.dart';

import '../../../templates/domain/template.dart';
import '../../domain/report.dart';

part 'create_report_event.dart';

part 'create_report_state.dart';

class CreateReportBloc extends Bloc<CreateReportEvent, CreateReportState> {
  CreateReportBloc() : super(CreateReportLoading()) {
    on<LoadReportFromTemplate>(_onLoadReportFromTemplate);
    on<UpdateItemState>(_onUpdateItemState);
    on<SaveReport>(_onSaveReport);
    on<ResetReport>(_onResetReport);
  }

  FutureOr<void> _onLoadReportFromTemplate(
      LoadReportFromTemplate event, Emitter<CreateReportState> emit) {
    final Report report = Report(
        id: "",
        reportName: "",
        inspector: "",
        ofTemplate: event.template.name,
        from: DateTime.now(),
        categories: event.template.categories);

    emit(TemplateLoaded(report: report));
  }

  FutureOr<void> _onUpdateItemState(
      UpdateItemState event, Emitter<CreateReportState> emit) {
    final state = this.state;

    if (state is TemplateLoaded) {
      state.report.categories[event.categoryIndex].items[event.itemIndex] =
          event.item;

      emit(TemplateLoaded(report: state.report));
      debugPrint("Update");
    }
  }

  FutureOr<void> _onSaveReport(
      SaveReport event, Emitter<CreateReportState> emit) {
    final state = this.state;
    debugPrint("_onSaveReport: $state");
    if (state is TemplateLoaded) {
      emit(SavedReport(report: event.report));
      debugPrint("_onSaveReport: ${this.state}");
    }
  }

  FutureOr<void> _onResetReport(
      ResetReport event, Emitter<CreateReportState> emit) {
    final state = this.state;

    if (state is TemplateLoaded) {
      final Report report = state.report;

      for (var category in report.categories) {
        for (var item in category.items) {
          item.isChecked = false;
        }
      }

      emit(TemplateLoaded(report: report));
    }
  }
}
