import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:technischer_dienst/features/templates/data/templateRepository.dart';
import '../../domain/template.dart';
import '../editTemplateBloc/edit_template_bloc.dart';

part 'template_event.dart';

part 'template_state.dart';

class TemplateBloc extends Bloc<TemplateEvent, TemplateState> {
  final TemplateRepository templateRepository;
  final EditTemplateBloc _editTemplateBloc;
  late StreamSubscription _editTemplateSub;

  TemplateBloc(this.templateRepository, this._editTemplateBloc)
      : super(TemplatesLoading()) {
    on<LoadTemplates>(_onLoadTemplates);
    on<AddTemplate>(_onAddTemplate);
    on<UpdateTemplate>(_onUpdateTemplate);
    on<DeleteTemplate>(_onDeleteTemplate);
    on<AddImage>(_onAddImageToTemplate);

    _editTemplateSub = _editTemplateBloc.stream.listen((state) {
      if (state is ModifiedTemplateSaved) {
        add(UpdateTemplate(template: state.template));
      }

      if (state is NewTemplateSaved) {
        add(AddTemplate(template: state.template));
      }
    });
  }

  Future<FutureOr<void>> _onLoadTemplates(
      LoadTemplates event, Emitter<TemplateState> emit) async {
    try {
      final List<Template> templates = await templateRepository.getAll();
      emit(
        TemplatesLoaded(templates: templates),
      );
    } catch (e) {
      emit(TemplatesError(message: e.toString()));
    }
  }

  FutureOr<void> _onAddTemplate(
      AddTemplate event, Emitter<TemplateState> emit) async{
    final state = this.state;
    if (state is TemplatesLoaded) {
      try {
        final String uid = (await templateRepository.add(event.template)).id;

        Template template = event.template.copyWith(id:  uid);
        emit(
          TemplatesLoaded(
            templates: List.from(state.templates)..add(template),
          ),
        );
      } catch (e) {
        emit(AddFailed(state.templates));
      }
    }
  }

  FutureOr<void> _onUpdateTemplate(
      UpdateTemplate event, Emitter<TemplateState> emit) {
    final state = this.state;

    if (state is TemplatesLoaded) {
      try {
        templateRepository.update(event.template);

        List<Template> templates = (state.templates.map((template) {
          return template.id == event.template.id ? event.template : template;
        })).toList();

        emit(
          TemplatesLoaded(
            templates: templates,
          ),
        );
      } catch (e) {
        emit(UpdateFailed(state.templates));
      }
    }
  }

  FutureOr<void> _onDeleteTemplate(
      DeleteTemplate event, Emitter<TemplateState> emit) {
    final state = this.state;

    if (state is TemplatesLoaded) {
      try {
        templateRepository.delete(event.template.id);

        emit(
          TemplatesLoaded(
            templates: List.from(state.templates)
              ..removeWhere((element) => element.id == event.template.id),
          ),
        );
      } catch (e) {
        emit(DeleteFailed(state.templates));
      }
    }
  }

  Future<FutureOr<void>> _onAddImageToTemplate(
      AddImage event, Emitter<TemplateState> emit) async {
    final state = this.state;

    if (state is TemplatesLoaded) {
      final File? file = await _setImage(event.source);

      if (file != null) {
        final Template template = event.template.copyWith(image: file.path);
        debugPrint("Template image: ${template.image}");
        try {
          templateRepository.update(template, file: file);

          _onUpdateTemplate(UpdateTemplate(template: template), emit);
        } catch (e) {
          emit(UpdateFailed(state.templates));
        }
      }
    }
  }

  Future<XFile?> _pickImage(ImageSource source) async {
    XFile? pickedImage =
        await ImagePicker().pickImage(source: source);
    return pickedImage;
  }

  Future<File?> _setImage(ImageSource source) async {
    final XFile? pickedImage = await _pickImage(source);

    if (pickedImage == null) return null;
    debugPrint("cacheFile: ${pickedImage.path}");
    return File(pickedImage.path);
  }
}
