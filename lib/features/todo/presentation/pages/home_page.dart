import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_assignment/features/todo/presentation/bloc/theme_bloc/theme_cubit.dart';
import 'package:todo_app_assignment/utils/app_strings.dart';
import '../../../../injection_container.dart';
import '../../data/model/todo.dart';
import '../../data/repositories/todos_repository.dart';
import '../bloc/add_todo/add_todo_bloc.dart';
import 'add_todo_page.dart';
import '../bloc/todo_bloc/todos_overview_bloc.dart';
import '../widgets/todo_list_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.todos),
        actions: [
          IconButton(
              onPressed: () {
                context.read<ThemeCubit>().toggleTheme();
              },
              icon: Icon(context.read<ThemeCubit>().state
                  ? Icons.light_mode
                  : Icons.dark_mode)),
        ],
      ),
      body: BlocConsumer<TodosOverviewBloc, TodosOverviewState>(
        listenWhen: (previous, current) =>
            previous.lastDeletedTodo != current.lastDeletedTodo &&
            current.lastDeletedTodo != null,
        listener: (context, state) {
          final messenger = ScaffoldMessenger.of(context);
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text(AppStrings.todoDeletedSuccess),
              ),
            );
        },
        builder: (context, state) {
          if (state.todos.isEmpty) {
            if (state.status == TodosOverviewStatus.loading) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (state.status != TodosOverviewStatus.success) {
              return const SizedBox();
            } else {
              return Center(
                child: Text(
                  AppStrings.noTodos,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              );
            }
          }
          return CupertinoScrollbar(
            child: ListView.separated(
              separatorBuilder: (_, __) {
                return Container(
                  height: 0.4,
                  color: Colors.grey,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                final todo = state.todos[index];
                return TodoListTile(
                  todo: todo,
                  onToggleCompleted: (isCompleted) {
                    context.read<TodosOverviewBloc>().add(
                          TodosOverviewTodoCompletionToggled(
                            todo: todo,
                            isCompleted: isCompleted,
                          ),
                        );
                  },
                  onDismissed: (_) {
                    context
                        .read<TodosOverviewBloc>()
                        .add(TodosOverviewTodoDeleted(todo));
                  },
                  onTap: () {
                    showAddTodoModalSheet(context, todo, true);
                  },
                );
              },
              itemCount: state.todos.length,
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          showAddTodoModalSheet(context, null, false);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void showAddTodoModalSheet(
      BuildContext context, Todo? todo, bool isViewOnly) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return BlocProvider(
          create: (context) => AddTodoBloc(
            todosRepository: sl<TodosRepository>(),
            initialTodo: todo,
          ),
          child: AddTodoPage(
            isViewOnly: isViewOnly,
          ),
        );
      },
    );
  }
}
