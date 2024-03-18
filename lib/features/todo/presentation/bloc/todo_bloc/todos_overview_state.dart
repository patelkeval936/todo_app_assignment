part of 'todos_overview_bloc.dart';

enum TodosOverviewStatus { initial, loading, success, failure }

final class TodosOverviewState extends Equatable {
  const TodosOverviewState({
    this.status = TodosOverviewStatus.initial,
    this.todos = const [],
    this.lastDeletedTodo,
  });

  final TodosOverviewStatus status;
  final List<Todo> todos;
  final Todo? lastDeletedTodo;

  TodosOverviewState copyWith({
    TodosOverviewStatus Function()? status,
    List<Todo> Function()? todos,
    Todo? Function()? lastDeletedTodo,
  }) {
    return TodosOverviewState(
      status: status != null ? status() : this.status,
      todos: todos != null ? todos() : this.todos,
      lastDeletedTodo:
          lastDeletedTodo != null ? lastDeletedTodo() : this.lastDeletedTodo,
    );
  }

  @override
  List<Object?> get props => [
        status,
        todos,
        lastDeletedTodo,
      ];
}
