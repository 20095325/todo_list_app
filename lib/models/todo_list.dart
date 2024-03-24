import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/idatasource.dart';
import 'todo.dart';

// Manages the state of the list of todos
class TodoList extends ChangeNotifier {

  List<Todo> _todos = [];

  UnmodifiableListView<Todo> get todos => UnmodifiableListView(_todos);
  int get todoCount => _todos.length;
  int get todoCountComplete => _todos.where((t) => t.complete == true).length;

  void add(Todo todo) async {
    IDatasource datasource = Get.find();
    final result =  await datasource.add(todo);
    if(result){
      await refresh();
      notifyListeners();
    }
  }

  void removeAll() {
    _todos.clear();
    notifyListeners();
  }

  void remove(Todo todo) async {
    IDatasource datasource = Get.find();
    final result = await datasource.delete(todo);
    if(result){
      await refresh();
      notifyListeners();
    }
  }

    void updateTodo(Todo todo) async {
    IDatasource datasource = Get.find();
    final result = await datasource.edit(todo);
    if(result){
      await refresh();
      notifyListeners();
    }
  }

  Future<bool> refresh() async {
    IDatasource datasource = Get.find();
    _todos = await datasource.browse();
    notifyListeners();
    return true;
  }

}