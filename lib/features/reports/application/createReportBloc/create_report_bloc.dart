import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:technischer_dienst/shared/domain/ReportCategory.dart';

import '../../../templates/domain/template.dart';
import '../../domain/report.dart';

part 'create_report_event.dart';

part 'create_report_state.dart';

class CreateReportBloc extends Bloc<CreateReportEvent, CreateReportState> {
  CreateReportBloc() : super(CreateReportLoading()) {
    on<LoadReportFromTemplate>(_onLoadReportFromTemplate);
    on<UpdateItemState>(_onUpdateItemState);
    on<SaveReport>(_onSaveReport);
  }

  FutureOr<void> _onLoadReportFromTemplate(LoadReportFromTemplate event,
      Emitter<CreateReportState> emit) {
    final Report report = Report(id: "",
        reportName: "",
        inspector: "",
        ofTemplate: event.template.name,
        from: DateTime.now(),
        categories: event.template.categories);

    emit(TemplateLoaded(report: report));
  }

  FutureOr<void> _onUpdateItemState(UpdateItemState event,
      Emitter<CreateReportState> emit) {

    final state = this.state;

    if(state is TemplateLoaded){
        state.report.categories[event.categoryIndex].items[event.itemIndex] =  event.item;

        emit(TemplateLoaded(report: state.report));
    }
  }

  FutureOr<void> _onSaveReport(SaveReport event,
      Emitter<CreateReportState> emit) {

    final state = this.state;

    if(state is TemplateLoaded){
      emit(SavedReport(report: state.report));
    }
  }
}