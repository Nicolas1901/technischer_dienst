part of 'edit_template_bloc.dart';

abstract class EditTemplateEvent extends Equatable {
  const EditTemplateEvent();
}

class EditTemplateLoad extends EditTemplateEvent{
  final Template template;

  const EditTemplateLoad({required this.template});

  @override
  List<Object?> get props => [template];
}



class AddCategory extends EditTemplateEvent{
  final TemplateCategory category;

  const AddCategory({required this.category});

  @override
  List<Object?> get props => [category];
}

class UpdateCategory extends EditTemplateEvent{
  final TemplateCategory category;
  final int categoryIndex;

  const UpdateCategory({required this.categoryIndex, required this.category});

  @override
  List<Object?> get props => [category];
}

class DeleteCategory extends EditTemplateEvent{
  final int index;

  const DeleteCategory({required this.index});

  @override
  List<Object?> get props => [index];
}



class AddItemToCategory extends EditTemplateEvent{
  final String item;
  final int categoryIndex;

  const AddItemToCategory({required this.item, required this.categoryIndex});

  @override
  List<Object?> get props => [item, categoryIndex];
}

class DeleteItemFromCategory extends EditTemplateEvent{
  final int categoryIndex;
  final int itemIndex;

  const DeleteItemFromCategory({
    required this.categoryIndex,
    required this.itemIndex,
  });

  @override
  List<Object?> get props => [categoryIndex, itemIndex];
}

class UpdateItemInCategory extends EditTemplateEvent{
  final int categoryIndex;
  final int itemIndex;
  final String itemName;

  const UpdateItemInCategory({required this.categoryIndex, required this.itemIndex, required this.itemName});

  @override
  List<Object?> get props => [categoryIndex, itemIndex, itemName];
}



class SaveNewTemplate extends EditTemplateEvent{
  final Template template;

  const SaveNewTemplate({required this.template});

  @override
  List<Object?> get props => [template];
}

class SaveModifiedTemplate extends EditTemplateEvent{
  final Template template;

  const SaveModifiedTemplate({required this.template});

  @override
  List<Object?> get props => [template];
}

