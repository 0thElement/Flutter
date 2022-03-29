class Todo {
  int id = 0;
  String name;
  String description;
  String dueDate;
  int priority;

  Todo(this.name, this.description, this.dueDate, this.priority);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'dueDate': dueDate,
      'priority': priority,
    };
  }

  static Todo fromMap(Map<String, dynamic> map) {
    return Todo(
        map['name'], map['description'], map['dueDate'], map['priority']);
  }
}
