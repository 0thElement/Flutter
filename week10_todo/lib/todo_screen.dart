import 'package:flutter/material.dart';
import 'bloc/todo_bloc.dart';
import 'data/todo.dart';
import 'main.dart';

class TodoScreen extends StatelessWidget {
  TodoScreen(this.todo, this.isNew, {Key? key}) : super(key: key);

  final Todo todo;
  final bool isNew;

  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtDescription = TextEditingController();
  final TextEditingController txtDueDate = TextEditingController();
  final TextEditingController txtPriority = TextEditingController();

  final TodoBloc todoBloc = TodoBloc();

  Future save() async {
    todo.name = txtName.text;
    todo.description = txtDescription.text;
    todo.dueDate = txtDueDate.text;
    todo.priority = int.tryParse(txtPriority.text) ?? 0;

    if (isNew) {
      todoBloc.todoInsertSink.add(todo);
    } else {
      todoBloc.todoUpdateSink.add(todo);
    }
  }

  @override
  Widget build(BuildContext context) {
    const double padding = 20;
    txtName.text = todo.name;
    txtDescription.text = todo.description;
    txtDueDate.text = todo.dueDate;
    txtPriority.text = todo.priority.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(isNew ? 'New item' : 'Update item'),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(padding),
            child: TextField(
              controller: txtName,
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: 'Name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(padding),
            child: TextField(
              controller: txtDescription,
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: 'Description'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(padding),
            child: TextField(
              controller: txtDueDate,
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: 'Due date'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(padding),
            child: TextField(
              controller: txtPriority,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: 'Priority'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(padding),
            child: MaterialButton(
              color: Colors.green,
              child: const Text('Save'),
              onPressed: () {
                save().then((_) => Navigator.pop(context));
              },
            ),
          ),
        ],
      )),
    );
  }
}
