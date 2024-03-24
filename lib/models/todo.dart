import 'package:hive/hive.dart';

import '../util.dart' as util;

@HiveType(typeId: 0)
class Todo extends HiveObject{
  @HiveField(0)
  final dynamic id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final bool complete;

  Todo({required this.id, required this.name, required this.description, this.complete = false});

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'name': name,
      'description': description,
      'complete': complete
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      complete: util.getBool(map['complete'])
      );
  }

  @override
  String toString() {
    return "$name - $description";
  }

}

class TodoAdapter extends TypeAdapter<Todo> {
  @override
  Todo read(BinaryReader reader) {
    return Todo(id: reader.read(), name: reader.read(), description: reader.read(), complete: reader.read());
  }

  @override
  int get typeId => 0;

  @override
  void write(BinaryWriter writer, Todo obj) {
    writer.write(obj.id);
    writer.write(obj.name);
    writer.write(obj.description);
    writer.write(obj.complete);
  }
  
}