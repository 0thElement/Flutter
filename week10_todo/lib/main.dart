import 'package:flutter/material.dart';
import 'bloc/todo_bloc.dart';
import 'data/todo.dart';
import 'todo_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TodoBloc todoBloc;
  List<Todo> todos = [];

  @override
  void initState() {
    todoBloc = TodoBloc();
    super.initState();
  }

  @override
  void dispose() {
    todoBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Todo todo = Todo('', '', '', 0);
    todos = todoBloc.todoList;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Todos"),
      ),
      body: StreamBuilder<List<Todo>>(
        stream: todoBloc.todos,
        initialData: todos,
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                Todo item = snapshot.data![index];
                return Dismissible(
                    key: Key(item.id.toString()),
                    onDismissed: (_) => todoBloc.todoDeleteSink.add(item),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).highlightColor,
                        child: Text(item.priority.toString()),
                      ),
                      title: Text(item.name),
                      subtitle: Text(item.description),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          MaterialPageRoute route = MaterialPageRoute(
                              builder: (_) => TodoScreen(item, false));
                          Navigator.push(context, route);
                        },
                      ),
                    ));
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MaterialPageRoute route =
              MaterialPageRoute(builder: (_) => TodoScreen(todo, true));
          Navigator.push(context, route);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
