import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list_app/models/todo.dart';

import 'idatasource.dart';

class HiveDatasource implements IDatasource {

  late final Future init;

  Future<void> initalise() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TodoAdapter());
    //Hive.deleteBoxFromDisk('todos');
  }

  HiveDatasource() {
    init = initalise();
  }

  @override
  Future<bool> add(Todo model) async {
    await init;
    Box<Todo> box = Hive.box('todos');
    int key = await box.add(model);
    await box.put(key, Todo(id: key, name: model.name, description: model.description, complete: model.complete));
    return true;
  }

  @override
  Future<List<Todo>> browse() async {
    await init;
    Box<Todo> box = Hive.box('todos');
    if(box.isEmpty) return <Todo>[];
    return box.values.toList().cast();
    
  }

  @override
  Future<bool> delete(Todo model) async {
    await init;
    Box<Todo> box = Hive.box('todos');
    await box.delete(model.id);
    return true;
  }

  @override
  Future<bool> edit(Todo model) async {
    await init;
    Box<Todo> box = Hive.box('todos');
    await box.put(model.id, model);
    return true;
  }

  @override
  Future<Todo?> read(String id) async {
    await init;
    Box<Todo> box = Hive.box('todos');
    Todo? todo = box.get(id);
    return todo;
  }

}