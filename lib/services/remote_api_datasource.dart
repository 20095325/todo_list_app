import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list_app/firebase_options.dart';
import 'package:todo_list_app/models/todo.dart';

import 'idatasource.dart';

class RemoteDatasource implements IDatasource {

  late final CollectionReference todosCollection;
  late Future init;

   Future<void> initalise() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    todosCollection = FirebaseFirestore.instance.collection('todos');
  }

  RemoteDatasource() {
    init = initalise();
  }

  @override
  Future<bool> add(Todo model) async {
    await init;
    var todoMap = model.toMap();
    try {
      await todosCollection.add(todoMap);
      return true;
    } catch(e) {
      throw Exception('Invalid Request - Could not update todo');
    }
  }

  @override
  Future<List<Todo>> browse() async {
    await init;
    final QuerySnapshot snapshot = await todosCollection.get();
    return snapshot.docs
      .map((doc) {
        Map<String, dynamic> todo = doc.data() as Map<String, dynamic>;
        todo['id'] = doc.id;
        return Todo.fromMap(todo);
      }).toList();
  }

  @override
  Future<bool> delete(Todo model) async {
    await init;
    try {
      await todosCollection.doc(model.id).delete();
      return true;
    } catch(e) {
      throw Exception('Invalid Request - Could not update todo');
    }
  }

  @override
  Future<bool> edit(Todo model) async {
    await init;
    var todoMap = model.toMap();
    try {
      await todosCollection.doc(model.id).update(todoMap);
      return true;
    } catch(e) {
      throw Exception('Invalid Request - Could not update todo');
    }
  }

  @override
  Future<Todo> read(String id) async {
    await init;
    try {
      DocumentSnapshot doc = await todosCollection.doc(id).get();
      return Todo.fromMap(doc.data() as Map<String, dynamic>);
    } catch(e) {
      throw Exception('Invalid Request - Could not update todo');
    }

  }
}
