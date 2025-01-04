class UpsertTodoModel {
  final String title;
  final String description;
  final bool isDone;

  UpsertTodoModel({
    required this.title,
    required this.description,
    required this.isDone,
  });

  @override
  String toString() =>
      'title: $title | description: $description | isDone: $isDone';

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isDone': isDone,
    };
  }
}
