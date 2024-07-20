import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/constants/task_status.dart';
import 'package:todo_app/models/todo_model.dart';

// ignore: must_be_immutable
class TodoItem extends StatelessWidget {
  final Todo todo;
  final Function onToDoChanged;
  final Function onDeleteItem;
  late DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");

  TodoItem({
    super.key,
    required this.todo,
    required this.onToDoChanged,
    required this.onDeleteItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          onToDoChanged(todo);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Colors.white,
        leading: Icon(
          todo.isDone == 1 ? Icons.check_box : Icons.check_box_outline_blank,
          color: tdBlue,
        ),
        title: Text(
          "${todo.todoText!} (${getStatus(todo.endDate, todo.isDone)})",
          style: TextStyle(
              fontSize: 16,
              color: tdBlack,
              decoration:
                  (todo.isDone == 1) ? TextDecoration.lineThrough : null),
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Start: ${dateFormat.format(DateTime.parse(todo.createdDate!).toLocal())}",
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              "End: ${dateFormat.format(DateTime.parse(todo.endDate!).toLocal())}",
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.all(0),
          margin: const EdgeInsets.symmetric(vertical: 12),
          height: 35,
          width: 35,
          decoration: BoxDecoration(
              color: tdRed, borderRadius: BorderRadius.circular(5)),
          child: IconButton(
            color: Colors.white,
            iconSize: 18,
            icon: const Icon(Icons.delete),
            onPressed: () {
              // print('Clicked on delete icon');
              onDeleteItem(todo.id);
            },
          ),
        ),
      ),
    );
  }

  String getStatus(String? _endDate, int? isDone) {
    if (isDone == 1) {
      return completed;
    }

    DateTime endDate = DateTime.parse(_endDate!);
    DateTime currentDate = DateTime.now();

    if (endDate.isAfter(currentDate)) {
      return inProgress;
    } else {
      return unComplete;
    }
  }
}
