import '../models/todo.dart';

abstract class IDatasource {
  Future<List<Todo>> browse();
  Future<bool> add(Todo model);
  Future<bool> delete(Todo model);
  Future<Todo?> read(String id);
  Future<bool> edit(Todo model);
}
