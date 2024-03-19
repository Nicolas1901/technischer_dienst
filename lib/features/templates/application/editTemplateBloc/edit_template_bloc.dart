import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../domain/template.dart';
import '../../domain/template_category.dart';

part 'edit_template_event.dart';
part 'edit_template_state.dart';

class EditTemplateBloc extends Bloc<EditTemplateEvent, EditTemplateState> {

  EditTemplateBloc() : super(EditTemplateLoading()) {
    on<EditTemplateLoad>(_onEditTemplateLoad);
    on<AddCategory>(_onAddCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<DeleteCategory>(_onDeleteCategory);
    on<AddItemToCategory>(_onAddItemToCategory);
    on<DeleteItemFromCategory>(_deleteItemFromCategory);
    on<UpdateItemInCategory>(_onUpdateItemInCategory);
    on<SaveModifiedTemplate>(_onSaveModifiedTemplate);
    on<SaveNewTemplate>(_onSaveNewTemplate);
  }

  FutureOr<void> _onEditTemplateLoad(EditTemplateLoad event, Emitter<EditTemplateState> emit) {
    emit(EditTemplatesLoaded(template: event.template));
  }

  Future<FutureOr<void>> _onAddCategory(
      AddCategory event, Emitter<EditTemplateState> emit) async {
    final state = this.state;

    if (state is EditTemplatesLoaded) {
      try {
        Template template = state.template;
        template.categories.add(event.category);

        emit(EditTemplatesLoaded(template: template));
      } on Exception catch (e) {
        emit(ActionFailed(template: state.template, message: e.toString()));
      }
    }
  }

  FutureOr<void> _onDeleteCategory(
      DeleteCategory event, Emitter<EditTemplateState> emit) {
    final state = this.state;

    if (state is EditTemplatesLoaded) {
      Template template = state.template;
      template.categories.removeAt(event.index);

      emit(EditTemplatesLoaded(template: template));
    }
  }

  FutureOr<void> _onAddItemToCategory(
      AddItemToCategory event, Emitter<EditTemplateState> emit) {
    final state = this.state;

    if (state is EditTemplatesLoaded) {
      Template template = state.template;
      template.categories[event.categoryIndex].items.add(event.item);

      emit(EditTemplatesLoaded(template: template));
    }
  }

  FutureOr<void> _deleteItemFromCategory(
      DeleteItemFromCategory event, Emitter<EditTemplateState> emit) {
    final state = this.state;

    if (state is EditTemplatesLoaded) {
      Template template = state.template;
      template.categories[event.categoryIndex].items.removeAt(event.itemIndex);
      debugPrint("item deleted");
      emit(EditTemplatesLoaded(template: template));
    }
  }

  FutureOr<void> _onUpdateItemInCategory(
      UpdateItemInCategory event, Emitter<EditTemplateState> emit) {
    final state = this.state;

    if (state is EditTemplatesLoaded) {
      Template template = state.template;
      template.categories[event.categoryIndex].items[event.itemIndex] = event.itemName;

      emit(EditTemplatesLoaded(template: template));
    }
  }



  FutureOr<void> _onSaveModifiedTemplate(SaveModifiedTemplate event, Emitter<EditTemplateState> emit) {
    final state = this.state;

    if(state is EditTemplatesLoaded){
      emit(ModifiedTemplateSaved(template: event.template));
    }
  }

  FutureOr<void> _onSaveNewTemplate(SaveNewTemplate event, Emitter<EditTemplateState> emit) {
    final state = this.state;

    if(state is EditTemplatesLoaded){
      emit(NewTemplateSaved(template: event.template));
    }
  }

  FutureOr<void> _onUpdateCategory(UpdateCategory event, Emitter<EditTemplateState> emit) {
    final state = this.state;

    if(state is EditTemplatesLoaded){
      Template template = state.template;

      template.categories[event.categoryIndex] = event.category;

      emit(EditTemplatesLoaded(template: template));
    }

  }
}
