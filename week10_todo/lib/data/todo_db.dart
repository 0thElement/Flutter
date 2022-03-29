import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart';
import 'todo.dart';

class TodoDb {
  static final TodoDb _singleton = TodoDb._internal();
  TodoDb._internal();

  factory TodoDb() {
    return _singleton;
  }

  DatabaseFactory dbFactory = databaseFactoryWeb;
  final store = intMapStoreFactory.store('todos');
  Database? _database;

  Future<Database> get database async {
    if (_database == null) {
      await _openDatabase().then((db) {
        _database = db;
      });
    }
    return _database!;
  }

  Future _openDatabase() async {
    // final docsPath = await getApplicationDocumentsDirectory();
    // final dbPath = join(docsPath.path, 'todos.db');
    final db = await dbFactory.openDatabase('todos');
    return db;
  }

  Future<void> insertTodo(Todo todo) async {
    await database;
    await store.add(_database!, todo.toMap());
  }

  Future<void> updateTodo(Todo todo) async {
    await database;
    final finder = Finder(filter: Filter.byKey(todo.id));
    await store.update(_database!, todo.toMap(), finder: finder);
  }

  Future<void> deleteTodo(Todo todo) async {
    await database;
    final finder = Finder(filter: Filter.byKey(todo.id));
    await store.delete(_database!, finder: finder);
  }

  Future<void> clearTodo() async {
    await database;
    await store.delete(_database!);
  }

  Future<List<Todo>> getTodos() async {
    await database;
    final finder = Finder(sortOrders: [
      SortOrder('priority'),
      SortOrder('id'),
    ]);
    return (await store.find(_database!, finder: finder)).map((snapshot) {
      final todo = Todo.fromMap(snapshot.value);
      todo.id = snapshot.key;
      return todo;
    }).toList();
  }
}
