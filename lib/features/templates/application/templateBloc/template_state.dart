part of 'template_bloc.dart';

abstract class TemplateState extends Equatable {
  const TemplateState();

  @override
  List<Object> get props => [];
}

class TemplatesLoading extends TemplateState {
  @override
  List<Object> get props => [];
}

class TemplatesLoaded extends TemplateState{
  final List<Template> templates;

  const TemplatesLoaded({this.templates = const <Template>[]});

  @override
  List<Object> get props => [templates];
}

class TemplatesError extends TemplateState{
  final String message;

  const TemplatesError({required this.message});
}


class TemplateActionFailed extends TemplatesLoaded{
  final String message ="";
  final List<Template> templates;
  const TemplateActionFailed({this.templates = const <Template>[]});

  @override
  List<Object> get props => [templates];
}

class UpdateFailed extends TemplateActionFailed{
  final String message = "Änderungen konnten nicht gespeichert werden";
  @override
  final List<Template> templates;

  const UpdateFailed(this.templates);
}

class AddFailed extends TemplateActionFailed{
  final String message = "Vorlage konnte nicht hinzugefügt werden";
  @override
  final List<Template> templates;

  const AddFailed(this.templates);
}

class DeleteFailed extends TemplateActionFailed{
  final String message = "Vorlage konnte nicht gelöscht werden";
  @override
  final List<Template> templates;

  const DeleteFailed(this.templates);
}