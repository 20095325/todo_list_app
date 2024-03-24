import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo_list.dart';
import '../models/todo.dart';

class TodoWidget extends StatefulWidget {
  final Todo todo;
  final Color widgetColor;
  const TodoWidget({super.key, required this.todo, required this.widgetColor});

  @override
  State<TodoWidget> createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
              color: widget.widgetColor,
              padding: const EdgeInsets.all(30),
              margin: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.todo.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255)),
                        ),
                        Text(
                          widget.todo.description,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color:
                                      const Color.fromARGB(187, 255, 255, 255)),
                        ),
                      ]),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Provider.of<TodoList>(context, listen: false).updateTodo(
                              Todo(id: widget.todo.id, name: widget.todo.name, description: widget.todo.description, complete: !widget.todo.complete)
                            );
                          });
                        },
                        child: Icon(
                          widget.todo.complete
                          ? Icons.done
                          : Icons.circle_outlined,
                          color: const Color.fromARGB(255, 255, 255, 255),),
                      )
                ],
              ),
            );
  }
}