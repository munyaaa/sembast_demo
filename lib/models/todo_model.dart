class TodoModel {
  final int id;
  final String title;
  final String description;
  final bool isDone;

  TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isDone,
  });

  @override
  String toString() =>
      'id: $id | title: $title | description: $description | isDone: $isDone';
}
