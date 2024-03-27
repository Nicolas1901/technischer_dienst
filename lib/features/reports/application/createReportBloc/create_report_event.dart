part of 'create_report_bloc.dart';

abstract class CreateReportEvent extends Equatable {
  const CreateReportEvent();

  @override
  List<Object> get props => [];
}

class LoadReportFromTemplate extends CreateReportEvent{
  final Template template;

  const LoadReportFromTemplate({required this.template});
}

class LoadReport extends CreateReportEvent{
  final Report report;

  const LoadReport({required this.report});
}

class UpdateItemState extends CreateReportEvent{
  final int categoryIndex;
  final int itemIndex;
  final CategoryItem item;

  const UpdateItemState({required this.categoryIndex, required this.itemIndex, required this.item,});
}

class SaveReport extends CreateReportEvent{
  final Report report;
  final isNew;

  const SaveReport({required this.report, this.isNew = true});
}

class ResetReport extends CreateReportEvent{
}

