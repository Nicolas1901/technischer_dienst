part of 'reports_bloc.dart';

abstract class ReportsEvent extends Equatable {
  const ReportsEvent();
}

class LoadReportsFromRepo extends ReportsEvent{
  final List<Report> reports;

  const LoadReportsFromRepo({this.reports = const <Report>[]});

  @override
  List<Object> get props => [reports];
}

class AddReport extends ReportsEvent{
  final Report report;

  const AddReport({required this.report});

  @override
  List<Object> get props => [report];
}

class SendReportPerMail extends ReportsEvent{
  final Report report;

  const SendReportPerMail({required this.report});

  @override
  List<Object> get props => [report];
}

class ChangeLockStatus extends ReportsEvent{
  final int index;
  final bool isLocked;

  const ChangeLockStatus({required this.isLocked, required this.index});

  @override
  List<Object> get props => [isLocked];
}