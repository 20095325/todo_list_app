import 'package:sqflite/sqflite.dart';
import 'idatasource.dart';
import '../models/todo.dart';
import 'package:path/path.dart';

class SQLDatasource implements IDatasource {
  late Database database;
  late Future init;
  final _tableName = 'todos';

  SQLDatasource(){
    init = initalise();
  }

  Future<void> initalise() async {
    database = await openDatabase(join(await getDatabasesPath(), 'todo_data.db'),
    onCreate: (db, version) {
      // runs once when the Database is created
      return db.execute('CREATE TABLE IF NOT EXISTS $_tableName (id INTEGER PRIMARY KEY, name TEXT, description TEXT, complete INTEGER)');
    },
    version: 1);
  }
  @override
  Future<bool> add(Todo model) async {
    await init;
    Map<String, dynamic> todoMap = model.toMap();
    todoMap.update('complete', (value) => 0);
    todoMap.remove('id');
    return await database.insert(_tableName, todoMap) == 0 ? false : true;
  }

  @override
  Future<List<Todo>> browse() async {
    await init;
    List<Map<String, dynamic>> maps = await database.query(_tableName);
    return List.generate(maps.length, (index) {
      return Todo.fromMap(maps[index]);
    });
  }

  @override
  Future<bool> delete(Todo model) async {
    await init;
    return await database.delete(_tableName, where:'id = ?', whereArgs: [model.id]) == 0 ? false : true;
  }

  @override
  Future<bool> edit(Todo model) async {
    await init;
    Map<String, dynamic> todoMap = model.toMap();
    todoMap.update('complete', (value) => value == false ? 0 : 1);
    todoMap.remove('id');
    return await database.update(_tableName, todoMap, where:'id = ?', whereArgs: [model.id]) == 0 ? false : true;
  }

  @override
  Future<Todo> read(String id) async {
    await init;
    List<Map<String, dynamic>> maps = await database.query(_tableName);
    List<Todo> todos = List.generate(maps.length, (index) {
      return Todo.fromMap(maps[index]);
    });
    return todos[0];
  }
  
}