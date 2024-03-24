import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:todo_list_app/services/hive_datasource.dart';
//import 'package:todo_list_app/services/sql_datasource.dart';
import 'package:todo_list_app/services/remote_api_datasource.dart';
import 'services/idatasource.dart';
import 'models/todo.dart';
import 'models/todo_list.dart';
import 'widgets/todo_widget.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put<IDatasource>(RemoteDatasource());
  runApp(ChangeNotifierProvider(
      create: (context) => TodoList(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 220, 25, 25)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Todo List'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: false,
        actions: [
          Consumer<TodoList>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Text(
                "${model.todoCountComplete}/${model.todoCount}",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: const Color.fromARGB(255, 0, 0, 0)),
              ),
            );
          }),
        ],
      ),
      body: Center(
        child: Consumer<TodoList>(
          builder: (context, model, child) {
            return FutureBuilder<bool>(
              future: model.refresh(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Error loading data, Pull down to refresh..."),
                  );
                }
                if (!snapshot.hasData) {
                  // loading...
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return RefreshIndicator(
                  onRefresh: model.refresh,
                  child: ListView.builder(
                    itemCount: model.todoCount,
                    itemBuilder: (context, index) {
                      Todo todo = model.todos[index];
                      return Dismissible(
                        confirmDismiss: (direction) async {
                          setState(() {
                            model.remove(todo);
                          });
                          return true;
                        },
                        key: Key(todo.id.toString()),
                        background: Container(
                          color: Colors.red,
                          child: const Icon(Icons.delete),
                        ),
                        child: TodoWidget(
                            todo: model.todos[index],
                            widgetColor: todo.complete == true ? Colors.green : Theme.of(context).primaryColor),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTodo,
        tooltip: "Add",
        child: const Icon(Icons.add),
      ),
    );
  }

  // void _markComplete(index, value){
  //   setState(() {
  //     todos[index] = Todo(name: value.name, description: value.description, complete: !value.complete);
  //   });
  // }

  void _openAddTodo() {
    showDialog(
        context: context,
        builder: (context) {
          final TextEditingController nameController = TextEditingController();
          final TextEditingController descriptionController =
              TextEditingController();
          return AlertDialog(
            title: const Text("Add Todo!"),
            content: Form(
              key: _formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: "Name"),
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a name";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: "Description",
                      hintText: "Enter a description..."),
                  controller: descriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a description";
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;
                        setState(() {
                          Provider.of<TodoList>(context, listen: false).add(
                              Todo(
                                  id: 0,
                                  name: nameController.text,
                                  description: descriptionController.text,
                                  complete: false));
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("Add Todo")),
                )
              ]),
            ),
          );
        });
  }
}
