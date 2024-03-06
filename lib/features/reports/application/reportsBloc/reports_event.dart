part of 'reports_bloc.dart';

abstract class ReportsEvent extends Equatable {
  const ReportsEvent();
}

class ReportsInitialize extends ReportsEvent{
  final List<Report> reports;

  const ReportsInitialize({this.reports = const <Report>[]});

  @override
  List<Object> get props => [reports];
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
