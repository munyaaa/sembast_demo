import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_demo/database_config.dart';

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

      runApp(const MainApp());
    },
    (error, stack) {
      debugPrint(error.toString());
    },
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
