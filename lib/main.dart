import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_demo/database_config.dart';
import 'package:sembast_demo/models/task_model.dart';
import 'package:sembast_demo/services/todo_service.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      BindingBase.debugZoneErrorsAreFatal = true;

      WidgetsFlutterBinding.ensureInitialized();

      final dbFactory = createDatabaseFactoryIo(
        rootPath: (await getApplicationDocumentsDirectory()).path,
      );

      final dbConfig = DatabaseConfig(dbFactory: dbFactory);

      await dbConfig.configure();

      runApp(
        const MaterialApp(
          home: MainApp(),
        ),
      );
    },
    (error, stack) {
      debugPrint(error.toString());
    },
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final TodoService todoService = TodoService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: todoService.getTasks(),
        builder: (context, snapshot) {
          final data = snapshot.data;

          if (data == null || data.isEmpty) {
            return const Center(
              child: Text('Empty list'),
            );
          }

          return ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                  title: Text(data[index].title),
                  subtitle: Text(data[index].description),
                  leading: GestureDetector(
                    onTap: () {
                      final id = data[index].id;

                      if (id != null) {
                        todoService.updateTask(
                          id,
                          data[index].copyWith(
                            isDone: data[index].isDone,
                          ),
                        );
                      }
                      Future.delayed(
                        const Duration(milliseconds: 500),
                        () {
                          setState(() {});
                        },
                      );
                    },
                    child: data[index].isDone
                        ? const Icon(Icons.check_box)
                        : const Icon(Icons.check_box_outline_blank),
                  ));
            },
            itemCount: data.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Create Todo Form'),
                content: TodoForm(
                  onTapSave: (title, description) {
                    todoService.saveTask(
                      TaskModel.toSave(
                        title: title,
                        description: description,
                        isDone: false,
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Success save data!'),
                      ),
                    );
                    Future.delayed(
                      const Duration(milliseconds: 500),
                      () {
                        setState(() {});
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class TodoForm extends StatefulWidget {
  final void Function(String title, String description)? onTapSave;

  const TodoForm({
    super.key,
    this.onTapSave,
  });

  @override
  State<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              child: TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title *',
                ),
                validator: (value) =>
                    value?.isEmpty == true ? 'Field is required' : null,
              ),
            ),
            Material(
              child: TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description *',
                ),
                validator: (value) =>
                    value?.isEmpty == true ? 'Field is required' : null,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() == true) {
                  widget.onTapSave?.call(
                    _titleController.text,
                    _descriptionController.text,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
