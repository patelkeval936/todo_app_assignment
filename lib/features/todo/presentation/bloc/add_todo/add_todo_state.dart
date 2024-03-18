part of 'add_todo_bloc.dart';

enum EditTodoStatus { initial, loading, success, failure }

final class AddTodoState extends Equatable {
  const AddTodoState(
      {this.status = EditTodoStatus.initial,
      this.initialTodo,
      this.title = '',
      this.deadline,
      this.category,
      this.isCompleted = false});

  final EditTodoStatus status;
  final Todo? initialTodo;
  final String title;
  final DateTime? deadline;
  final String? category;
  final bool isCompleted;

  bool get isNewTodo => initialTodo == null;

  AddTodoState copyWith(
      {EditTodoStatus? status,
      Todo? initialTodo,
      String? title,
      DateTime? deadline,
      String? category,
      bool? isCompleted}) {
    return AddTodoState(
        category: category ?? this.category,
        status: status ?? this.status,
        initialTodo: initialTodo ?? this.initialTodo,
        title: title ?? this.title,
        deadline: deadline ?? this.deadline,
        isCompleted: isCompleted ?? this.isCompleted);
  }

  @override
  List<Object?> get props =>
      [status, initialTodo, title, deadline, category, isCompleted];
}

extension EditTodoStatusExtension on EditTodoStatus {
  bool get isLoadingOrSuccess => [
    EditTodoStatus.loading,
    EditTodoStatus.success,
  ].contains(this);
}