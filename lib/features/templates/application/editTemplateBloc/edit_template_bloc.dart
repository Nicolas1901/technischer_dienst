import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:technischer_dienst/shared/domain/ReportCategory.dart';

import '../../../../Constants/Filenames.dart';
import '../../domain/template.dart';
import '../templateBloc/template_bloc.dart';

part 'edit_template_event.dart';
part 'edit_template_state.dart';

class EditTemplateBloc extends Bloc<EditTemplateEvent, EditTemplateState> {
  final TemplateBloc templateBloc;
  late StreamSubscription _templateBlocSubscription;

  EditTemplateBloc({required this.templateBloc}) : super(EditTemplateLoading()) {
    on<EditTemplateEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<AddCategory>(_onAddCategory);
    on<DeleteCategory>(_onDeleteCategory);
    on<AddItemToCategory>(_onAddItemToCategory);
    on<DeleteItemFromCategory>(_deleteItemFromCategory);
  }

  FutureOr<void> _onAddCategory(AddCategory event, Emitter<EditTemplateState> emit) {
    final state = this.state;

    if(state is EditTemplatesLoaded){
      Template template = state.template;
      template.categories.add(event.category);

      emit(EditTemplatesLoaded(template: template));
    }
  }

  FutureOr<void> _onDeleteCategory(DeleteCategory event, Emitter<EditTemplateState> emit) {
    final state = this.state;

    if(state is EditTemplatesLoaded){
      Template template = state.template;
      template.categories.removeAt(event.index);

      emit(EditTemplatesLoaded(template: template));
    }
  }

  FutureOr<void> _onAddItemToCategory(AddItemToCategory event, Emitter<EditTemplateState> emit) {
    final state = this.state;

    if(state is EditTemplatesLoaded){
      Template template = state.template;
      template.categories[event.index].items.add(event.item);

      emit(EditTemplatesLoaded(template: template));
    }
  }

  FutureOr<void> _deleteItemFromCategory(DeleteItemFromCategory event, Emitter<EditTemplateState> emit) {
    final state = this.state;

    if(state is EditTemplatesLoaded){


      Template template = state.template;
      template.categories[event.categoryIndex].items.removeAt(event.itemIndex);

      emit(EditTemplatesLoaded(template: template));
    }
  }


}
