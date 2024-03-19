part of 'template_bloc.dart';

abstract class TemplateEvent extends Equatable {
  const TemplateEvent();

  @override
  List<Object> get props => [];
}

class LoadTemplates extends TemplateEvent{
  final List<Template> templates;

  const LoadTemplates({this.templates = const <Template>[]});

  @override
  List<Object> get props => [];
}

class AddTemplate extends TemplateEvent{
  final Template template;

  const AddTemplate({required this.template});

  @override
  List<Object> get props => [template];
}


class UpdateTemplate extends TemplateEvent{
  final Template template;

  const UpdateTemplate({required this.template});

  @override
  List<Object> get props => [template];
}


class DeleteTemplate extends TemplateEvent{
  final Template template;

  const DeleteTemplate({required this.template});

  @override
  List<Object> get props => [template];
}

class AddImage extends TemplateEvent{
  final Template template;
  final ImageSource source;

  const AddImage({required this.template, this.source = ImageSource.camera});

}


