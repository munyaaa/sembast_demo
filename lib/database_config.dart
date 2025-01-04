import 'package:sembast/sembast.dart';
import 'package:synchronized/synchronized.dart';

class DatabaseConfig {
  static const String dbName = 'todos.db';
  static const int kVersion1 = 1;

  final DatabaseFactory dbFactory;
  final lock = Lock(reentrant: true);
  static Database? db;

  DatabaseConfig({
    required this.dbFactory,
  });

  static Database get dbClient =>
      db != null ? db! : throw Exception('Database is not existis');

  Future<void> configure() async {
    db ??= await lock.synchronized<Database?>(
      () async {
        db ??= await open();
        return db;
      },
    );

    if (db == null) {
      throw Exception('Couldn\'t open database');
    }
  }

  Future<Database> openPath(String path) async {
    db = await dbFactory.openDatabase(
      path,
      version: kVersion1,
      onVersionChanged: _onVersionChanged,
    );
    return db!;
  }

  Future<Database> open() async {
    return await openPath(dbName);
  }

  void _onVersionChanged(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < kVersion1) {}
  }
}
