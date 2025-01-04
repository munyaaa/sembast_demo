class TaskModel {
  final int? id;
  final String title;
  final String description;
  final bool isDone;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isDone,
  });

  factory TaskModel.toSave({
    required String title,
    required String description,
    required bool isDone,
  }) {
    return TaskModel(
      id: null,
      title: title,
      description: description,
      isDone: isDone,
    );
  }

  @override
  String toString() =>
      'id: $id | title: $title | description: $description | isDone: $isDone';

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isDone': isDone,
    };
  }

  TaskModel copyWith({bool? isDone}) {
    return TaskModel(
      id: id,
      title: title,
      description: description,
      isDone: isDone ?? this.isDone,
    );
  }
}
