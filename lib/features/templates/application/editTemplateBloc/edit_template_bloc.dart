import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:technischer_dienst/shared/domain/ReportCategory.dart';
import '../../domain/template.dart';
import '../templateBloc/template_bloc.dart';

part 'edit_template_event.dart';

part 'edit_template_state.dart';

class EditTemplateBloc extends Bloc<EditTemplateEvent, EditTemplateState> {
  EditTemplateBloc() : super(EditTemplateLoading()) {
    on<EditTemplateLoad>(_onEditTemplateLoad);
    on<AddCategory>(_onAddCategory);
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

  FutureOr<void> _onAddCategory(
      AddCategory event, Emitter<EditTemplateState> emit) {
    final state = this.state;

    if (state is EditTemplatesLoaded) {
      Template template = state.template;
      template.categories.add(event.category);

      emit(EditTemplatesLoaded(template: template));
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
      template.categories[event.index].items.add(event.item);

      emit(EditTemplatesLoaded(template: template));
    }
  }

  FutureOr<void> _deleteItemFromCategory(
      DeleteItemFromCategory event, Emitter<EditTemplateState> emit) {
    final state = this.state;

    if (state is EditTemplatesLoaded) {
      Template template = state.template;
      template.categories[event.categoryIndex].items.removeAt(event.itemIndex);

      emit(EditTemplatesLoaded(template: template));
    }
  }

  FutureOr<void> _onUpdateItemInCategory(
      UpdateItemInCategory event, Emitter<EditTemplateState> emit) {
    final state = this.state;

    if (state is EditTemplatesLoaded) {
      Template template = state.template;
      template.categories[event.categoryIndex].items[event.itemIndex] =
          CategoryItem(itemName: event.itemName, isChecked: false);

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
}
