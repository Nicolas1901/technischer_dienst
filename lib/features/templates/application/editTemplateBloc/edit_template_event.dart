part of 'edit_template_bloc.dart';

abstract class EditTemplateEvent extends Equatable {
  const EditTemplateEvent();
}

class UpdateTemplate extends EditTemplateEvent{
  final Template template;

  const UpdateTemplate({required this.template});

  @override
  List<Object?> get props => [];
}

class AddCategory extends EditTemplateEvent{
  final ReportCategory category;

  const AddCategory({required this.category});

  @override
  List<Object?> get props => [];
}

class DeleteCategory extends EditTemplateEvent{
  final int index;

  const DeleteCategory({required this.index});

  @override
  List<Object?> get props => [];
}

class AddItemToCategory extends EditTemplateEvent{
  final CategoryItem item;
  final int index;

  const AddItemToCategory({required this.item, required this.index});

  @override
  List<Object?> get props => [];
}

class DeleteItemFromCategory extends EditTemplateEvent{
  final int categoryIndex;
  final int itemIndex;

  const DeleteItemFromCategory({
    required this.categoryIndex,
    required this.itemIndex,
  });

  @override
  List<Object?> get props => [];
}

