abstract class CategoryEvent {}

class LoadCategories extends CategoryEvent {}

class CreateCategory extends CategoryEvent {
  final String name;
  final String? description;

  CreateCategory({required this.name, this.description});
}

class DeleteCategory extends CategoryEvent {
  final int id;

  DeleteCategory(this.id);
}
