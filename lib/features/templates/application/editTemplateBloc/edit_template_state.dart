part of 'edit_template_bloc.dart';

abstract class EditTemplateState extends Equatable {
  const EditTemplateState();
}

class EditTemplateLoading extends EditTemplateState {
  @override
  List<Object> get props => [];
}

class EditTemplatesLoaded extends EditTemplateState{
  final Template template;

  const EditTemplatesLoaded({required this.template});

  @override
  List<Object?> get props => [template];
}

class ModifiedTemplateSaved extends EditTemplateState{
  final Template template;

  const ModifiedTemplateSaved({required this.template});

  @override
  List<Object?> get props => [template];
}

class NewTemplateSaved extends EditTemplateState{
  final Template template;

  const NewTemplateSaved({required this.template});

  @override
  List<Object?> get props => [template];
}