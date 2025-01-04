import 'package:sembast/sembast.dart';
import 'package:sembast_demo/database_config.dart';
import 'package:sembast_demo/models/todo_model.dart';
import 'package:sembast_demo/models/upsert_todo_model.dart';

class TodoService {
  static const String todosStoreName = 'todos';

  final todosStore = intMapStoreFactory.store(todosStoreName);

  Future<void> saveTodo(UpsertTodoModel model) async {
    await todosStore.add(
      DatabaseConfig.dbClient,
      model.toMap(),
    );
  }

  Future<void> updateTodo(int id, UpsertTodoModel model) async {
    await todosStore.record(id).update(
          DatabaseConfig.dbClient,
          model.toMap(),
        );
  }

  Future<List<TodoModel>> getTodos() async {
    return (await todosStore.find(DatabaseConfig.dbClient))
        .map(
          (e) => TodoModel(
            id: e.key,
            title: e.value['title']?.toString() ?? '',
            description: e.value['description']?.toString() ?? '',
            isDone: bool.tryParse(e.value['isDone']?.toString() ?? '') ?? false,
          ),
        )
        .toList();
  }
}
