part of 'reports_bloc.dart';

abstract class ReportsState extends Equatable {
  const ReportsState();
}

class ReportsLoading extends ReportsState {
  const ReportsLoading();
  @override
  List<Object> get props => [];
}

class AddedLocalReport extends ReportsState{
  final List<Report> reports;

  const AddedLocalReport({required this.reports});

  @override
  List<Object> get props => [reports];
}

class ReportsLoaded extends ReportsState{

  final List<Report> reports;

  const ReportsLoaded({required this.reports});

  @override
  List<Object> get props => [reports];
}

class ReportsError extends ReportsState{
  final String message;

  const ReportsError({required this.message});

  @override
  List<Object> get props => [message];
}
