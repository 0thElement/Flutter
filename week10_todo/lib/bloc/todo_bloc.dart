import 'dart:async';

import '../data/todo.dart';
import '../data/todo_db.dart';

class TodoBloc {
  static final TodoBloc _singleton = TodoBloc._internal();
  TodoBloc._internal() {
    db = TodoDb();
    getTodos();

    _todosStreamController.stream.listen(returnTodos);
    _todoInsertController.stream.listen(_insertTodo);
    _todoUpdateController.stream.listen(_updateTodo);
    _todoDeleteController.stream.listen(_deleteTodo);
  }

  factory TodoBloc() {
    return _singleton;
  }

  late TodoDb db;
  List<Todo> todoList = [];

  static final _todosStreamController =
      StreamController<List<Todo>>.broadcast();
  static final _todoInsertController = StreamController<Todo>();
  static final _todoUpdateController = StreamController<Todo>();
  static final _todoDeleteController = StreamController<Todo>();

  Stream<List<Todo>> get todos => _todosStreamController.stream;
  StreamSink<List<Todo>> get todosSink => _todosStreamController.sink;
  StreamSink<Todo> get todoInsertSink => _todoInsertController.sink;
  StreamSink<Todo> get todoUpdateSink => _todoUpdateController.sink;
  StreamSink<Todo> get todoDeleteSink => _todoDeleteController.sink;

  Future getTodos() async {
    List<Todo> todos = await db.getTodos();
    todoList = todos;
    todosSink.add(todos);
  }

  List<Todo> returnTodos(todos) {
    return todos;
  }

  void _deleteTodo(Todo todo) {
    db.deleteTodo(todo).then((_) {
      getTodos();
    });
  }

  void _updateTodo(Todo todo) {
    db.updateTodo(todo).then((_) {
      getTodos();
    });
  }

  void _insertTodo(Todo todo) {
    db.insertTodo(todo).then((_) {
      getTodos();
    });
  }

  void dispose() {
    _todosStreamController.close();
    _todoInsertController.close();
    _todoUpdateController.close();
    _todoInsertController.close();
  }
}
