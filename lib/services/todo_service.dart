import 'package:sembast/sembast.dart';
import 'package:sembast_demo/database_config.dart';
import 'package:sembast_demo/models/task_model.dart';

class TodoService {
  static const String tasksStoreName = 'tasks';

  final tasksStore = intMapStoreFactory.store(tasksStoreName);

  Future<void> saveTask(TaskModel model) async {
    await tasksStore.add(
      DatabaseConfig.dbClient,
      model.toMap(),
    );
  }

  Future<void> updateTask(int id, TaskModel model) async {
    await tasksStore.record(id).update(
          DatabaseConfig.dbClient,
          model.toMap(),
        );
  }

  Future<List<TaskModel>> getTasks() async {
    return (await tasksStore.find(DatabaseConfig.dbClient))
        .map(
          (e) => TaskModel(
            id: e.key,
            title: e.value['title']?.toString() ?? '',
            description: e.value['description']?.toString() ?? '',
            isDone: bool.tryParse(e.value['isDone']?.toString() ?? '') ?? false,
          ),
        )
        .toList();
  }
}
