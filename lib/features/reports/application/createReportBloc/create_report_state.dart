part of 'create_report_bloc.dart';

abstract class CreateReportState extends Equatable {
  const CreateReportState();
}

class CreateReportLoading extends CreateReportState {
  @override
  List<Object> get props => [];
}


class TemplateLoaded extends CreateReportState{
  final Report report;

  const TemplateLoaded({required this.report});

  @override
  List<Object> get props => [report];
}


class FailedLoading extends CreateReportState{
  final String message;

  const FailedLoading({required this.message});

  @override
  List<Object> get props => [message];
}


class SavedReport extends CreateReportState{
  final Report report;

  const SavedReport({required this.report});

  @override
  List<Object> get props => [report];
}
