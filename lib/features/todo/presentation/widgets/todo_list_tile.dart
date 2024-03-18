import 'package:flutter/material.dart';
import 'package:todo_app_assignment/utils/app_strings.dart';
import '../../data/model/todo.dart';

class TodoListTile extends StatelessWidget {
  const TodoListTile({
    required this.todo,
    super.key,
    this.onToggleCompleted,
    this.onDismissed,
    this.onTap,
  });

  final Todo todo;
  final ValueChanged<bool>? onToggleCompleted;
  final DismissDirectionCallback? onDismissed;
  final VoidCallback? onTap;

  Color? getTileColor(BuildContext context) {
    if (todo.deadline!.difference(DateTime.now()).inDays == 1 ||
        todo.deadline!.difference(DateTime.now()).inDays == 0) {
      return Colors.green;
    } else if (todo.deadline!.difference(DateTime.now()).inDays < 0) {
      return Colors.red;
    }
    return null;
  }

  String? getTitle() {
    if (todo.deadline!.difference(DateTime.now()).inDays == 1 ||
        todo.deadline!.difference(DateTime.now()).inDays == 1 ) {
      return AppStrings.upcoming;
    } else if (todo.deadline!.difference(DateTime.now()).inDays < 0) {
      return AppStrings.due;
    }
    return null;
  }

  String getFormattedDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final captionColor = theme.textTheme.bodySmall?.color;

    return Dismissible(
      key: Key('todo_${todo.id}'),
      onDismissed: onDismissed,
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          todo.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: !todo.isCompleted
              ? null
              : TextStyle(
                  color: captionColor,
                  decoration: TextDecoration.lineThrough,
                ),
        ),
        subtitle: todo.deadline != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(getFormattedDate(todo.deadline!),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: !todo.isCompleted
                          ? null
                          : TextStyle(
                              color: captionColor,
                              decoration: TextDecoration.lineThrough,
                            )),
                  todo.category != null
                      ? Chip(
                          label: Text(todo.category!,
                              style: !todo.isCompleted
                                  ? null
                                  : TextStyle(
                                      color: captionColor,
                                      decoration: TextDecoration.lineThrough,
                                    )))
                      : const SizedBox()
                ],
              )
            : null,
        leading: Checkbox(
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          value: todo.isCompleted,
          onChanged: onToggleCompleted == null
              ? null
              : (value) => onToggleCompleted!(value!),
        ),
        trailing: todo.deadline != null &&
                !todo.isCompleted &&
                getTileColor(context) != null &&
                getTitle() != null
            ? SizedBox(
                width: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 5,
                      backgroundColor: getTileColor(context),
                    ),
                    Text(getTitle()!)
                  ],
                ),
              )
            : const SizedBox(),
      ),
    );
  }
}
